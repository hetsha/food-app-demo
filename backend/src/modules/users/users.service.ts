import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findByPhoneNumber(phoneNumber: string) {
    return this.prisma.user.findUnique({ where: { phoneNumber } });
  }

  async findById(id: string) {
    return this.prisma.user.findUnique({ where: { id } });
  }

  async create(data: { phoneNumber: string; role?: any }) {
    return this.prisma.user.create({ data });
  }

  async update(id: string, data: { fullName?: string; email?: string }) {
    return this.prisma.user.update({ where: { id }, data });
  }

  async findAll(params: { skip?: number; take?: number; where?: any }) {
    const { skip, take, where } = params;
    return this.prisma.user.findMany({ skip, take, where });
  }

  async count(where?: any) {
    return this.prisma.user.count({ where });
  }
}
