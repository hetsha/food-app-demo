import { PrismaService } from '../../config/prisma.service';
export declare class LoyaltyService {
    private prisma;
    constructor(prisma: PrismaService);
    getBalance(userId: string): Promise<{
        points: number;
    }>;
    getTransactions(userId: string): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        referenceOrderId: string | null;
        points: number;
        transactionType: string;
    }[]>;
    earn(userId: string, orderId: string, amount: number): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        referenceOrderId: string | null;
        points: number;
        transactionType: string;
    }>;
    redeem(userId: string, orderId: string, points: number): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        referenceOrderId: string | null;
        points: number;
        transactionType: string;
    }>;
}
