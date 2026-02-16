import { PrismaService } from '../prisma/prisma.service';
export declare class WalletService {
    private prisma;
    constructor(prisma: PrismaService);
    getWallet(userId: string): Promise<({
        transactions: {
            id: string;
            created_at: Date;
            status: string;
            amount: number;
            transaction_type: string;
            walletId: string;
        }[];
    } & {
        id: string;
        userId: string;
        balance: number;
    }) | null>;
    requestWithdrawal(userId: string, amount: number, payment_method: string): Promise<{
        id: string;
        userId: string;
        created_at: Date;
        status: string;
        amount: number;
        payment_method: string;
    }>;
}
