import { PrismaService } from '../../config/prisma.service';
export declare class CategoriesService {
    private prisma;
    constructor(prisma: PrismaService);
    findAllActive(): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }[]>;
    findAll(): Promise<({
        _count: {
            foodItems: number;
        };
    } & {
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    })[]>;
    findOne(id: string): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
    create(data: {
        name: string;
        icon?: string;
        displayOrder?: number;
    }): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
    update(id: string, data: {
        name?: string;
        icon?: string;
        displayOrder?: number;
        isActive?: boolean;
    }): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
    reorder(items: {
        id: string;
        displayOrder: number;
    }[]): Promise<{
        message: string;
    }>;
    deactivate(id: string): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
    activate(id: string): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
}
