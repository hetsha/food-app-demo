import { IsString, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class GoogleAuthDto {
  @ApiProperty({ description: 'Google ID token from Sign-In with Google' })
  @IsString()
  idToken: string;

  @ApiPropertyOptional({ description: 'FCM token for push notifications' })
  @IsString()
  @IsOptional()
  fcmToken?: string;
}
