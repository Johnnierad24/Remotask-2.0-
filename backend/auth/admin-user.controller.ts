import { Controller, Get, Put, Delete, Param, UseGuards, Body } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { AdminUserService } from './admin-user.service';
import { AdminUpdateUserDto } from './dto/admin.dto';

@Controller('admin/users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AdminUserController {
  constructor(private readonly adminUserService: AdminUserService) {}

  @Get()
  async getAllUsers() {
    return this.adminUserService.getAllUsers();
  }

  @Put(':id')
  async updateUser(@Param('id') id: string, @Body() body: AdminUpdateUserDto) {
    return this.adminUserService.updateUser(id, body);
  }

  @Delete(':id')
  async deleteUser(@Param('id') id: string) {
    return this.adminUserService.deleteUser(id);
  }
}
