import { IsString, IsNumber, IsOptional, Min } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class CreateCustomizationItemDto {
  @ApiProperty({ example: 'Mild' })
  @IsString()
  name: string;

  @ApiPropertyOptional({ example: 0, description: 'Additional price for this option' })
  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  @Min(0)
  additionalPrice?: number;

  @ApiPropertyOptional()
  @Type(() => Number)
  @IsNumber()
  @IsOptional()
  displayOrder?: number;
}
