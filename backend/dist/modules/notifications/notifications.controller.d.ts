import { NotificationsService } from './notifications.service';
declare class SendTestDto {
    userId: string;
    title: string;
    body: string;
}
export declare class NotificationsController {
    private notificationsService;
    constructor(notificationsService: NotificationsService);
    findAll(req: any, skip?: string, take?: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        type: string;
        title: string;
        body: string;
        referenceId: string | null;
        isRead: boolean;
    }[]>;
    getUnreadCount(req: any): Promise<{
        count: number;
    }>;
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
    markAllRead(req: any): Promise<{
        message: string;
    }>;
    sendTest(dto: SendTestDto): Promise<{
        success: boolean;
        message: string;
    }>;
}
export {};
