import { PrismaService } from '../prisma/prisma.service';
export declare class AdminTaskService {
    private prisma;
    constructor(prisma: PrismaService);
    getAllTasks(): Promise<{
        id: string;
        title: string;
        created_at: Date;
        status: string;
        clientId: string;
        task_type: string;
        instructions: string;
        pay_per_task: number;
        required_submissions: number;
    }[]>;
    updateTask(id: string, data: any): Promise<{
        id: string;
        title: string;
        created_at: Date;
        status: string;
        clientId: string;
        task_type: string;
        instructions: string;
        pay_per_task: number;
        required_submissions: number;
    }>;
    deleteTask(id: string): Promise<{
        id: string;
        title: string;
        created_at: Date;
        status: string;
        clientId: string;
        task_type: string;
        instructions: string;
        pay_per_task: number;
        required_submissions: number;
    }>;
}
