import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';

@Injectable()
export class GooglePlacesService {
  private apiKey: string;

  constructor(private configService: ConfigService) {
    this.apiKey = configService.get<string>('GOOGLE_PLACES_API_KEY') || '';
  }

  async searchPlaces(query: string) {
    if (!this.apiKey) {
      return { places: [], error: 'Google Places API key not configured' };
    }

    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/place/textsearch/json`,
        {
          params: {
            query: `${query} Ahmedabad Gujarat India`,
            key: this.apiKey,
          },
        },
      );

      return {
        places: response.data.results.map((place: any) => ({
          id: place.place_id,
          name: place.name,
          address: place.formatted_address,
          latitude: place.geometry.location.lat,
          longitude: place.geometry.location.lng,
          rating: place.rating,
        })),
      };
    } catch (error) {
      return { places: [], error: 'Failed to fetch places' };
    }
  }

  async reverseGeocode(lat: number, lng: number) {
    if (!this.apiKey) {
      return { address: null, error: 'Google Places API key not configured' };
    }

    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json`,
        {
          params: {
            latlng: `${lat},${lng}`,
            key: this.apiKey,
          },
        },
      );

      if (response.data.results.length > 0) {
        const result = response.data.results[0];
        return {
          address: result.formatted_address,
          city: this.extractCity(result.address_components),
          state: this.extractState(result.address_components),
          postalCode: this.extractPostalCode(result.address_components),
        };
      }
      return { address: null, error: 'No results found' };
    } catch (error) {
      return { address: null, error: 'Failed to reverse geocode' };
    }
  }

  private extractCity(components: any[]): string {
    const city = components.find((c) => c.types.includes('locality'));
    return city?.long_name || 'Ahmedabad';
  }

  private extractState(components: any[]): string {
    const state = components.find((c) => c.types.includes('administrative_area_level_1'));
    return state?.long_name || 'Gujarat';
  }

  private extractPostalCode(components: any[]): string {
    const postal = components.find((c) => c.types.includes('postal_code'));
    return postal?.long_name || '';
  }
}
