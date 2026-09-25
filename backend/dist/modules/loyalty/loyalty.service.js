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
exports.LoyaltyService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let LoyaltyService = class LoyaltyService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getBalance(userId) {
        const points = await this.prisma.loyaltyPoint.aggregate({
            where: { userId },
            _sum: { points: true },
        });
        return { points: points._sum.points || 0 };
    }
    async getTransactions(userId) {
        return this.prisma.loyaltyPoint.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }
    async earn(userId, orderId, amount) {
        const points = Math.floor(amount / 10);
        return this.prisma.loyaltyPoint.create({
            data: {
                userId,
                points,
                transactionType: 'earned',
                description: `Earned ${points} points for order`,
                referenceOrderId: orderId,
            },
        });
    }
    async redeem(userId, orderId, points) {
        return this.prisma.loyaltyPoint.create({
            data: {
                userId,
                points: -points,
                transactionType: 'redeemed',
                description: `Redeemed ${points} points`,
                referenceOrderId: orderId,
            },
        });
    }
};
exports.LoyaltyService = LoyaltyService;
exports.LoyaltyService = LoyaltyService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], LoyaltyService);
//# sourceMappingURL=loyalty.service.js.map