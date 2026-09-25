import { WishlistService } from './wishlist.service';
export declare class WishlistController {
    private wishlistService;
    constructor(wishlistService: WishlistService);
    findAll(req: any): Promise<({
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
    toggle(req: any, foodItemId: string): Promise<{
        added: boolean;
    }>;
}
