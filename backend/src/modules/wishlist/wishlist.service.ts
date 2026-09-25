import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class WishlistService {
  constructor(private prisma: PrismaService) {}

  async findAll(userId: string) {
    return this.prisma.wishlist.findMany({
      where: { userId },
      include: {
        foodItem: {
          select: { id: true, name: true, price: true, imageUrls: true, rating: true, isVeg: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async toggle(userId: string, foodItemId: string) {
    const existing = await this.prisma.wishlist.findUnique({
      where: { userId_foodItemId: { userId, foodItemId } },
    });
    if (existing) {
      await this.prisma.wishlist.delete({ where: { id: existing.id } });
      return { added: false };
    }
    await this.prisma.wishlist.create({ data: { userId, foodItemId } });
    return { added: true };
  }
}
