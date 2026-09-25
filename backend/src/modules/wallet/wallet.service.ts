import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class WalletService {
  constructor(private prisma: PrismaService) {}

  async getBalance(userId: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    return { balance: Number(user?.walletBalance || 0) };
  }

  async getTransactions(userId: string, params?: { skip?: number; take?: number }) {
    return this.prisma.walletTransaction.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
      skip: params?.skip || 0,
      take: params?.take || 20,
    });
  }

  async debit(userId: string, amount: number, description: string, orderId?: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user || Number(user.walletBalance) < amount) throw new BadRequestException('Insufficient balance');

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

  async credit(userId: string, amount: number, description: string, orderId?: string) {
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
}
