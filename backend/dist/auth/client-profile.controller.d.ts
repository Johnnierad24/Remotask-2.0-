import { ClientProfileService } from './client-profile.service';
import { CreateClientProfileDto, UpdateClientProfileDto } from './dto/client-profile.dto';
export declare class ClientProfileController {
    private readonly clientProfileService;
    constructor(clientProfileService: ClientProfileService);
    getMyProfile(req: any): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    } | null>;
    createProfile(req: any, body: CreateClientProfileDto): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    }>;
    updateProfile(req: any, body: UpdateClientProfileDto): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    }>;
    deleteProfile(req: any): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    }>;
}
