import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ClientProfileService {
  constructor(private prisma: PrismaService) {}

  async getProfile(userId: string) {
    return this.prisma.clientProfile.findUnique({ where: { userId } });
  }

  async createProfile(userId: string, data: any) {
    return this.prisma.clientProfile.create({
      data: { ...data, userId },
    });
  }

  async updateProfile(userId: string, data: any) {
    return this.prisma.clientProfile.update({
      where: { userId },
      data,
    });
  }

  async deleteProfile(userId: string) {
    return this.prisma.clientProfile.delete({ where: { userId } });
  }
}
