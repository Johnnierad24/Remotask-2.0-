import { PrismaService } from '../prisma/prisma.service';
export declare class TaskService {
    private prisma;
    constructor(prisma: PrismaService);
    getAllTasks(): Promise<({
        submissions: {
            id: string;
            created_at: Date;
            status: string;
            rejection_reason: string | null;
            taskId: string;
            workerId: string;
            response: string;
        }[];
        files: {
            id: string;
            taskId: string;
            file_url: string;
            file_type: string;
        }[];
    } & {
        id: string;
        title: string;
        created_at: Date;
        status: string;
        clientId: string;
        task_type: string;
        instructions: string;
        pay_per_task: number;
        required_submissions: number;
    })[]>;
    getTask(id: string): Promise<({
        submissions: {
            id: string;
            created_at: Date;
            status: string;
            rejection_reason: string | null;
            taskId: string;
            workerId: string;
            response: string;
        }[];
        files: {
            id: string;
            taskId: string;
            file_url: string;
            file_type: string;
        }[];
    } & {
        id: string;
        title: string;
        created_at: Date;
        status: string;
        clientId: string;
        task_type: string;
        instructions: string;
        pay_per_task: number;
        required_submissions: number;
    }) | null>;
    createTask(clientId: string, data: any): Promise<{
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
    updateTask(clientId: string, id: string, data: any): Promise<{
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
    deleteTask(clientId: string, id: string): Promise<{
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
