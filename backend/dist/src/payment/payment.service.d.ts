import { ConfigService } from '@nestjs/config';
export declare class PaymentService {
    private configService;
    private baseUrl;
    private secretKey;
    private publicKey;
    constructor(configService: ConfigService);
    initializePayment(data: {
        amount: number;
        email: string;
        name: string;
        tx_ref: string;
        redirect_url?: string;
    }): Promise<{
        status: string;
        data: any;
        link: any;
    }>;
    verifyPayment(transactionId: string): Promise<{
        status: any;
        data: any;
    }>;
    processPayout(data: {
        amount: number;
        account_bank: string;
        account_number: string;
        currency?: string;
        narration?: string;
        reference: string;
        beneficiary_name?: string;
    }): Promise<{
        status: string;
        data: any;
    }>;
    processMobileMoneyPayout(data: {
        amount: number;
        phone_number: string;
        currency?: string;
        narration?: string;
        reference: string;
    }): Promise<{
        status: string;
        data: any;
    }>;
    getBanks(country?: string): Promise<any>;
    verifyAccountNumber(accountNumber: string, accountBank: string): Promise<{
        status: string;
        data: any;
    }>;
}
