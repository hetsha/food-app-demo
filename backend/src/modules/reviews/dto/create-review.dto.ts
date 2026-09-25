import { IsString, IsNumber, IsOptional, IsArray } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateReviewDto {
  @ApiProperty()
  @IsString()
  foodItemId: string;

  @ApiProperty()
  @IsString()
  orderId: string;

  @ApiProperty({ example: 5 })
  @IsNumber()
  rating: number;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  comment?: string;

  @ApiPropertyOptional()
  @IsArray()
  @IsOptional()
  images?: string[];
}
