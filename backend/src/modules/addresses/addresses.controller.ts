import { Controller, Get, Post, Patch, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AddressesService } from './addresses.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Addresses')
@Controller('addresses')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class AddressesController {
  constructor(private addressesService: AddressesService) {}

  @Get()
  @ApiOperation({ summary: 'Get user addresses' })
  async findAll(@Request() req) {
    return this.addressesService.findAll(req.user.id);
  }

  @Post()
  @ApiOperation({ summary: 'Create address' })
  async create(@Request() req, @Body() dto: CreateAddressDto) {
    return this.addressesService.create(req.user.id, dto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update address' })
  async update(@Param('id') id: string, @Request() req, @Body() dto: UpdateAddressDto) {
    return this.addressesService.update(id, req.user.id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete address' })
  async remove(@Param('id') id: string, @Request() req) {
    return this.addressesService.remove(id, req.user.id);
  }
}
