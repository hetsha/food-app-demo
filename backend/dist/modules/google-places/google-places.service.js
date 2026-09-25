"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GooglePlacesService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const axios_1 = require("axios");
let GooglePlacesService = class GooglePlacesService {
    constructor(configService) {
        this.configService = configService;
        this.apiKey = configService.get('GOOGLE_PLACES_API_KEY') || '';
    }
    async searchPlaces(query) {
        if (!this.apiKey) {
            return { places: [], error: 'Google Places API key not configured' };
        }
        try {
            const response = await axios_1.default.get(`https://maps.googleapis.com/maps/api/place/textsearch/json`, {
                params: {
                    query: `${query} Ahmedabad Gujarat India`,
                    key: this.apiKey,
                },
            });
            return {
                places: response.data.results.map((place) => ({
                    id: place.place_id,
                    name: place.name,
                    address: place.formatted_address,
                    latitude: place.geometry.location.lat,
                    longitude: place.geometry.location.lng,
                    rating: place.rating,
                })),
            };
        }
        catch (error) {
            return { places: [], error: 'Failed to fetch places' };
        }
    }
    async reverseGeocode(lat, lng) {
        if (!this.apiKey) {
            return { address: null, error: 'Google Places API key not configured' };
        }
        try {
            const response = await axios_1.default.get(`https://maps.googleapis.com/maps/api/geocode/json`, {
                params: {
                    latlng: `${lat},${lng}`,
                    key: this.apiKey,
                },
            });
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
        }
        catch (error) {
            return { address: null, error: 'Failed to reverse geocode' };
        }
    }
    extractCity(components) {
        const city = components.find((c) => c.types.includes('locality'));
        return city?.long_name || 'Ahmedabad';
    }
    extractState(components) {
        const state = components.find((c) => c.types.includes('administrative_area_level_1'));
        return state?.long_name || 'Gujarat';
    }
    extractPostalCode(components) {
        const postal = components.find((c) => c.types.includes('postal_code'));
        return postal?.long_name || '';
    }
};
exports.GooglePlacesService = GooglePlacesService;
exports.GooglePlacesService = GooglePlacesService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], GooglePlacesService);
//# sourceMappingURL=google-places.service.js.map