import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as nodemailer from 'nodemailer';

@Injectable()
export class NotificationService {
  constructor(private prisma: PrismaService) {}

  async getUserNotifications(userId: string) {
    return this.prisma.notification.findMany({ where: { userId } });
  }

  async createNotification(userId: string, title: string, message: string) {
    // In-app notification
    const notification = await this.prisma.notification.create({
      data: { userId, title, message },
    });
    // Optionally send email as well
    // await this.sendEmail(userId, title, message);
    return notification;
  }

  async sendEmail(userId: string, subject: string, text: string) {
    // Fetch user email from DB
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) return;
    // Configure nodemailer (use real credentials in production)
    const transporter = nodemailer.createTransport({
      host: 'smtp.example.com',
      port: 587,
      secure: false,
      auth: {
        user: 'your_email@example.com',
        pass: 'your_password',
      },
    });
    await transporter.sendMail({
      from: 'no-reply@example.com',
      to: user.email,
      subject,
      text,
    });
  }
}
