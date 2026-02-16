import { PrismaService } from '../prisma/prisma.service';
export declare class SubmissionService {
    private prisma;
    constructor(prisma: PrismaService);
    getSubmissionsForTask(taskId: string): Promise<{
        id: string;
        created_at: Date;
        status: string;
        rejection_reason: string | null;
        taskId: string;
        workerId: string;
        response: string;
    }[]>;
    submitTask(workerId: string, taskId: string, data: any): Promise<{
        id: string;
        created_at: Date;
        status: string;
        rejection_reason: string | null;
        taskId: string;
        workerId: string;
        response: string;
    }>;
    reviewSubmission(clientId: string, id: string, data: any): Promise<{
        id: string;
        created_at: Date;
        status: string;
        rejection_reason: string | null;
        taskId: string;
        workerId: string;
        response: string;
    }>;
}
