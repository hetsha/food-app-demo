import { PrismaService } from '../../config/prisma.service';
export declare class AddressesService {
    private prisma;
    constructor(prisma: PrismaService);
    private toPlain;
    findAll(userId: string): Promise<any[]>;
    create(userId: string, dto: any): Promise<any>;
    update(id: string, userId: string, dto: any): Promise<any>;
    remove(id: string, userId: string): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        phone: string;
        label: string;
        addressLine1: string;
        addressLine2: string | null;
        city: string;
        state: string;
        postalCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal;
        longitude: import("@prisma/client/runtime/library").Decimal;
        isDefault: boolean;
    }>;
}
