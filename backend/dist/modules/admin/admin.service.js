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
exports.AdminService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let AdminService = class AdminService {
    constructor(prisma) {
        this.prisma = prisma;
    }
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
    async getRevenueChart(days = 7) {
        const results = [];
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
        const results = await Promise.all(statuses.map(async (status) => {
            const count = await this.prisma.order.count({ where: { status: status } });
            return { status, count };
        }));
        return results.filter((r) => r.count > 0);
    }
    async getTopDishes(limit = 10) {
        const items = await this.prisma.orderItem.groupBy({
            by: ['foodItemId'],
            _count: { id: true },
            orderBy: { _count: { id: 'desc' } },
            take: limit,
        });
        const results = await Promise.all(items.map(async (item) => {
            const food = await this.prisma.foodItem.findUnique({
                where: { id: item.foodItemId },
                select: { id: true, name: true },
            });
            return {
                id: food?.id || item.foodItemId,
                name: food?.name || 'Unknown',
                orderCount: item._count.id,
            };
        }));
        return results;
    }
    async getRecentOrders(limit = 5) {
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
    async getOrders(params) {
        const where = {};
        if (params.status)
            where.status = params.status;
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
    async updateOrderStatus(orderId, status) {
        return this.prisma.order.update({ where: { id: orderId }, data: { status: status } });
    }
    async logAudit(adminId, data) {
        return this.prisma.adminAuditLog.create({ data: { adminId, ...data } });
    }
    async getAuditLogs(params) {
        return this.prisma.adminAuditLog.findMany({
            include: { admin: { select: { id: true, fullName: true } } },
            orderBy: { createdAt: 'desc' },
            skip: params.skip || 0,
            take: params.take || 20,
        });
    }
};
exports.AdminService = AdminService;
exports.AdminService = AdminService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AdminService);
//# sourceMappingURL=admin.service.js.map