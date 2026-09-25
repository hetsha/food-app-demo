import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class ShortsService {
  constructor(private prisma: PrismaService) {}

  async findAll(params?: { skip?: number; take?: number; categoryId?: string }) {
    const where: any = { isActive: true };
    if (params?.categoryId) where.categoryId = params.categoryId;

    return this.prisma.short.findMany({
      where,
      include: {
        foodItem: { select: { id: true, name: true, price: true, imageUrls: true } },
        category: { select: { id: true, name: true } },
      },
      orderBy: { createdAt: 'desc' },
      skip: params?.skip || 0,
      take: params?.take || 20,
    });
  }

  async toggleLike(userId: string, shortId: string) {
    const existing = await this.prisma.foodShortLike.findUnique({
      where: { userId_shortId: { userId, shortId } },
    });

    if (existing) {
      await this.prisma.foodShortLike.delete({ where: { id: existing.id } });
      await this.prisma.short.update({ where: { id: shortId }, data: { likesCount: { decrement: 1 } } });
      return { liked: false };
    }

    await this.prisma.foodShortLike.create({ data: { userId, shortId } });
    await this.prisma.short.update({ where: { id: shortId }, data: { likesCount: { increment: 1 } } });
    return { liked: true };
  }

  async incrementViews(shortId: string) {
    await this.prisma.short.update({ where: { id: shortId }, data: { viewsCount: { increment: 1 } } });
  }
}
