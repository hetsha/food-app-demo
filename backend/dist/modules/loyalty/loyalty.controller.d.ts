import { LoyaltyService } from './loyalty.service';
export declare class LoyaltyController {
    private loyaltyService;
    constructor(loyaltyService: LoyaltyService);
    getBalance(req: any): Promise<{
        points: number;
    }>;
    getTransactions(req: any): Promise<{
        description: string;
        id: string;
        createdAt: Date;
        userId: string;
        referenceOrderId: string | null;
        points: number;
        transactionType: string;
    }[]>;
}
