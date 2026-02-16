import { PrismaService } from '../prisma/prisma.service';
export declare class WorkerProfileService {
    private prisma;
    constructor(prisma: PrismaService);
    getProfile(userId: string): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    } | null>;
    createProfile(userId: string, data: any): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    }>;
    updateProfile(userId: string, data: any): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    }>;
    deleteProfile(userId: string): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    }>;
}
