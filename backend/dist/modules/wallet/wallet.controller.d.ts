import { WalletService } from './wallet.service';
export declare class WalletController {
    private walletService;
    constructor(walletService: WalletService);
    getBalance(req: any): Promise<{
        balance: number;
    }>;
    getTransactions(req: any, skip?: string, take?: string): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        type: import(".prisma/client").$Enums.WalletTransactionType;
        amount: import("@prisma/client/runtime/library").Decimal;
        referenceOrderId: string | null;
    }[]>;
}
