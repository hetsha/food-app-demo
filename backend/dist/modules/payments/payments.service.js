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
exports.PaymentsService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const prisma_service_1 = require("../../config/prisma.service");
const crypto = require("crypto");
let PaymentsService = class PaymentsService {
    constructor(prisma, configService) {
        this.prisma = prisma;
        this.configService = configService;
    }
    async createOrder(orderId, amount) {
        const order = await this.prisma.order.findUnique({ where: { id: orderId } });
        if (!order)
            throw new common_1.BadRequestException('Order not found');
        return {
            orderId: order.id,
            amount: Math.round(amount * 100),
            currency: 'INR',
            keyId: this.configService.get('RAZORPAY_KEY_ID'),
        };
    }
    async verifyPayment(orderId, razorpayOrderId, razorpayPaymentId, razorpaySignature) {
        const secret = this.configService.get('RAZORPAY_KEY_SECRET') || '';
        const body = razorpayOrderId + '|' + razorpayPaymentId;
        const expectedSignature = crypto.createHmac('sha256', secret).update(body).digest('hex');
        if (expectedSignature !== razorpaySignature) {
            throw new common_1.BadRequestException('Payment verification failed');
        }
        return this.prisma.$transaction(async (tx) => {
            await tx.order.update({
                where: { id: orderId },
                data: { paymentStatus: 'paid', paymentReferenceId: razorpayPaymentId },
            });
            return { verified: true };
        });
    }
    async handleWebhook(event, data) {
        if (event === 'payment.captured') {
            await this.prisma.order.updateMany({
                where: { id: data.order_id },
                data: { paymentStatus: 'paid' },
            });
        }
        return { received: true };
    }
};
exports.PaymentsService = PaymentsService;
exports.PaymentsService = PaymentsService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService,
        config_1.ConfigService])
], PaymentsService);
//# sourceMappingURL=payments.service.js.map