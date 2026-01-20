import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { NotificationService } from './notification.service';
import { CreateNotificationDto } from './dto/notification.dto';

@Controller('notifications')
@UseGuards(JwtAuthGuard)
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Get()
  async getMyNotifications(@Request() req) {
    return this.notificationService.getUserNotifications(req.user.userId);
  }

  @Post()
  async createNotification(@Request() req, @Body() body: CreateNotificationDto) {
    const { title, message } = body;
    return this.notificationService.createNotification(req.user.userId, title, message);
  }
}
