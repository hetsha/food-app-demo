import { ShortsService } from './shorts.service';
export declare class ShortsController {
    private shortsService;
    constructor(shortsService: ShortsService);
    findAll(skip?: string, take?: string, categoryId?: string): Promise<({
        category: {
            name: string;
            id: string;
        } | null;
        foodItem: {
            name: string;
            id: string;
            price: import("@prisma/client/runtime/library").Decimal;
            imageUrls: import("@prisma/client/runtime/library").JsonValue;
        } | null;
    } & {
        id: string;
        createdAt: Date;
        isActive: boolean;
        categoryId: string | null;
        videoUrl: string;
        foodItemId: string | null;
        thumbnailUrl: string;
        caption: string | null;
        likesCount: number;
        viewsCount: number;
    })[]>;
    view(id: string): Promise<void>;
    like(id: string, req: any): Promise<{
        liked: boolean;
    }>;
}
