import { PrismaService } from '../prisma/prisma.service';
export declare class NotificationService {
    private prisma;
    constructor(prisma: PrismaService);
    getUserNotifications(userId: string): Promise<{
        id: string;
        userId: string;
        title: string;
        message: string;
        read: boolean;
        created_at: Date;
    }[]>;
    createNotification(userId: string, title: string, message: string): Promise<{
        id: string;
        userId: string;
        title: string;
        message: string;
        read: boolean;
        created_at: Date;
    }>;
    sendEmail(userId: string, subject: string, text: string): Promise<void>;
}
