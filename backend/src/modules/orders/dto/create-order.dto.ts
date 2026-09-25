import { IsString, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateOrderDto {
  @ApiProperty()
  @IsString()
  addressId: string;

  @ApiProperty({ example: '12:00 PM - 12:30 PM' })
  @IsString()
  deliverySlot: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  specialInstructions?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  couponCode?: string;

  @ApiPropertyOptional({ enum: ['upi', 'card', 'net_banking', 'wallet', 'cod'], default: 'upi' })
  @IsString()
  @IsOptional()
  paymentMethod?: string;
}
