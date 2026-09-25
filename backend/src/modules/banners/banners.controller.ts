import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { BannersService } from './banners.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../../guards/roles.decorator';
import { Public } from '../../guards/public.decorator';
import { UserRole } from '@prisma/client';

@ApiTags('Banners')
@Controller('banners')
export class BannersController {
  constructor(private bannersService: BannersService) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Get active banners' })
  async findActive() {
    return this.bannersService.findActive();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Get('admin')
  @ApiOperation({ summary: 'Get all banners (admin)' })
  async findAll() {
    return this.bannersService.findAll();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Post()
  @ApiOperation({ summary: 'Create banner (admin)' })
  async create(@Body() dto: any) {
    return this.bannersService.create(dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Patch(':id')
  @ApiOperation({ summary: 'Update banner (admin)' })
  async update(@Param('id') id: string, @Body() dto: any) {
    return this.bannersService.update(id, dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Delete(':id')
  @ApiOperation({ summary: 'Delete banner (admin)' })
  async remove(@Param('id') id: string) {
    return this.bannersService.remove(id);
  }
}
