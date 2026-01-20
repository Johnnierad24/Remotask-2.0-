import { Controller, Get, Put, UseGuards, Param, Body } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { AdminPayoutService } from './admin-payout.service';
import { AdminRejectPayoutDto } from './dto/admin.dto';

@Controller('admin/payouts')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AdminPayoutController {
  constructor(private readonly adminPayoutService: AdminPayoutService) {}

  @Get()
  async getAllPayoutRequests() {
    return this.adminPayoutService.getAllPayoutRequests();
  }

  @Put(':id/approve')
  async approvePayout(@Param('id') id: string) {
    return this.adminPayoutService.approvePayout(id);
  }

  @Put(':id/reject')
  async rejectPayout(@Param('id') id: string, @Body() body: AdminRejectPayoutDto) {
    const { rejection_reason } = body;
    return this.adminPayoutService.rejectPayout(id, rejection_reason);
  }
}
