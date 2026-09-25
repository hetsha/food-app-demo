import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class ChefsService {
  constructor(private prisma: PrismaService) {}

  async findByPin(pin: string) {
    return this.prisma.user.findFirst({ where: { role: 'chef', phoneNumber: pin } });
  }

  async getDashboard(chefId: string) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const [totalOrders, preparingOrders, readyOrders] = await Promise.all([
      this.prisma.order.count({
        where: { chefId, createdAt: { gte: today } },
      }),
      this.prisma.order.count({
        where: { chefId, status: 'preparing' },
      }),
      this.prisma.order.count({
        where: { chefId, status: 'ready' },
      }),
    ]);

    return { totalOrders, preparingOrders, readyOrders };
  }

  async getOrders(chefId: string, status?: string) {
    const where: any = {};
    if (status) where.status = status;

    return this.prisma.order.findMany({
      where,
      include: {
        items: {
          include: {
            foodItem: { select: { id: true, name: true, imageUrls: true } },
          },
        },
        user: { select: { id: true, fullName: true, phoneNumber: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async acceptOrder(orderId: string, chefId: string) {
    return this.prisma.order.update({
      where: { id: orderId },
      data: { status: 'confirmed', chefId },
    });
  }

  async startPreparing(orderId: string) {
    return this.prisma.order.update({
      where: { id: orderId },
      data: { status: 'preparing' },
    });
  }

  async markReady(orderId: string) {
    return this.prisma.order.update({
      where: { id: orderId },
      data: { status: 'ready' },
    });
  }

  async toggleFoodStock(foodItemId: string) {
    const food = await this.prisma.foodItem.findUnique({ where: { id: foodItemId } });
    if (!food) throw new Error('Food item not found');
    return this.prisma.foodItem.update({
      where: { id: foodItemId },
      data: { isActive: !food.isActive },
    });
  }
}
