import { AdminUserService } from './admin-user.service';
import { AdminUpdateUserDto } from './dto/admin.dto';
export declare class AdminUserController {
    private readonly adminUserService;
    constructor(adminUserService: AdminUserService);
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
    updateUser(id: string, body: AdminUpdateUserDto): Promise<{
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
