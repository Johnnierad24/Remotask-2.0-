import { Controller, Get, Post, Put, Delete, Body, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { ClientProfileService } from './client-profile.service';
import { CreateClientProfileDto, UpdateClientProfileDto } from './dto/client-profile.dto';

@Controller('client-profile')
@UseGuards(JwtAuthGuard)
export class ClientProfileController {
  constructor(private readonly clientProfileService: ClientProfileService) {}

  @Get('me')
  async getMyProfile(@Request() req: any) {
    return this.clientProfileService.getProfile(req.user.userId);
  }

  @Post()
  async createProfile(@Request() req: any, @Body() body: CreateClientProfileDto) {
    return this.clientProfileService.createProfile(req.user.userId, body);
  }

  @Put()
  async updateProfile(@Request() req: any, @Body() body: UpdateClientProfileDto) {
    return this.clientProfileService.updateProfile(req.user.userId, body);
  }

  @Delete()
  async deleteProfile(@Request() req: any) {
    return this.clientProfileService.deleteProfile(req.user.userId);
  }
}
