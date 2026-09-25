import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../../config/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class PaymentsService {
  constructor(
    private prisma: PrismaService,
    private configService: ConfigService,
  ) {}

  async createOrder(orderId: string, amount: number) {
    const order = await this.prisma.order.findUnique({ where: { id: orderId } });
    if (!order) throw new BadRequestException('Order not found');

    return {
      orderId: order.id,
      amount: Math.round(amount * 100),
      currency: 'INR',
      keyId: this.configService.get<string>('RAZORPAY_KEY_ID'),
    };
  }

  async verifyPayment(orderId: string, razorpayOrderId: string, razorpayPaymentId: string, razorpaySignature: string) {
    const secret = this.configService.get<string>('RAZORPAY_KEY_SECRET') || '';
    const body = razorpayOrderId + '|' + razorpayPaymentId;
    const expectedSignature = crypto.createHmac('sha256', secret).update(body).digest('hex');

    if (expectedSignature !== razorpaySignature) {
      throw new BadRequestException('Payment verification failed');
    }

    return this.prisma.$transaction(async (tx) => {
      await tx.order.update({
        where: { id: orderId },
        data: { paymentStatus: 'paid', paymentReferenceId: razorpayPaymentId },
      });
      return { verified: true };
    });
  }

  async handleWebhook(event: string, data: any) {
    if (event === 'payment.captured') {
      await this.prisma.order.updateMany({
        where: { id: data.order_id },
        data: { paymentStatus: 'paid' },
      });
    }
    return { received: true };
  }
}
