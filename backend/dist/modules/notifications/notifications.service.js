"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var NotificationsService_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.NotificationsService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const prisma_service_1 = require("../../config/prisma.service");
const app_1 = require("firebase-admin/app");
const messaging_1 = require("firebase-admin/messaging");
let NotificationsService = NotificationsService_1 = class NotificationsService {
    constructor(prisma, config) {
        this.prisma = prisma;
        this.config = config;
        this.logger = new common_1.Logger(NotificationsService_1.name);
        this.firebaseApp = null;
    }
    onModuleInit() {
        this.initializeFirebase();
    }
    initializeFirebase() {
        const projectId = this.config.get('FIREBASE_PROJECT_ID');
        const privateKey = this.config.get('FIREBASE_PRIVATE_KEY');
        const clientEmail = this.config.get('FIREBASE_CLIENT_EMAIL');
        if (projectId && privateKey && clientEmail) {
            this.firebaseApp = (0, app_1.initializeApp)({
                credential: (0, app_1.cert)({
                    projectId,
                    privateKey: privateKey.replace(/\\n/g, '\n'),
                    clientEmail,
                }),
            });
            this.logger.log('Firebase Admin initialized with service account credentials');
        }
        else {
            this.logger.warn('Firebase credentials not configured. FCM push notifications will be disabled. ' +
                'Set FIREBASE_PROJECT_ID, FIREBASE_PRIVATE_KEY, and FIREBASE_CLIENT_EMAIL env vars.');
        }
    }
    async findAll(userId, params) {
        return this.prisma.notification.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
            skip: params?.skip || 0,
            take: params?.take || 20,
        });
    }
    async markRead(id) {
        return this.prisma.notification.update({ where: { id }, data: { isRead: true } });
    }
    async markAllRead(userId) {
        await this.prisma.notification.updateMany({
            where: { userId, isRead: false },
            data: { isRead: true },
        });
        return { message: 'All notifications marked as read' };
    }
    async create(userId, data) {
        return this.prisma.notification.create({ data: { userId, ...data } });
    }
    async getUnreadCount(userId) {
        const count = await this.prisma.notification.count({
            where: { userId, isRead: false },
        });
        return { count };
    }
    async sendPushNotification(userId, title, body, data) {
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
            const messaging = (0, messaging_1.getMessaging)(this.firebaseApp);
            const tokenList = tokens.map((t) => t.token);
            const response = await messaging.sendEachForMulticast({
                tokens: tokenList,
                notification: { title, body },
                data: data || {},
                android: { priority: 'high' },
                apns: { payload: { aps: { sound: 'default' } } },
            });
            const failedTokens = [];
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
        }
        catch (error) {
            this.logger.error(`Failed to send push notification to user ${userId}: ${error.message}`);
            return false;
        }
    }
    async sendOrderStatusUpdate(userId, orderId, status) {
        const statusMessages = {
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
    async sendBulkNotification(userIds, title, body) {
        let sent = 0;
        let failed = 0;
        for (const userId of userIds) {
            try {
                await this.create(userId, { title, body, type: 'BROADCAST' });
                sent++;
            }
            catch {
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
                const messaging = (0, messaging_1.getMessaging)(this.firebaseApp);
                const response = await messaging.sendEachForMulticast({
                    tokens: validTokens,
                    notification: { title, body },
                    android: { priority: 'high' },
                    apns: { payload: { aps: { sound: 'default' } } },
                });
                const failedTokens = [];
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
};
exports.NotificationsService = NotificationsService;
exports.NotificationsService = NotificationsService = NotificationsService_1 = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        config_1.ConfigService])
], NotificationsService);
//# sourceMappingURL=notifications.service.js.map