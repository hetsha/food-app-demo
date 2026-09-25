"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CartService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let CartService = class CartService {
    constructor(prisma) {
        this.prisma = prisma;
        this.foodItemSelect = {
            id: true, name: true, price: true, imageUrls: true,
            isVeg: true, isActive: true, deletedAt: true,
            preparationTimeMinutes: true,
        };
    }
    isFoodAvailable(foodItem) {
        return foodItem.isActive && !foodItem.deletedAt;
    }
    async getCart(userId) {
        let cart = await this.prisma.cart.findUnique({
            where: { userId },
            include: {
                items: {
                    include: {
                        foodItem: { select: this.foodItemSelect },
                    },
                },
            },
        });
        if (!cart) {
            cart = await this.prisma.cart.create({
                data: { userId },
                include: {
                    items: {
                        include: {
                            foodItem: { select: this.foodItemSelect },
                        },
                    },
                },
            });
        }
        const items = cart.items.map((i) => {
            const basePrice = Number(i.foodItem.price);
            const customizationTotal = Array.isArray(i.customizationItems)
                ? i.customizationItems.reduce((s, c) => s + Number(c.additional_price || 0), 0)
                : 0;
            const unitPrice = basePrice + customizationTotal;
            const itemTotal = unitPrice * i.quantity;
            const isAvailable = this.isFoodAvailable(i.foodItem);
            return {
                id: i.id,
                foodItemId: i.foodItemId,
                quantity: i.quantity,
                customizationItems: Array.isArray(i.customizationItems)
                    ? i.customizationItems
                    : [],
                specialInstructions: i.specialInstructions,
                createdAt: i.createdAt,
                foodItem: {
                    id: i.foodItem.id,
                    name: i.foodItem.name,
                    price: basePrice,
                    imageUrls: i.foodItem.imageUrls,
                    isVeg: i.foodItem.isVeg,
                    preparationTimeMinutes: i.foodItem.preparationTimeMinutes,
                },
                unitPrice,
                itemTotal,
                isAvailable,
            };
        });
        const availableItems = items.filter((i) => i.isAvailable);
        const unavailableItems = items.filter((i) => !i.isAvailable);
        const itemTotal = availableItems.reduce((sum, i) => sum + i.itemTotal, 0);
        const itemCount = availableItems.reduce((sum, i) => sum + i.quantity, 0);
        return {
            id: cart.id,
            items: availableItems,
            unavailableItems,
            itemTotal,
            itemCount,
            hasUnavailableItems: unavailableItems.length > 0,
        };
    }
    async addItem(userId, dto) {
        if (dto.quantity < 1) {
            throw new common_1.BadRequestException('Quantity must be at least 1');
        }
        const foodItem = await this.prisma.foodItem.findUnique({
            where: { id: dto.foodItemId },
        });
        if (!foodItem) {
            throw new common_1.NotFoundException('Food item not found');
        }
        if (!foodItem.isActive) {
            throw new common_1.BadRequestException('This item is no longer available');
        }
        if (foodItem.deletedAt) {
            throw new common_1.BadRequestException('This item has been removed');
        }
        let cart = await this.prisma.cart.findUnique({ where: { userId } });
        if (!cart) {
            cart = await this.prisma.cart.create({ data: { userId } });
        }
        if (dto.customizationItems && dto.customizationItems.length > 0) {
            const customGroups = await this.prisma.customizationGroup.findMany({
                where: { foodItemId: dto.foodItemId },
                include: { items: true },
            });
            const validIds = new Set(customGroups.flatMap((g) => g.items.map((i) => i.id)));
            for (const ci of dto.customizationItems) {
                if (ci.customization_item_id && !validIds.has(ci.customization_item_id)) {
                    throw new common_1.BadRequestException(`Invalid customization option: ${ci.customization_item_id}`);
                }
            }
        }
        const existingItem = await this.prisma.cartItem.findFirst({
            where: { cartId: cart.id, foodItemId: dto.foodItemId },
        });
        if (existingItem) {
            return this.prisma.cartItem.update({
                where: { id: existingItem.id },
                data: {
                    quantity: existingItem.quantity + dto.quantity,
                    customizationItems: dto.customizationItems ?? existingItem.customizationItems,
                    specialInstructions: dto.specialInstructions || existingItem.specialInstructions,
                },
            });
        }
        return this.prisma.cartItem.create({
            data: {
                cartId: cart.id,
                foodItemId: dto.foodItemId,
                quantity: dto.quantity,
                customizationItems: dto.customizationItems || [],
                specialInstructions: dto.specialInstructions,
            },
        });
    }
    async updateItem(userId, itemId, quantity) {
        const cart = await this.prisma.cart.findUnique({ where: { userId } });
        if (!cart)
            throw new common_1.NotFoundException('Cart not found');
        const cartItem = await this.prisma.cartItem.findFirst({
            where: { id: itemId, cartId: cart.id },
        });
        if (!cartItem)
            throw new common_1.NotFoundException('Cart item not found');
        if (quantity <= 0) {
            return this.prisma.cartItem.delete({ where: { id: itemId } });
        }
        return this.prisma.cartItem.update({
            where: { id: itemId },
            data: { quantity },
        });
    }
    async removeItem(userId, itemId) {
        const cart = await this.prisma.cart.findUnique({ where: { userId } });
        if (!cart)
            throw new common_1.NotFoundException('Cart not found');
        const cartItem = await this.prisma.cartItem.findFirst({
            where: { id: itemId, cartId: cart.id },
        });
        if (!cartItem)
            throw new common_1.NotFoundException('Cart item not found');
        return this.prisma.cartItem.delete({ where: { id: itemId } });
    }
    async clearCart(userId) {
        const cart = await this.prisma.cart.findUnique({ where: { userId } });
        if (!cart)
            return;
        await this.prisma.cartItem.deleteMany({ where: { cartId: cart.id } });
        return { message: 'Cart cleared' };
    }
    async validateCartForCheckout(userId) {
        const cart = await this.prisma.cart.findUnique({
            where: { userId },
            include: {
                items: {
                    include: {
                        foodItem: true,
                    },
                },
            },
        });
        if (!cart || cart.items.length === 0) {
            throw new common_1.BadRequestException('Cart is empty');
        }
        const errors = [];
        let itemTotal = 0;
        for (const item of cart.items) {
            if (!item.foodItem.isActive) {
                errors.push(`${item.foodItem.name} is no longer available`);
                continue;
            }
            if (item.foodItem.deletedAt) {
                errors.push(`${item.foodItem.name} has been removed`);
                continue;
            }
            const basePrice = Number(item.foodItem.price);
            const customizationTotal = Array.isArray(item.customizationItems)
                ? item.customizationItems.reduce((s, c) => s + Number(c.additional_price || 0), 0)
                : 0;
            itemTotal += (basePrice + customizationTotal) * item.quantity;
        }
        if (errors.length > 0) {
            throw new common_1.BadRequestException({
                message: 'Some items in your cart are no longer available',
                errors,
            });
        }
        if (itemTotal < 1) {
            throw new common_1.BadRequestException(`Minimum order value is ₹1. Current total: ₹${itemTotal}`);
        }
        return {
            isValid: true,
            itemTotal,
            itemCount: cart.items.reduce((sum, i) => sum + i.quantity, 0),
            taxAmount: itemTotal * 0.05,
            platformFee: 2,
            deliveryFee: itemTotal >= 200 ? 0 : 30,
            grandTotal: itemTotal + itemTotal * 0.05 + 2 + (itemTotal >= 200 ? 0 : 30),
        };
    }
};
exports.CartService = CartService;
exports.CartService = CartService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], CartService);
//# sourceMappingURL=cart.service.js.map