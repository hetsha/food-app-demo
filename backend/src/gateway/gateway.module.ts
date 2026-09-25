import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { OrderGateway } from './gateway.service';

@Module({
  imports: [
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET', 'parabdi-dev-secret'),
      }),
      inject: [ConfigService],
    }),
  ],
  providers: [OrderGateway],
  exports: [OrderGateway],
})
export class GatewayModule {}
