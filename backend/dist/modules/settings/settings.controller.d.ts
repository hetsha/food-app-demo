import { SettingsService } from './settings.service';
export declare class SettingsController {
    private settingsService;
    constructor(settingsService: SettingsService);
    get(key: string): Promise<{
        key: string;
        value: string;
        valueType: string;
    } | null>;
    getAll(): Promise<{
        key: string;
        value: string;
        valueType: string;
        description: string | null;
        updatedAt: Date;
    }[]>;
    set(body: {
        key: string;
        value: string;
        valueType?: string;
        description?: string;
    }): Promise<{
        key: string;
        value: string;
        valueType: string;
        description: string | null;
        updatedAt: Date;
    }>;
    delete(key: string): Promise<{
        key: string;
        value: string;
        valueType: string;
        description: string | null;
        updatedAt: Date;
    }>;
}
