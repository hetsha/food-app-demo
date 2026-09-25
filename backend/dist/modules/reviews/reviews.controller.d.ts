import { ReviewsService } from './reviews.service';
import { CreateReviewDto } from './dto/create-review.dto';
export declare class ReviewsController {
    private reviewsService;
    constructor(reviewsService: ReviewsService);
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
    create(req: any, dto: CreateReviewDto): Promise<{
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
