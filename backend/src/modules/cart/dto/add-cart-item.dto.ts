import { IsString, IsNumber, IsArray, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class AddCartItemDto {
  @ApiProperty()
  @IsString()
  foodItemId: string;

  @ApiProperty({ example: 1 })
  @IsNumber()
  quantity: number;

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  customizationItems?: any[];

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  specialInstructions?: string;
}
