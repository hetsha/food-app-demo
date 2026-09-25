import { Controller, Get, Post, Patch, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { SubscriptionsService } from './subscriptions.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Public } from '../../guards/public.decorator';

@ApiTags('Subscriptions')
@Controller('subscriptions')
export class SubscriptionsController {
  constructor(private subscriptionsService: SubscriptionsService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get all subscription plans' })
  async findAll() {
    return this.subscriptionsService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Get('my')
  @ApiOperation({ summary: 'Get my subscriptions' })
  async getMy(@Request() req) {
    return this.subscriptionsService.getMy(req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('subscribe')
  @ApiOperation({ summary: 'Subscribe to a plan' })
  async subscribe(@Request() req, @Body('subscriptionId') subscriptionId: string) {
    return this.subscriptionsService.subscribe(req.user.id, subscriptionId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch(':id/pause')
  @ApiOperation({ summary: 'Pause subscription' })
  async pause(@Param('id') id: string, @Request() req) {
    return this.subscriptionsService.pause(id, req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Patch(':id/resume')
  @ApiOperation({ summary: 'Resume subscription' })
  async resume(@Param('id') id: string, @Request() req) {
    return this.subscriptionsService.resume(id, req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post(':id/skip')
  @ApiOperation({ summary: 'Skip subscription day' })
  async skipDay(@Param('id') id: string, @Request() req, @Body('date') date: string) {
    return this.subscriptionsService.skipDay(id, req.user.id, date);
  }
}
