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
exports.ShortsService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../../config/prisma.service");
let ShortsService = class ShortsService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async findAll(params) {
        const where = { isActive: true };
        if (params?.categoryId)
            where.categoryId = params.categoryId;
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
    async toggleLike(userId, shortId) {
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
    async incrementViews(shortId) {
        await this.prisma.short.update({ where: { id: shortId }, data: { viewsCount: { increment: 1 } } });
    }
};
exports.ShortsService = ShortsService;
exports.ShortsService = ShortsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], ShortsService);
//# sourceMappingURL=shorts.service.js.map