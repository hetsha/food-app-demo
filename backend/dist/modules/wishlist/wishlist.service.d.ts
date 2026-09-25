import { PrismaService } from '../../config/prisma.service';
export declare class WishlistService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(userId: string): Promise<({
        foodItem: {
            name: string;
            id: string;
            isVeg: boolean;
            price: import("@prisma/client/runtime/library").Decimal;
            imageUrls: import("@prisma/client/runtime/library").JsonValue;
            rating: import("@prisma/client/runtime/library").Decimal;
        };
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        foodItemId: string;
    })[]>;
    toggle(userId: string, foodItemId: string): Promise<{
        added: boolean;
    }>;
}
