import { AddressesService } from './addresses.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';
export declare class AddressesController {
    private addressesService;
    constructor(addressesService: AddressesService);
    findAll(req: any): Promise<any[]>;
    create(req: any, dto: CreateAddressDto): Promise<any>;
    update(id: string, req: any, dto: UpdateAddressDto): Promise<any>;
    remove(id: string, req: any): Promise<{
        id: string;
        createdAt: Date;
        userId: string;
        phone: string;
        label: string;
        addressLine1: string;
        addressLine2: string | null;
        city: string;
        state: string;
        postalCode: string;
        latitude: import("@prisma/client/runtime/library").Decimal;
        longitude: import("@prisma/client/runtime/library").Decimal;
        isDefault: boolean;
    }>;
}
