import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';
import { Public } from '../../guards/public.decorator';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Payments')
@Controller('payments')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @Post('create')
  @ApiOperation({ summary: 'Create Razorpay order' })
  async createOrder(@Body() body: { orderId: string; amount: number }) {
    return this.paymentsService.createOrder(body.orderId, body.amount);
  }

  @Post('verify')
  @ApiOperation({ summary: 'Verify payment' })
  async verifyPayment(@Body() body: { orderId: string; razorpayOrderId: string; razorpayPaymentId: string; razorpaySignature: string }) {
    return this.paymentsService.verifyPayment(body.orderId, body.razorpayOrderId, body.razorpayPaymentId, body.razorpaySignature);
  }

  @Public()
  @Post('webhook')
  @ApiOperation({ summary: 'Razorpay webhook' })
  async webhook(@Req() req: any) {
    return this.paymentsService.handleWebhook(req.body.event, req.body.payload);
  }
}
