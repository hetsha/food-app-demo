import { Controller, Get, Post, Param, Query, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ShortsService } from './shorts.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Public } from '../../guards/public.decorator';

@ApiTags('Shorts')
@Controller('shorts')
export class ShortsController {
  constructor(private shortsService: ShortsService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get food shorts feed' })
  async findAll(
    @Query('skip') skip?: string,
    @Query('take') take?: string,
    @Query('categoryId') categoryId?: string,
  ) {
    return this.shortsService.findAll({
      skip: skip ? parseInt(skip) : 0,
      take: take ? parseInt(take) : 20,
      categoryId,
    });
  }

  @Public()
  @Post(':id/view')
  @ApiOperation({ summary: 'Increment view count' })
  async view(@Param('id') id: string) {
    return this.shortsService.incrementViews(id);
  }

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post(':id/like')
  @ApiOperation({ summary: 'Toggle like on short' })
  async like(@Param('id') id: string, @Request() req) {
    return this.shortsService.toggleLike(req.user.id, id);
  }
}
