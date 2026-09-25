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
exports.CouponsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let CouponsService = class CouponsService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async validate(code, userId, orderValue) {
        const coupon = await this.prisma.coupon.findUnique({ where: { code } });
        if (!coupon)
            return { valid: false, message: 'Coupon not found' };
        if (!coupon.isActive)
            return { valid: false, message: 'Coupon is inactive' };
        if (new Date() > coupon.expiresAt)
            return { valid: false, message: 'Coupon expired' };
        if (coupon.minOrderValue && orderValue < Number(coupon.minOrderValue)) {
            return { valid: false, message: `Minimum order value ₹${coupon.minOrderValue}` };
        }
        if (coupon.maxUses && coupon.currentUses >= coupon.maxUses) {
            return { valid: false, message: 'Coupon usage limit reached' };
        }
        if (coupon.isFirstOrderOnly) {
            const orderCount = await this.prisma.order.count({ where: { userId } });
            if (orderCount > 0)
                return { valid: false, message: 'First order only coupon' };
        }
        const userUsage = await this.prisma.couponUsage.count({
            where: { couponId: coupon.id, userId },
        });
        if (coupon.maxUsesPerUser && userUsage >= coupon.maxUsesPerUser) {
            return { valid: false, message: 'You have already used this coupon' };
        }
        let discount = 0;
        if (coupon.discountType === 'percentage') {
            discount = Math.min(orderValue * (Number(coupon.discountValue) / 100), coupon.maxDiscountValue ? Number(coupon.maxDiscountValue) : Infinity);
        }
        else {
            discount = Number(coupon.discountValue);
        }
        return { valid: true, discount, couponCode: coupon.code };
    }
    async findAll() {
        return this.prisma.coupon.findMany({ orderBy: { createdAt: 'desc' } });
    }
    async create(data) {
        return this.prisma.coupon.create({ data });
    }
    async update(id, data) {
        return this.prisma.coupon.update({ where: { id }, data });
    }
    async remove(id) {
        return this.prisma.coupon.delete({ where: { id } });
    }
};
exports.CouponsService = CouponsService;
exports.CouponsService = CouponsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], CouponsService);
//# sourceMappingURL=coupons.service.js.map