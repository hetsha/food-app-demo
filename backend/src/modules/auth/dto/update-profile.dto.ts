import { IsString, IsEmail, IsOptional, MaxLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateProfileDto {
  @ApiPropertyOptional({ example: 'John Doe', maxLength: 100 })
  @IsString()
  @MaxLength(100)
  @IsOptional()
  fullName?: string;

  @ApiPropertyOptional({ example: 'john@example.com' })
  @IsEmail({}, { message: 'Invalid email format' })
  @IsOptional()
  email?: string;
}
