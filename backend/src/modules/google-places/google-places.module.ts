import { Module } from '@nestjs/common';
import { GooglePlacesService } from './google-places.service';
import { GooglePlacesController } from './google-places.controller';

@Module({
  providers: [GooglePlacesService],
  controllers: [GooglePlacesController],
  exports: [GooglePlacesService],
})
export class GooglePlacesModule {}
