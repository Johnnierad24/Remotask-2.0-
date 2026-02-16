import { AdminPayoutService } from './admin-payout.service';
import { AdminRejectPayoutDto } from './dto/admin.dto';
export declare class AdminPayoutController {
    private readonly adminPayoutService;
    constructor(adminPayoutService: AdminPayoutService);
    getAllPayoutRequests(): Promise<{
        id: string;
        userId: string;
        created_at: Date;
        status: string;
        amount: number;
        payment_method: string;
    }[]>;
    approvePayout(id: string): Promise<{
        id: string;
        userId: string;
        created_at: Date;
        status: string;
        amount: number;
        payment_method: string;
    }>;
    rejectPayout(id: string, body: AdminRejectPayoutDto): Promise<{
        id: string;
        userId: string;
        created_at: Date;
        status: string;
        amount: number;
        payment_method: string;
    }>;
}
