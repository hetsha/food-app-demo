import { IsString, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SendOtpDto {
  @ApiProperty({ example: '+919876543210', description: 'Phone number with country code' })
  @IsString()
  @Matches(/^\+?[1-9]\d{9,14}$/, {
    message: 'Invalid phone number. Must be 10-15 digits with optional country code.',
  })
  phoneNumber: string;
}
