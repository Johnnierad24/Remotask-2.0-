import { WalletService } from './wallet.service';
import { WalletWithdrawDto } from './dto/wallet.dto';
export declare class WalletController {
    private readonly walletService;
    constructor(walletService: WalletService);
    getWallet(req: any): Promise<({
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
    requestWithdrawal(req: any, body: WalletWithdrawDto): Promise<{
        id: string;
        userId: string;
        created_at: Date;
        status: string;
        amount: number;
        payment_method: string;
    }>;
}
