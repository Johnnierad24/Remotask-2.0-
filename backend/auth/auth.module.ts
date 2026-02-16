import { NotificationController } from './notification.controller';
import { NotificationService } from './notification.service';
import { AdminUserController } from './admin-user.controller';
import { AdminUserService } from './admin-user.service';
import { AdminTaskController } from './admin-task.controller';
import { AdminTaskService } from './admin-task.service';
import { AdminPayoutController } from './admin-payout.controller';
import { AdminPayoutService } from './admin-payout.service';
import { WalletController } from './wallet.controller';
import { WalletService } from './wallet.service';
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PrismaService } from '../prisma/prisma.service';
import { JwtStrategy } from './jwt.strategy';
import { WorkerProfileController } from './worker-profile.controller';
import { WorkerProfileService } from './worker-profile.service';
import { ClientProfileController } from './client-profile.controller';
import { ClientProfileService } from './client-profile.service';
import { TaskController } from './task.controller';
import { TaskService } from './task.service';
import { SubmissionController } from './submission.controller';
import { SubmissionService } from './submission.service';
import { StorageModule } from '../src/storage/storage.module';

@Module({
  imports: [
    PassportModule,
    StorageModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET'),
        signOptions: { expiresIn: configService.get<string>('JWT_EXPIRATION', '7d') },
      }),
      inject: [ConfigService],
    }),
  ],
  providers: [AuthService, PrismaService, JwtStrategy, WorkerProfileService, ClientProfileService, TaskService, SubmissionService, WalletService, AdminUserService, AdminTaskService, AdminPayoutService, NotificationService],
  controllers: [AuthController, WorkerProfileController, ClientProfileController, TaskController, SubmissionController, WalletController, AdminUserController, AdminTaskController, AdminPayoutController, NotificationController],
})
export class AuthModule {}
