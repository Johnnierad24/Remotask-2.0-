import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards, Request } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { TaskService } from './task.service';
import { CreateTaskDto, UpdateTaskDto } from './dto/task.dto';

@Controller('tasks')
@UseGuards(JwtAuthGuard)
export class TaskController {
  constructor(private readonly taskService: TaskService) {}

  @Get()
  async getAllTasks() {
    return this.taskService.getAllTasks();
  }

  @Get(':id')
  async getTask(@Param('id') id: string) {
    return this.taskService.getTask(id);
  }

  @Post()
  async createTask(@Request() req: any, @Body() body: CreateTaskDto) {
    return this.taskService.createTask(req.user.userId, body);
  }

  @Put(':id')
  async updateTask(@Request() req: any, @Param('id') id: string, @Body() body: UpdateTaskDto) {
    return this.taskService.updateTask(req.user.userId, id, body);
  }

  @Delete(':id')
  async deleteTask(@Request() req: any, @Param('id') id: string) {
    return this.taskService.deleteTask(req.user.userId, id);
  }
}
