import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class BannersService {
  constructor(private prisma: PrismaService) {}

  async findActive() {
    const now = new Date();
    return this.prisma.banner.findMany({
      where: { isActive: true, startDate: { lte: now }, endDate: { gte: now } },
      orderBy: { displayOrder: 'asc' },
    });
  }

  async findAll() {
    return this.prisma.banner.findMany({ orderBy: { displayOrder: 'asc' } });
  }

  async create(data: any) {
    return this.prisma.banner.create({ data });
  }

  async update(id: string, data: any) {
    return this.prisma.banner.update({ where: { id }, data });
  }

  async remove(id: string) {
    return this.prisma.banner.delete({ where: { id } });
  }
}
