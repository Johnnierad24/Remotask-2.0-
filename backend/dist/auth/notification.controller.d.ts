import { NotificationService } from './notification.service';
import { CreateNotificationDto } from './dto/notification.dto';
export declare class NotificationController {
    private readonly notificationService;
    constructor(notificationService: NotificationService);
    getMyNotifications(req: any): Promise<{
        id: string;
        userId: string;
        title: string;
        message: string;
        read: boolean;
        created_at: Date;
    }[]>;
    createNotification(req: any, body: CreateNotificationDto): Promise<{
        id: string;
        userId: string;
        title: string;
        message: string;
        read: boolean;
        created_at: Date;
    }>;
}
