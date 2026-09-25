import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class ReviewsService {
  constructor(private prisma: PrismaService) {}

  async findByFood(foodItemId: string) {
    return this.prisma.review.findMany({
      where: { foodItemId, isApproved: true },
      include: { user: { select: { id: true, fullName: true } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  async create(userId: string, dto: { foodItemId: string; orderId: string; rating: number; comment?: string; images?: string[] }) {
    return this.prisma.$transaction(async (tx) => {
      const review = await tx.review.create({
        data: { userId, ...dto },
      });

      const stats = await tx.review.aggregate({
        where: { foodItemId: dto.foodItemId, isApproved: true },
        _avg: { rating: true },
        _count: { rating: true },
      });

      await tx.foodItem.update({
        where: { id: dto.foodItemId },
        data: {
          rating: Number(stats._avg.rating || 0),
          reviewsCount: stats._count.rating,
        },
      });

      return review;
    });
  }

  async findAll() {
    return this.prisma.review.findMany({
      include: {
        user: { select: { id: true, fullName: true } },
        foodItem: { select: { id: true, name: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async moderate(id: string, isApproved: boolean) {
    return this.prisma.review.update({ where: { id }, data: { isApproved } });
  }
}
