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
exports.WalletService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let WalletService = class WalletService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getBalance(userId) {
        const user = await this.prisma.user.findUnique({ where: { id: userId } });
        return { balance: Number(user?.walletBalance || 0) };
    }
    async getTransactions(userId, params) {
        return this.prisma.walletTransaction.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
            skip: params?.skip || 0,
            take: params?.take || 20,
        });
    }
    async debit(userId, amount, description, orderId) {
        const user = await this.prisma.user.findUnique({ where: { id: userId } });
        if (!user || Number(user.walletBalance) < amount)
            throw new common_1.BadRequestException('Insufficient balance');
        return this.prisma.$transaction(async (tx) => {
            await tx.user.update({
                where: { id: userId },
                data: { walletBalance: { decrement: amount } },
            });
            return tx.walletTransaction.create({
                data: { userId, type: 'debit', amount, description, referenceOrderId: orderId },
            });
        });
    }
    async credit(userId, amount, description, orderId) {
        return this.prisma.$transaction(async (tx) => {
            await tx.user.update({
                where: { id: userId },
                data: { walletBalance: { increment: amount } },
            });
            return tx.walletTransaction.create({
                data: { userId, type: 'credit', amount, description, referenceOrderId: orderId },
            });
        });
    }
};
exports.WalletService = WalletService;
exports.WalletService = WalletService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], WalletService);
//# sourceMappingURL=wallet.service.js.map