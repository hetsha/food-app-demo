import { PrismaService } from '../../config/prisma.service';
export declare class UsersService {
    private prisma;
    constructor(prisma: PrismaService);
    findByPhoneNumber(phoneNumber: string): Promise<{
        updatedAt: Date;
        id: string;
        phoneNumber: string;
        email: string | null;
        fullName: string | null;
        passwordHash: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        walletBalance: import("@prisma/client/runtime/library").Decimal;
        isBlocked: boolean;
        createdAt: Date;
    } | null>;
    findById(id: string): Promise<{
        updatedAt: Date;
        id: string;
        phoneNumber: string;
        email: string | null;
        fullName: string | null;
        passwordHash: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        walletBalance: import("@prisma/client/runtime/library").Decimal;
        isBlocked: boolean;
        createdAt: Date;
    } | null>;
    create(data: {
        phoneNumber: string;
        role?: any;
    }): Promise<{
        updatedAt: Date;
        id: string;
        phoneNumber: string;
        email: string | null;
        fullName: string | null;
        passwordHash: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        walletBalance: import("@prisma/client/runtime/library").Decimal;
        isBlocked: boolean;
        createdAt: Date;
    }>;
    update(id: string, data: {
        fullName?: string;
        email?: string;
    }): Promise<{
        updatedAt: Date;
        id: string;
        phoneNumber: string;
        email: string | null;
        fullName: string | null;
        passwordHash: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        walletBalance: import("@prisma/client/runtime/library").Decimal;
        isBlocked: boolean;
        createdAt: Date;
    }>;
    findAll(params: {
        skip?: number;
        take?: number;
        where?: any;
    }): Promise<{
        updatedAt: Date;
        id: string;
        phoneNumber: string;
        email: string | null;
        fullName: string | null;
        passwordHash: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        walletBalance: import("@prisma/client/runtime/library").Decimal;
        isBlocked: boolean;
        createdAt: Date;
    }[]>;
    count(where?: any): Promise<number>;
}
