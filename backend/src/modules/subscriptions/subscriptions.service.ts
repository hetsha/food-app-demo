import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class SubscriptionsService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    return this.prisma.subscription.findMany({ where: { isActive: true } });
  }

  async getMy(userId: string) {
    return this.prisma.userSubscription.findMany({
      where: { userId },
      include: { subscription: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async subscribe(userId: string, subscriptionId: string) {
    const subscription = await this.prisma.subscription.findUnique({ where: { id: subscriptionId } });
    if (!subscription) throw new BadRequestException('Subscription not found');

    const startDate = new Date();
    const endDate = new Date();
    endDate.setDate(endDate.getDate() + subscription.durationDays);

    return this.prisma.userSubscription.create({
      data: {
        userId,
        subscriptionId,
        startDate,
        endDate,
        mealsRemaining: subscription.mealsCount,
        status: 'active',
      },
      include: { subscription: true },
    });
  }

  async pause(id: string, userId: string) {
    const sub = await this.prisma.userSubscription.findUnique({ where: { id } });
    if (!sub || sub.userId !== userId) throw new BadRequestException('Not found');
    return this.prisma.userSubscription.update({ where: { id }, data: { status: 'paused' } });
  }

  async resume(id: string, userId: string) {
    const sub = await this.prisma.userSubscription.findUnique({ where: { id } });
    if (!sub || sub.userId !== userId) throw new BadRequestException('Not found');
    return this.prisma.userSubscription.update({ where: { id }, data: { status: 'active' } });
  }

  async skipDay(id: string, userId: string, date: string) {
    const sub = await this.prisma.userSubscription.findUnique({ where: { id } });
    if (!sub || sub.userId !== userId) throw new BadRequestException('Not found');
    const skipDates = Array.isArray(sub.skipDates) ? sub.skipDates : [];
    return this.prisma.userSubscription.update({
      where: { id },
      data: { skipDates: [...skipDates, date] },
    });
  }
}
