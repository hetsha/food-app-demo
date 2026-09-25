export declare class CreateAddressDto {
    label: string;
    addressLine1: string;
    addressLine2?: string;
    city?: string;
    state?: string;
    postalCode: string;
    latitude: number;
    longitude: number;
    phone: string;
    isDefault?: boolean;
}
