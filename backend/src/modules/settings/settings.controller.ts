import { Controller, Get, Post, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { SettingsService } from './settings.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../../guards/roles.decorator';
import { Public } from '../../guards/public.decorator';
import { UserRole } from '@prisma/client';

@ApiTags('Settings')
@Controller('settings')
export class SettingsController {
  constructor(private settingsService: SettingsService) {}

  @Public()
  @Get(':key')
  @ApiOperation({ summary: 'Get setting by key' })
  async get(@Param('key') key: string) {
    return this.settingsService.get(key);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Get()
  @ApiOperation({ summary: 'Get all settings (admin)' })
  async getAll() {
    return this.settingsService.getAll();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Post()
  @ApiOperation({ summary: 'Set setting (admin)' })
  async set(@Body() body: { key: string; value: string; valueType?: string; description?: string }) {
    return this.settingsService.set(body.key, body.value, body.valueType, body.description);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles(UserRole.admin)
  @ApiBearerAuth()
  @Delete(':key')
  @ApiOperation({ summary: 'Delete setting (admin)' })
  async delete(@Param('key') key: string) {
    return this.settingsService.delete(key);
  }
}
