import { PrismaService } from '../prisma/prisma.service';
export declare class ClientProfileService {
    private prisma;
    constructor(prisma: PrismaService);
    getProfile(userId: string): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    } | null>;
    createProfile(userId: string, data: any): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    }>;
    updateProfile(userId: string, data: any): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    }>;
    deleteProfile(userId: string): Promise<{
        id: string;
        userId: string;
        company_name: string;
        verified: boolean;
    }>;
}
