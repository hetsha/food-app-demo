import { UsersService } from './users.service';
export declare class UsersController {
    private usersService;
    constructor(usersService: UsersService);
    findAll(skip?: string, take?: string): Promise<{
        id: string;
        phoneNumber: string;
        fullName: string | null;
        email: string | null;
        role: import(".prisma/client").$Enums.UserRole;
        walletBalance: number;
        isBlocked: boolean;
        createdAt: Date;
    }[]>;
}
