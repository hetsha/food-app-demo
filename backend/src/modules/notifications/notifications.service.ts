import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../config/prisma.service';
import { initializeApp, cert, App } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

@Injectable()
export class NotificationsService implements OnModuleInit {
  private readonly logger = new Logger(NotificationsService.name);
  private firebaseApp: App | null = null;

  constructor(
    private prisma: PrismaService,
    private config: ConfigService,
  ) {}

  onModuleInit() {
    this.initializeFirebase();
  }

  private initializeFirebase() {
    const projectId = this.config.get<string>('FIREBASE_PROJECT_ID');
    const privateKey = this.config.get<string>('FIREBASE_PRIVATE_KEY');
    const clientEmail = this.config.get<string>('FIREBASE_CLIENT_EMAIL');

    if (projectId && privateKey && clientEmail) {
      this.firebaseApp = initializeApp({
        credential: cert({
          projectId,
          privateKey: privateKey.replace(/\\n/g, '\n'),
          clientEmail,
        }),
      });
      this.logger.log('Firebase Admin initialized with service account credentials');
    } else {
      this.logger.warn(
        'Firebase credentials not configured. FCM push notifications will be disabled. ' +
        'Set FIREBASE_PROJECT_ID, FIREBASE_PRIVATE_KEY, and FIREBASE_CLIENT_EMAIL env vars.',
      );
    }
  }

  async findAll(userId: string, params?: { skip?: number; take?: number }) {
    return this.prisma.notification.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      skip: params?.skip || 0,
      take: params?.take || 20,
    });
  }

  async markRead(id: string) {
    return this.prisma.notification.update({ where: { id }, data: { isRead: true } });
  }

  async markAllRead(userId: string) {
    await this.prisma.notification.updateMany({
      where: { userId, isRead: false },
      data: { isRead: true },
    });
    return { message: 'All notifications marked as read' };
  }

  async create(userId: string, data: { title: string; body: string; type: string; referenceId?: string }) {
    return this.prisma.notification.create({ data: { userId, ...data } });
  }

  async getUnreadCount(userId: string) {
    const count = await this.prisma.notification.count({
      where: { userId, isRead: false },
    });
    return { count };
  }

  async sendPushNotification(
    userId: string,
    title: string,
    body: string,
    data?: Record<string, string>,
  ): Promise<boolean> {
    if (!this.firebaseApp) {
      this.logger.debug('Firebase not initialized. Skipping push notification.');
      return false;
    }

    try {
      const tokens = await this.prisma.fcmToken.findMany({
        where: { userId, isActive: true },
        select: { token: true },
      });

      if (tokens.length === 0) {
        this.logger.debug(`No active FCM tokens for user ${userId}. Skipping push notification.`);
        return false;
      }

      const messaging = getMessaging(this.firebaseApp);
      const tokenList = tokens.map((t) => t.token);

      const response = await messaging.sendEachForMulticast({
        tokens: tokenList,
        notification: { title, body },
        data: data || {},
        android: { priority: 'high' },
        apns: { payload: { aps: { sound: 'default' } } },
      });

      const failedTokens: string[] = [];
      response.responses.forEach((res, idx) => {
        if (!res.success) {
          failedTokens.push(tokenList[idx]);
          this.logger.warn(`FCM send failed for token: ${res.error?.message}`);
        }
      });

      if (failedTokens.length > 0) {
        await this.prisma.fcmToken.updateMany({
          where: { token: { in: failedTokens } },
          data: { isActive: false },
        });
      }

      this.logger.log(`Push notification sent to user ${userId}: ${response.successCount}/${tokenList.length} succeeded`);
      return response.successCount > 0;
    } catch (error) {
      this.logger.error(`Failed to send push notification to user ${userId}: ${error.message}`);
      return false;
    }
  }

  async sendOrderStatusUpdate(
    userId: string,
    orderId: string,
    status: string,
  ): Promise<void> {
    const statusMessages: Record<string, { title: string; body: string }> = {
      confirmed: { title: 'Order Confirmed', body: `Your order #${orderId} has been confirmed.` },
      preparing: { title: 'Order Being Prepared', body: `Your order #${orderId} is being prepared.` },
      ready: { title: 'Order Ready', body: `Your order #${orderId} is ready for pickup.` },
      out_for_delivery: { title: 'Out for Delivery', body: `Your order #${orderId} is on its way!` },
      delivered: { title: 'Order Delivered', body: `Your order #${orderId} has been delivered. Enjoy!` },
      cancelled: { title: 'Order Cancelled', body: `Your order #${orderId} has been cancelled.` },
    };

    const message = statusMessages[status] || {
      title: 'Order Update',
      body: `Your order #${orderId} status has been updated to ${status}.`,
    };

    await this.create(userId, {
      title: message.title,
      body: message.body,
      type: 'ORDER_UPDATE',
      referenceId: orderId,
    });

    await this.sendPushNotification(userId, message.title, message.body, {
      type: 'ORDER_UPDATE',
      orderId,
      status,
    });
  }

  async sendBulkNotification(
    userIds: string[],
    title: string,
    body: string,
  ): Promise<{ sent: number; failed: number }> {
    let sent = 0;
    let failed = 0;

    for (const userId of userIds) {
      try {
        await this.create(userId, { title, body, type: 'BROADCAST' });
        sent++;
      } catch {
        failed++;
      }
    }

    if (this.firebaseApp) {
      const tokens = await this.prisma.fcmToken.findMany({
        where: { userId: { in: userIds }, isActive: true },
        select: { token: true },
      });

      const validTokens = tokens.map((t) => t.token);

      if (validTokens.length > 0) {
        const messaging = getMessaging(this.firebaseApp);
        const response = await messaging.sendEachForMulticast({
          tokens: validTokens,
          notification: { title, body },
          android: { priority: 'high' },
          apns: { payload: { aps: { sound: 'default' } } },
        });

        const failedTokens: string[] = [];
        response.responses.forEach((res, idx) => {
          if (!res.success) {
            failedTokens.push(validTokens[idx]);
            this.logger.warn(`FCM multicast failed for token: ${res.error?.message}`);
          }
        });

        if (failedTokens.length > 0) {
          await this.prisma.fcmToken.updateMany({
            where: { token: { in: failedTokens } },
            data: { isActive: false },
          });
        }

        this.logger.log(`Bulk push: ${response.successCount} sent, ${response.failureCount} failed`);
      }
    }

    return { sent, failed };
  }
}
