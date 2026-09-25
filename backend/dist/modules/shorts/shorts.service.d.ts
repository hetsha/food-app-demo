import { PrismaService } from '../../config/prisma.service';
export declare class ShortsService {
    private prisma;
    constructor(prisma: PrismaService);
    findAll(params?: {
        skip?: number;
        take?: number;
        categoryId?: string;
    }): Promise<({
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
    toggleLike(userId: string, shortId: string): Promise<{
        liked: boolean;
    }>;
    incrementViews(shortId: string): Promise<void>;
}
