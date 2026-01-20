import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class WorkerProfileService {
  constructor(private prisma: PrismaService) {}

  async getProfile(userId: string) {
    return this.prisma.workerProfile.findUnique({ where: { userId } });
  }

  async createProfile(userId: string, data: any) {
    return this.prisma.workerProfile.create({
      data: { ...data, userId },
    });
  }

  async updateProfile(userId: string, data: any) {
    return this.prisma.workerProfile.update({
      where: { userId },
      data,
    });
  }

  async deleteProfile(userId: string) {
    return this.prisma.workerProfile.delete({ where: { userId } });
  }
}
