import { BannersService } from './banners.service';
export declare class BannersController {
    private bannersService;
    constructor(bannersService: BannersService);
    findActive(): Promise<{
        id: string;
        createdAt: Date;
        isActive: boolean;
        title: string;
        displayOrder: number;
        startDate: Date;
        endDate: Date;
        subtitle: string | null;
        imageUrl: string;
        clickAction: string | null;
        actionValue: string | null;
    }[]>;
    findAll(): Promise<{
        id: string;
        createdAt: Date;
        isActive: boolean;
        title: string;
        displayOrder: number;
        startDate: Date;
        endDate: Date;
        subtitle: string | null;
        imageUrl: string;
        clickAction: string | null;
        actionValue: string | null;
    }[]>;
    create(dto: any): Promise<{
        id: string;
        createdAt: Date;
        isActive: boolean;
        title: string;
        displayOrder: number;
        startDate: Date;
        endDate: Date;
        subtitle: string | null;
        imageUrl: string;
        clickAction: string | null;
        actionValue: string | null;
    }>;
    update(id: string, dto: any): Promise<{
        id: string;
        createdAt: Date;
        isActive: boolean;
        title: string;
        displayOrder: number;
        startDate: Date;
        endDate: Date;
        subtitle: string | null;
        imageUrl: string;
        clickAction: string | null;
        actionValue: string | null;
    }>;
    remove(id: string): Promise<{
        id: string;
        createdAt: Date;
        isActive: boolean;
        title: string;
        displayOrder: number;
        startDate: Date;
        endDate: Date;
        subtitle: string | null;
        imageUrl: string;
        clickAction: string | null;
        actionValue: string | null;
    }>;
}
