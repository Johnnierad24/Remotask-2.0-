import { Controller, Get, Post, Put, Delete, Body, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { WorkerProfileService } from './worker-profile.service';
import { CreateWorkerProfileDto, UpdateWorkerProfileDto } from './dto/worker-profile.dto';

@Controller('worker-profile')
@UseGuards(JwtAuthGuard)
export class WorkerProfileController {
  constructor(private readonly workerProfileService: WorkerProfileService) {}

  @Get('me')
  async getMyProfile(@Request() req: any) {
    return this.workerProfileService.getProfile(req.user.userId);
  }

  @Post()
  async createProfile(@Request() req: any, @Body() body: CreateWorkerProfileDto) {
    return this.workerProfileService.createProfile(req.user.userId, body);
  }

  @Put()
  async updateProfile(@Request() req: any, @Body() body: UpdateWorkerProfileDto) {
    return this.workerProfileService.updateProfile(req.user.userId, body);
  }

  @Delete()
  async deleteProfile(@Request() req: any) {
    return this.workerProfileService.deleteProfile(req.user.userId);
  }
}
