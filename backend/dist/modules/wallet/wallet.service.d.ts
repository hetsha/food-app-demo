import { PrismaService } from '../../config/prisma.service';
export declare class WalletService {
    private prisma;
    constructor(prisma: PrismaService);
    getBalance(userId: string): Promise<{
        balance: number;
    }>;
    getTransactions(userId: string, params?: {
        skip?: number;
        take?: number;
    }): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        type: import(".prisma/client").$Enums.WalletTransactionType;
        amount: import("@prisma/client/runtime/library").Decimal;
        referenceOrderId: string | null;
    }[]>;
    debit(userId: string, amount: number, description: string, orderId?: string): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        type: import(".prisma/client").$Enums.WalletTransactionType;
        amount: import("@prisma/client/runtime/library").Decimal;
        referenceOrderId: string | null;
    }>;
    credit(userId: string, amount: number, description: string, orderId?: string): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        type: import(".prisma/client").$Enums.WalletTransactionType;
        amount: import("@prisma/client/runtime/library").Decimal;
        referenceOrderId: string | null;
    }>;
}
