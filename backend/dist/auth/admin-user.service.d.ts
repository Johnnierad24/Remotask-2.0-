import { PrismaService } from '../prisma/prisma.service';
export declare class AdminUserService {
    private prisma;
    constructor(prisma: PrismaService);
    getAllUsers(): Promise<{
        id: string;
        created_at: Date;
        email: string;
        role: string;
        full_name: string;
        phone: string | null;
        password_hash: string;
        country: string | null;
        status: string;
        updated_at: Date;
    }[]>;
    updateUser(id: string, data: any): Promise<{
        id: string;
        created_at: Date;
        email: string;
        role: string;
        full_name: string;
        phone: string | null;
        password_hash: string;
        country: string | null;
        status: string;
        updated_at: Date;
    }>;
    deleteUser(id: string): Promise<{
        id: string;
        created_at: Date;
        email: string;
        role: string;
        full_name: string;
        phone: string | null;
        password_hash: string;
        country: string | null;
        status: string;
        updated_at: Date;
    }>;
}
