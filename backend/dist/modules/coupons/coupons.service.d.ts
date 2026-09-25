import { PrismaService } from '../../config/prisma.service';
export declare class CouponsService {
    private prisma;
    constructor(prisma: PrismaService);
    validate(code: string, userId: string, orderValue: number): Promise<{
        valid: boolean;
        message: string;
        discount?: undefined;
        couponCode?: undefined;
    } | {
        valid: boolean;
        discount: number;
        couponCode: string;
        message?: undefined;
    }>;
    findAll(): Promise<{
        description: string | null;
        id: string;
        createdAt: Date;
        isActive: boolean;
        expiresAt: Date;
        code: string;
        discountType: string;
        discountValue: import("@prisma/client/runtime/library").Decimal;
        minOrderValue: import("@prisma/client/runtime/library").Decimal | null;
        maxDiscountValue: import("@prisma/client/runtime/library").Decimal | null;
        maxUses: number | null;
        maxUsesPerUser: number | null;
        currentUses: number;
        isFirstOrderOnly: boolean;
    }[]>;
    create(data: any): Promise<{
        description: string | null;
        id: string;
        createdAt: Date;
        isActive: boolean;
        expiresAt: Date;
        code: string;
        discountType: string;
        discountValue: import("@prisma/client/runtime/library").Decimal;
        minOrderValue: import("@prisma/client/runtime/library").Decimal | null;
        maxDiscountValue: import("@prisma/client/runtime/library").Decimal | null;
        maxUses: number | null;
        maxUsesPerUser: number | null;
        currentUses: number;
        isFirstOrderOnly: boolean;
    }>;
    update(id: string, data: any): Promise<{
        description: string | null;
        id: string;
        createdAt: Date;
        isActive: boolean;
        expiresAt: Date;
        code: string;
        discountType: string;
        discountValue: import("@prisma/client/runtime/library").Decimal;
        minOrderValue: import("@prisma/client/runtime/library").Decimal | null;
        maxDiscountValue: import("@prisma/client/runtime/library").Decimal | null;
        maxUses: number | null;
        maxUsesPerUser: number | null;
        currentUses: number;
        isFirstOrderOnly: boolean;
    }>;
    remove(id: string): Promise<{
        description: string | null;
        id: string;
        createdAt: Date;
        isActive: boolean;
        expiresAt: Date;
        code: string;
        discountType: string;
        discountValue: import("@prisma/client/runtime/library").Decimal;
        minOrderValue: import("@prisma/client/runtime/library").Decimal | null;
        maxDiscountValue: import("@prisma/client/runtime/library").Decimal | null;
        maxUses: number | null;
        maxUsesPerUser: number | null;
        currentUses: number;
        isFirstOrderOnly: boolean;
    }>;
}
