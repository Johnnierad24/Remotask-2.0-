import { Controller, Post, Get, Body, Param, UseGuards, Request, Query } from '@nestjs/common';
import { PaymentService } from './payment.service';
import { PrismaService } from '../../prisma/prisma.service';
import { JwtAuthGuard } from '../../auth/jwt-auth.guard';

@Controller('payments')
export class PaymentController {
  constructor(
    private readonly paymentService: PaymentService,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * Initialize deposit payment for client
   */
  @Post('deposit/initialize')
  @UseGuards(JwtAuthGuard)
  async initializeDeposit(@Request() req: any, @Body() body: { amount: number }) {
    const user = await this.prisma.user.findUnique({
      where: { id: req.user.userId },
    });

    if (!user) {
      throw new Error('User not found');
    }

    const txRef = `DEP-${user.id}-${Date.now()}`;

    const payment = await this.paymentService.initializePayment({
      amount: body.amount,
      email: user.email,
      name: user.full_name,
      tx_ref: txRef,
    });

    return {
      message: 'Payment initialized successfully',
      ...payment,
    };
  }

  /**
   * Verify payment callback
   */
  @Get('verify/:transactionId')
  @UseGuards(JwtAuthGuard)
  async verifyPayment(@Request() req: any, @Param('transactionId') transactionId: string) {
    const verification = await this.paymentService.verifyPayment(transactionId);

    if (verification.status === 'success' && verification.data.status === 'successful') {
      // Credit user wallet
      const wallet = await this.prisma.wallet.findUnique({
        where: { userId: req.user.userId },
      });

      if (!wallet) {
        throw new Error('Wallet not found');
      }

      await this.prisma.wallet.update({
        where: { id: wallet.id },
        data: { balance: { increment: verification.data.amount } },
      });

      // Record transaction
      await this.prisma.walletTransaction.create({
        data: {
          walletId: wallet.id,
          transaction_type: 'DEPOSIT',
          amount: verification.data.amount,
          status: 'COMPLETED',
        },
      });

      return {
        message: 'Payment verified and wallet credited',
        amount: verification.data.amount,
      };
    }

    return {
      message: 'Payment verification failed',
      status: verification.data.status,
    };
  }

  /**
   * Get list of banks for withdrawals
   */
  @Get('banks')
  @UseGuards(JwtAuthGuard)
  async getBanks(@Query('country') country: string = 'KE') {
    const banks = await this.paymentService.getBanks(country);
    return { banks };
  }

  /**
   * Webhook callback for Flutterwave (payment status updates)
   */
  @Post('webhook')
  async handleWebhook(@Body() body: any) {
    // Verify webhook signature
    // Process payment updates
    console.log('Flutterwave Webhook:', body);
    
    // You can process payment confirmations here
    return { status: 'received' };
  }
}
