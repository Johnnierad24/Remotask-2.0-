import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { PaymentService } from './payment.service';
import { PaymentController } from './payment.controller';
import { PrismaService } from '../../prisma/prisma.service';

@Module({
  imports: [ConfigModule],
  providers: [PaymentService, PrismaService],
  controllers: [PaymentController],
  exports: [PaymentService],
})
export class PaymentModule {}
