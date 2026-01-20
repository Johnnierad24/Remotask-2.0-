import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SubmissionService {
  constructor(private prisma: PrismaService) {}

  async getSubmissionsForTask(taskId: string) {
    return this.prisma.submission.findMany({ where: { taskId } });
  }

  async submitTask(workerId: string, taskId: string, data: any) {
    return this.prisma.submission.create({
      data: { ...data, workerId, taskId },
    });
  }

  async reviewSubmission(clientId: string, id: string, data: any) {
    // Only allow review if client owns the task
    const submission = await this.prisma.submission.findUnique({ where: { id }, include: { task: true } });
    if (!submission || submission.task.clientId !== clientId) throw new Error('Unauthorized');
    return this.prisma.submission.update({ where: { id }, data });
  }
}
