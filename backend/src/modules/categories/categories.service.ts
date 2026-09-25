import { Injectable, NotFoundException, BadRequestException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class CategoriesService {
  constructor(private prisma: PrismaService) {}

  async findAllActive() {
    return this.prisma.category.findMany({
      where: { isActive: true },
      orderBy: { displayOrder: 'asc' },
    });
  }

  async findAll() {
    return this.prisma.category.findMany({
      orderBy: { displayOrder: 'asc' },
      include: { _count: { select: { foodItems: { where: { deletedAt: null } } } } },
    });
  }

  async findOne(id: string) {
    const category = await this.prisma.category.findUnique({ where: { id } });
    if (!category) throw new NotFoundException('Category not found');
    return category;
  }

  async create(data: { name: string; icon?: string; displayOrder?: number }) {
    const existing = await this.prisma.category.findFirst({ where: { name: data.name } });
    if (existing) throw new ConflictException('Category with this name already exists');

    const maxOrder = await this.prisma.category.aggregate({ _max: { displayOrder: true } });
    return this.prisma.category.create({
      data: {
        name: data.name,
        icon: data.icon ?? '',
        displayOrder: data.displayOrder ?? (maxOrder._max.displayOrder ?? 0) + 1,
      },
    });
  }

  async update(id: string, data: { name?: string; icon?: string; displayOrder?: number; isActive?: boolean }) {
    await this.findOne(id);

    if (data.name) {
      const existing = await this.prisma.category.findFirst({
        where: { name: data.name, id: { not: id } },
      });
      if (existing) throw new ConflictException('Category with this name already exists');
    }

    return this.prisma.category.update({ where: { id }, data });
  }

  async reorder(items: { id: string; displayOrder: number }[]) {
    const operations = items.map((item) =>
      this.prisma.category.update({
        where: { id: item.id },
        data: { displayOrder: item.displayOrder },
      }),
    );
    await this.prisma.$transaction(operations);
    return { message: 'Categories reordered successfully' };
  }

  async deactivate(id: string) {
    const category = await this.findOne(id);
    if (!category.isActive) throw new BadRequestException('Category is already inactive');

    const foodCount = await this.prisma.foodItem.count({
      where: { categoryId: id, deletedAt: null, isActive: true },
    });
    if (foodCount > 0) {
      throw new BadRequestException(
        `Cannot deactivate category: ${foodCount} active food item(s) still belong to it. Deactivate or reassign them first.`,
      );
    }

    return this.prisma.category.update({
      where: { id },
      data: { isActive: false },
    });
  }

  async activate(id: string) {
    const category = await this.findOne(id);
    if (category.isActive) throw new BadRequestException('Category is already active');

    return this.prisma.category.update({
      where: { id },
      data: { isActive: true },
    });
  }
}
