import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { LoyaltyService } from './loyalty.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Loyalty')
@Controller('loyalty')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class LoyaltyController {
  constructor(private loyaltyService: LoyaltyService) {}

  @Get('balance')
  @ApiOperation({ summary: 'Get loyalty points balance' })
  async getBalance(@Request() req) {
    return this.loyaltyService.getBalance(req.user.id);
  }

  @Get('transactions')
  @ApiOperation({ summary: 'Get loyalty transactions' })
  async getTransactions(@Request() req) {
    return this.loyaltyService.getTransactions(req.user.id);
  }
}
