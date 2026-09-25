import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class AddressesService {
  constructor(private prisma: PrismaService) {}

  private toPlain(addr: any) {
    return {
      ...addr,
      latitude: Number(addr.latitude),
      longitude: Number(addr.longitude),
    };
  }

  async findAll(userId: string) {
    const rows = await this.prisma.address.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
    return rows.map((r) => this.toPlain(r));
  }

  async create(userId: string, dto: any) {
    if (dto.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId },
        data: { isDefault: false },
      });
    }
    const row = await this.prisma.address.create({
      data: { userId, ...dto },
    });
    return this.toPlain(row);
  }

  async update(id: string, userId: string, dto: any) {
    const address = await this.prisma.address.findUnique({ where: { id } });
    if (!address || address.userId !== userId) throw new NotFoundException();
    if (dto.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId },
        data: { isDefault: false },
      });
    }
    const row = await this.prisma.address.update({ where: { id }, data: dto });
    return this.toPlain(row);
  }

  async remove(id: string, userId: string) {
    const address = await this.prisma.address.findUnique({ where: { id } });
    if (!address || address.userId !== userId) throw new NotFoundException();
    return this.prisma.address.delete({ where: { id } });
  }
}
