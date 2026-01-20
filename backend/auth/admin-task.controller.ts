import { Controller, Get, Put, Delete, Param, UseGuards, Body } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { RolesGuard } from '../auth/roles.guard';
import { AdminTaskService } from './admin-task.service';
import { AdminUpdateTaskDto } from './dto/admin.dto';

@Controller('admin/tasks')
@UseGuards(JwtAuthGuard, RolesGuard)
export class AdminTaskController {
  constructor(private readonly adminTaskService: AdminTaskService) {}

  @Get()
  async getAllTasks() {
    return this.adminTaskService.getAllTasks();
  }

  @Put(':id')
  async updateTask(@Param('id') id: string, @Body() body: AdminUpdateTaskDto) {
    return this.adminTaskService.updateTask(id, body);
  }

  @Delete(':id')
  async deleteTask(@Param('id') id: string) {
    return this.adminTaskService.deleteTask(id);
  }
}
