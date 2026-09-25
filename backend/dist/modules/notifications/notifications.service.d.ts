import { OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../config/prisma.service';
export declare class NotificationsService implements OnModuleInit {
    private prisma;
    private config;
    private readonly logger;
    private firebaseApp;
    constructor(prisma: PrismaService, config: ConfigService);
    onModuleInit(): void;
    private initializeFirebase;
    findAll(userId: string, params?: {
        skip?: number;
        take?: number;
    }): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        type: string;
        title: string;
        body: string;
        referenceId: string | null;
        isRead: boolean;
    }[]>;
    markRead(id: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        type: string;
        title: string;
        body: string;
        referenceId: string | null;
        isRead: boolean;
    }>;
    markAllRead(userId: string): Promise<{
        message: string;
    }>;
    create(userId: string, data: {
        title: string;
        body: string;
        type: string;
        referenceId?: string;
    }): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        type: string;
        title: string;
        body: string;
        referenceId: string | null;
        isRead: boolean;
    }>;
    getUnreadCount(userId: string): Promise<{
        count: number;
    }>;
    sendPushNotification(userId: string, title: string, body: string, data?: Record<string, string>): Promise<boolean>;
    sendOrderStatusUpdate(userId: string, orderId: string, status: string): Promise<void>;
    sendBulkNotification(userIds: string[], title: string, body: string): Promise<{
        sent: number;
        failed: number;
    }>;
}
