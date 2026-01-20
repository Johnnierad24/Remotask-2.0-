import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AdminPayoutService {
  constructor(private prisma: PrismaService) {}

  async getAllPayoutRequests() {
    return this.prisma.payoutRequest.findMany();
  }

  async approvePayout(id: string) {
    return this.prisma.payoutRequest.update({
      where: { id },
      data: { status: 'APPROVED' },
    });
  }

  async rejectPayout(id: string, rejection_reason: string) {
    return this.prisma.payoutRequest.update({
      where: { id },
      data: { status: 'REJECTED', payment_method: rejection_reason },
    });
  }
}
