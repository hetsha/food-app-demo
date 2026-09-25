import { CartService } from './cart.service';
import { AddCartItemDto } from './dto/add-cart-item.dto';
import { UpdateCartItemDto } from './dto/update-cart-item.dto';
export declare class CartController {
    private cartService;
    constructor(cartService: CartService);
    getCart(req: any): Promise<{
        id: string;
        items: {
            id: string;
            foodItemId: string;
            quantity: number;
            customizationItems: import("@prisma/client/runtime/library").JsonArray;
            specialInstructions: string | null;
            createdAt: Date;
            foodItem: {
                id: string;
                name: string;
                price: number;
                imageUrls: import("@prisma/client/runtime/library").JsonValue;
                isVeg: boolean;
                preparationTimeMinutes: number;
            };
            unitPrice: any;
            itemTotal: number;
            isAvailable: boolean;
        }[];
        unavailableItems: {
            id: string;
            foodItemId: string;
            quantity: number;
            customizationItems: import("@prisma/client/runtime/library").JsonArray;
            specialInstructions: string | null;
            createdAt: Date;
            foodItem: {
                id: string;
                name: string;
                price: number;
                imageUrls: import("@prisma/client/runtime/library").JsonValue;
                isVeg: boolean;
                preparationTimeMinutes: number;
            };
            unitPrice: any;
            itemTotal: number;
            isAvailable: boolean;
        }[];
        itemTotal: number;
        itemCount: number;
        hasUnavailableItems: boolean;
    }>;
    addItem(req: any, dto: AddCartItemDto): Promise<{
        updatedAt: Date;
        id: string;
        createdAt: Date;
        foodItemId: string;
        cartId: string;
        quantity: number;
        customizationItems: import("@prisma/client/runtime/library").JsonValue;
        specialInstructions: string | null;
    }>;
    updateItem(req: any, itemId: string, dto: UpdateCartItemDto): Promise<{
        updatedAt: Date;
        id: string;
        createdAt: Date;
        foodItemId: string;
        cartId: string;
        quantity: number;
        customizationItems: import("@prisma/client/runtime/library").JsonValue;
        specialInstructions: string | null;
    }>;
    removeItem(req: any, itemId: string): Promise<{
        updatedAt: Date;
        id: string;
        createdAt: Date;
        foodItemId: string;
        cartId: string;
        quantity: number;
        customizationItems: import("@prisma/client/runtime/library").JsonValue;
        specialInstructions: string | null;
    }>;
    clearCart(req: any): Promise<{
        message: string;
    } | undefined>;
    validateCart(req: any): Promise<{
        isValid: boolean;
        itemTotal: number;
        itemCount: number;
        taxAmount: number;
        platformFee: number;
        deliveryFee: number;
        grandTotal: number;
    }>;
}
