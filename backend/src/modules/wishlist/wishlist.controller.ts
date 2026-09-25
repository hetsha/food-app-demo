import { Controller, Get, Post, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { WishlistService } from './wishlist.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Wishlist')
@Controller('wishlist')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class WishlistController {
  constructor(private wishlistService: WishlistService) {}

  @Get()
  @ApiOperation({ summary: 'Get user wishlist' })
  async findAll(@Request() req) {
    return this.wishlistService.findAll(req.user.id);
  }

  @Post(':foodItemId')
  @ApiOperation({ summary: 'Toggle wishlist item' })
  async toggle(@Request() req, @Param('foodItemId') foodItemId: string) {
    return this.wishlistService.toggle(req.user.id, foodItemId);
  }
}
