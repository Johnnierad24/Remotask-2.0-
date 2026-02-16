import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { WalletService } from './wallet.service';
import { WalletWithdrawDto } from './dto/wallet.dto';

@Controller('wallet')
@UseGuards(JwtAuthGuard)
export class WalletController {
  constructor(private readonly walletService: WalletService) {}

  @Get()
  async getWallet(@Request() req: any) {
    return this.walletService.getWallet(req.user.userId);
  }

  @Post('withdraw')
  async requestWithdrawal(@Request() req: any, @Body() body: WalletWithdrawDto) {
    const { amount, payment_method } = body;
    return this.walletService.requestWithdrawal(req.user.userId, amount, payment_method);
  }
}
