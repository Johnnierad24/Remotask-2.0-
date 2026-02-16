import { PaymentService } from './payment.service';
import { PrismaService } from '../../prisma/prisma.service';
export declare class PaymentController {
    private readonly paymentService;
    private readonly prisma;
    constructor(paymentService: PaymentService, prisma: PrismaService);
    initializeDeposit(req: any, body: {
        amount: number;
    }): Promise<{
        status: string;
        data: any;
        link: any;
        message: string;
    }>;
    verifyPayment(req: any, transactionId: string): Promise<{
        message: string;
        amount: any;
        status?: undefined;
    } | {
        message: string;
        status: any;
        amount?: undefined;
    }>;
    getBanks(country?: string): Promise<{
        banks: any;
    }>;
    handleWebhook(body: any): Promise<{
        status: string;
    }>;
}
