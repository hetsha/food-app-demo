import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { GooglePlacesService } from './google-places.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Google Places')
@Controller('places')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class GooglePlacesController {
  constructor(private googlePlacesService: GooglePlacesService) {}

  @Get('search')
  @ApiOperation({ summary: 'Search places' })
  async search(@Query('query') query: string) {
    return this.googlePlacesService.searchPlaces(query);
  }

  @Get('reverse-geocode')
  @ApiOperation({ summary: 'Reverse geocode coordinates' })
  async reverseGeocode(@Query('lat') lat: string, @Query('lng') lng: string) {
    return this.googlePlacesService.reverseGeocode(parseFloat(lat), parseFloat(lng));
  }
}
