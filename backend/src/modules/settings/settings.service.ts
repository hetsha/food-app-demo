import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class SettingsService {
  constructor(private prisma: PrismaService) {}

  async get(key: string) {
    const setting = await this.prisma.setting.findUnique({ where: { key } });
    return setting ? { key: setting.key, value: setting.value, valueType: setting.valueType } : null;
  }

  async getAll() {
    return this.prisma.setting.findMany();
  }

  async set(key: string, value: string, valueType?: string, description?: string) {
    return this.prisma.setting.upsert({
      where: { key },
      update: { value, valueType, description },
      create: { key, value, valueType: valueType || 'string', description },
    });
  }

  async delete(key: string) {
    return this.prisma.setting.delete({ where: { key } });
  }
}
