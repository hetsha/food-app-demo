import { ConfigService } from '@nestjs/config';
export declare class GooglePlacesService {
    private configService;
    private apiKey;
    constructor(configService: ConfigService);
    searchPlaces(query: string): Promise<{
        places: never[];
        error: string;
    } | {
        places: any;
        error?: undefined;
    }>;
    reverseGeocode(lat: number, lng: number): Promise<{
        address: null;
        error: string;
        city?: undefined;
        state?: undefined;
        postalCode?: undefined;
    } | {
        address: any;
        city: string;
        state: string;
        postalCode: string;
        error?: undefined;
    }>;
    private extractCity;
    private extractState;
    private extractPostalCode;
}
