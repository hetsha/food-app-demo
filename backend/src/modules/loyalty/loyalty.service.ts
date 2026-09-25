import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class LoyaltyService {
  constructor(private prisma: PrismaService) {}

  async getBalance(userId: string) {
    const points = await this.prisma.loyaltyPoint.aggregate({
      where: { userId },
      _sum: { points: true },
    });
    return { points: points._sum.points || 0 };
  }

  async getTransactions(userId: string) {
    return this.prisma.loyaltyPoint.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async earn(userId: string, orderId: string, amount: number) {
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

  async redeem(userId: string, orderId: string, points: number) {
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
}
