import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AdminTaskService {
  constructor(private prisma: PrismaService) {}

  async getAllTasks() {
    return this.prisma.task.findMany();
  }

  async updateTask(id: string, data: any) {
    return this.prisma.task.update({ where: { id }, data });
  }

  async deleteTask(id: string) {
    return this.prisma.task.delete({ where: { id } });
  }
}
