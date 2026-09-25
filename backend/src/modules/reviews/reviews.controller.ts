import { Controller, Get, Post, Patch, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ReviewsService } from './reviews.service';
import { CreateReviewDto } from './dto/create-review.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../../guards/roles.decorator';
import { Public } from '../../guards/public.decorator';
import { UserRole } from '@prisma/client';

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewsController {
  constructor(private reviewsService: ReviewsService) {}

  @Public()
  @Get('food/:foodItemId')
  @ApiOperation({ summary: 'Get reviews for food item' })
  async findByFood(@Param('foodItemId') foodItemId: string) {
    return this.reviewsService.findByFood(foodItemId);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post()
  @ApiOperation({ summary: 'Create review' })
  async create(@Request() req, @Body() dto: CreateReviewDto) {
    return this.reviewsService.create(req.user.id, dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Get()
  @ApiOperation({ summary: 'Get all reviews (admin)' })
  async findAll() {
    return this.reviewsService.findAll();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Patch(':id/moderate')
  @ApiOperation({ summary: 'Approve/reject review (admin)' })
  async moderate(@Param('id') id: string, @Body('isApproved') isApproved: boolean) {
    return this.reviewsService.moderate(id, isApproved);
  }
}
