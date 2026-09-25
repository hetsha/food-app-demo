import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class AdminService {
  constructor(private prisma: PrismaService) {}

  async getDashboard() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const [totalUsers, totalOrders, activeSubscriptions, totalRevenue, todayOrders] = await Promise.all([
      this.prisma.user.count({ where: { role: 'customer' } }),
      this.prisma.order.count(),
      this.prisma.userSubscription.count({ where: { status: 'active' } }),
      this.prisma.order.aggregate({ where: { paymentStatus: 'paid' }, _sum: { grandTotal: true } }),
      this.prisma.order.count({ where: { createdAt: { gte: today } } }),
    ]);

    return {
      totalOrders,
      revenueToday: Number(totalRevenue._sum.grandTotal || 0),
      activeSubscriptions,
      pendingOrders: todayOrders,
      totalUsers,
    };
  }

  async getRevenueChart(days: number = 7) {
    const results: { date: string; revenue: number }[] = [];
    for (let i = days - 1; i >= 0; i--) {
      const date = new Date();
      date.setDate(date.getDate() - i);
      const start = new Date(date);
      start.setHours(0, 0, 0, 0);
      const end = new Date(date);
      end.setHours(23, 59, 59, 999);

      const revenue = await this.prisma.order.aggregate({
        where: {
          paymentStatus: 'paid',
          createdAt: { gte: start, lte: end },
        },
        _sum: { grandTotal: true },
      });

      results.push({
        date: start.toISOString().split('T')[0],
        revenue: Number(revenue._sum.grandTotal || 0),
      });
    }
    return results;
  }

  async getOrdersByStatus() {
    const statuses = ['placed', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled'];
    const results = await Promise.all(
      statuses.map(async (status) => {
        const count = await this.prisma.order.count({ where: { status: status as any } });
        return { status, count };
      }),
    );
    return results.filter((r) => r.count > 0);
  }

  async getTopDishes(limit: number = 10) {
    const items = await this.prisma.orderItem.groupBy({
      by: ['foodItemId'],
      _count: { id: true },
      orderBy: { _count: { id: 'desc' } },
      take: limit,
    });

    const results = await Promise.all(
      items.map(async (item) => {
        const food = await this.prisma.foodItem.findUnique({
          where: { id: item.foodItemId },
          select: { id: true, name: true },
        });
        return {
          id: food?.id || item.foodItemId,
          name: food?.name || 'Unknown',
          orderCount: item._count.id,
        };
      }),
    );

    return results;
  }

  async getRecentOrders(limit: number = 5) {
    const orders = await this.prisma.order.findMany({
      take: limit,
      orderBy: { createdAt: 'desc' },
      include: {
        user: { select: { id: true, fullName: true, phoneNumber: true } },
      },
    });

    return orders.map((o) => ({
      id: o.id,
      orderNumber: o.id.slice(0, 8).toUpperCase(),
      customerName: o.user.fullName || o.user.phoneNumber,
      total: Number(o.grandTotal),
      status: o.status,
      createdAt: o.createdAt,
    }));
  }

  async getOrders(params: { skip?: number; take?: number; status?: string; search?: string }) {
    const where: any = {};
    if (params.status) where.status = params.status;
    if (params.search) {
      where.OR = [
        { id: { contains: params.search, mode: 'insensitive' } },
        { user: { fullName: { contains: params.search, mode: 'insensitive' } } },
      ];
    }

    return this.prisma.order.findMany({
      where,
      include: {
        user: { select: { id: true, fullName: true, phoneNumber: true } },
        items: { include: { foodItem: { select: { name: true } } } },
      },
      orderBy: { createdAt: 'desc' },
      skip: params.skip || 0,
      take: params.take || 20,
    });
  }

  async updateOrderStatus(orderId: string, status: string) {
    return this.prisma.order.update({ where: { id: orderId }, data: { status: status as any } });
  }

  async logAudit(adminId: string, data: { action: string; entity: string; entityId?: string; oldValue?: any; newValue?: any; ipAddress?: string }) {
    return this.prisma.adminAuditLog.create({ data: { adminId, ...data } });
  }

  async getAuditLogs(params: { skip?: number; take?: number }) {
    return this.prisma.adminAuditLog.findMany({
      include: { admin: { select: { id: true, fullName: true } } },
      orderBy: { createdAt: 'desc' },
      skip: params.skip || 0,
      take: params.take || 20,
    });
  }
}
