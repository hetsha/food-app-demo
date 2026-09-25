import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class CouponsService {
  constructor(private prisma: PrismaService) {}

  async validate(code: string, userId: string, orderValue: number) {
    const coupon = await this.prisma.coupon.findUnique({ where: { code } });
    if (!coupon) return { valid: false, message: 'Coupon not found' };
    if (!coupon.isActive) return { valid: false, message: 'Coupon is inactive' };
    if (new Date() > coupon.expiresAt) return { valid: false, message: 'Coupon expired' };
    if (coupon.minOrderValue && orderValue < Number(coupon.minOrderValue)) {
      return { valid: false, message: `Minimum order value ₹${coupon.minOrderValue}` };
    }
    if (coupon.maxUses && coupon.currentUses >= coupon.maxUses) {
      return { valid: false, message: 'Coupon usage limit reached' };
    }
    if (coupon.isFirstOrderOnly) {
      const orderCount = await this.prisma.order.count({ where: { userId } });
      if (orderCount > 0) return { valid: false, message: 'First order only coupon' };
    }
    const userUsage = await this.prisma.couponUsage.count({
      where: { couponId: coupon.id, userId },
    });
    if (coupon.maxUsesPerUser && userUsage >= coupon.maxUsesPerUser) {
      return { valid: false, message: 'You have already used this coupon' };
    }

    let discount = 0;
    if (coupon.discountType === 'percentage') {
      discount = Math.min(
        orderValue * (Number(coupon.discountValue) / 100),
        coupon.maxDiscountValue ? Number(coupon.maxDiscountValue) : Infinity,
      );
    } else {
      discount = Number(coupon.discountValue);
    }

    return { valid: true, discount, couponCode: coupon.code };
  }

  async findAll() {
    return this.prisma.coupon.findMany({ orderBy: { createdAt: 'desc' } });
  }

  async create(data: any) {
    return this.prisma.coupon.create({ data });
  }

  async update(id: string, data: any) {
    return this.prisma.coupon.update({ where: { id }, data });
  }

  async remove(id: string) {
    return this.prisma.coupon.delete({ where: { id } });
  }
}
