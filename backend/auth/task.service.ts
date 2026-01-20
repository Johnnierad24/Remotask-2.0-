import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class TaskService {
  constructor(private prisma: PrismaService) {}

  async getAllTasks() {
    return this.prisma.task.findMany({ include: { files: true, submissions: true } });
  }

  async getTask(id: string) {
    return this.prisma.task.findUnique({ where: { id }, include: { files: true, submissions: true } });
  }

  async createTask(clientId: string, data: any) {
    return this.prisma.task.create({
      data: { ...data, clientId },
    });
  }

  async updateTask(clientId: string, id: string, data: any) {
    // Only allow update if clientId matches
    const task = await this.prisma.task.findUnique({ where: { id } });
    if (!task || task.clientId !== clientId) throw new Error('Unauthorized');
    return this.prisma.task.update({ where: { id }, data });
  }

  async deleteTask(clientId: string, id: string) {
    // Only allow delete if clientId matches
    const task = await this.prisma.task.findUnique({ where: { id } });
    if (!task || task.clientId !== clientId) throw new Error('Unauthorized');
    return this.prisma.task.delete({ where: { id } });
  }
}
