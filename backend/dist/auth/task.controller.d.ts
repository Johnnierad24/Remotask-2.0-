import { TaskService } from './task.service';
import { CreateTaskDto, UpdateTaskDto } from './dto/task.dto';
export declare class TaskController {
    private readonly taskService;
    constructor(taskService: TaskService);
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
    createTask(req: any, body: CreateTaskDto): Promise<{
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
    updateTask(req: any, id: string, body: UpdateTaskDto): Promise<{
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
    deleteTask(req: any, id: string): Promise<{
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
