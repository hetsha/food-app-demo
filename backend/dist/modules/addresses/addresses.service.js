"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AddressesService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let AddressesService = class AddressesService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    toPlain(addr) {
        return {
            ...addr,
            latitude: Number(addr.latitude),
            longitude: Number(addr.longitude),
        };
    }
    async findAll(userId) {
        const rows = await this.prisma.address.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
        return rows.map((r) => this.toPlain(r));
    }
    async create(userId, dto) {
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
    async update(id, userId, dto) {
        const address = await this.prisma.address.findUnique({ where: { id } });
        if (!address || address.userId !== userId)
            throw new common_1.NotFoundException();
        if (dto.isDefault) {
            await this.prisma.address.updateMany({
                where: { userId },
                data: { isDefault: false },
            });
        }
        const row = await this.prisma.address.update({ where: { id }, data: dto });
        return this.toPlain(row);
    }
    async remove(id, userId) {
        const address = await this.prisma.address.findUnique({ where: { id } });
        if (!address || address.userId !== userId)
            throw new common_1.NotFoundException();
        return this.prisma.address.delete({ where: { id } });
    }
};
exports.AddressesService = AddressesService;
exports.AddressesService = AddressesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AddressesService);
//# sourceMappingURL=addresses.service.js.map