import { PrismaService } from '../../config/prisma.service';
export declare class ReviewsService {
    private prisma;
    constructor(prisma: PrismaService);
    findByFood(foodItemId: string): Promise<({
        user: {
            id: string;
            fullName: string | null;
        };
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        rating: number;
        foodItemId: string;
        orderId: string;
        comment: string | null;
        images: import("@prisma/client/runtime/library").JsonValue;
        isApproved: boolean;
    })[]>;
    create(userId: string, dto: {
        foodItemId: string;
        orderId: string;
        rating: number;
        comment?: string;
        images?: string[];
    }): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        rating: number;
        foodItemId: string;
        orderId: string;
        comment: string | null;
        images: import("@prisma/client/runtime/library").JsonValue;
        isApproved: boolean;
    }>;
    findAll(): Promise<({
        user: {
            id: string;
            fullName: string | null;
        };
        foodItem: {
            name: string;
            id: string;
        };
    } & {
        id: string;
        createdAt: Date;
        userId: string;
        rating: number;
        foodItemId: string;
        orderId: string;
        comment: string | null;
        images: import("@prisma/client/runtime/library").JsonValue;
        isApproved: boolean;
    })[]>;
    moderate(id: string, isApproved: boolean): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        rating: number;
        foodItemId: string;
        orderId: string;
        comment: string | null;
        images: import("@prisma/client/runtime/library").JsonValue;
        isApproved: boolean;
    }>;
}
