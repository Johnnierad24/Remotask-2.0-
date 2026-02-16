import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from '../auth/auth.module';
import { StorageModule } from './storage/storage.module';
import { PaymentModule } from './payment/payment.module';

@Module({
  imports: [
    // Load environment variables
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    // Storage module for file uploads
    StorageModule,
    // Payment module for Flutterwave integration
    PaymentModule,
    // Auth module contains all controllers and services
    AuthModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
