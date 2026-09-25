import { IsString, IsIn } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterFcmTokenDto {
  @ApiProperty({ description: 'Firebase Cloud Messaging token' })
  @IsString()
  token: string;

  @ApiProperty({ enum: ['android', 'ios', 'web'], example: 'android' })
  @IsString()
  @IsIn(['android', 'ios', 'web'], { message: 'Platform must be android, ios, or web' })
  platform: string;
}
