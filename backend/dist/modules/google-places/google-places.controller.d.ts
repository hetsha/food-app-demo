import { GooglePlacesService } from './google-places.service';
export declare class GooglePlacesController {
    private googlePlacesService;
    constructor(googlePlacesService: GooglePlacesService);
    search(query: string): Promise<{
        places: never[];
        error: string;
    } | {
        places: any;
        error?: undefined;
    }>;
    reverseGeocode(lat: string, lng: string): Promise<{
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
}
