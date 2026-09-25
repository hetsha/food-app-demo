import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { ReorderCategoriesDto } from './dto/reorder-categories.dto';
export declare class CategoriesController {
    private categoriesService;
    constructor(categoriesService: CategoriesService);
    findAll(): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }[]>;
    findOne(id: string): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
    findAllAdmin(): Promise<({
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
    create(dto: CreateCategoryDto): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
    }>;
    update(id: string, dto: UpdateCategoryDto): Promise<{
        name: string;
        id: string;
        createdAt: Date;
        isActive: boolean;
        icon: string;
        displayOrder: number;
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
    reorder(dto: ReorderCategoriesDto): Promise<{
        message: string;
    }>;
}
