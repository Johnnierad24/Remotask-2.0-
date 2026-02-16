import { PrismaService } from '../prisma/prisma.service';
export declare class AdminPayoutService {
    private prisma;
    constructor(prisma: PrismaService);
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
    rejectPayout(id: string, rejection_reason: string): Promise<{
        id: string;
        userId: string;
        created_at: Date;
        status: string;
        amount: number;
        payment_method: string;
    }>;
}
