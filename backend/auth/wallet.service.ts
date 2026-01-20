import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WalletService {
  constructor(private prisma: PrismaService) {}

  async getWallet(userId: string) {
    return this.prisma.wallet.findUnique({
      where: { userId },
      include: { transactions: true },
    });
  }

  async requestWithdrawal(userId: string, amount: number, payment_method: string) {
    const wallet = await this.prisma.wallet.findUnique({ where: { userId } });
    if (!wallet || wallet.balance < amount) {
      throw new BadRequestException('Insufficient balance');
    }
    // Optionally, deduct balance immediately or after approval
    return this.prisma.payoutRequest.create({
      data: {
        userId,
        amount,
        payment_method,
      },
    });
  }
}
