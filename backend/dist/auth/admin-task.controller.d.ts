import { AdminTaskService } from './admin-task.service';
import { AdminUpdateTaskDto } from './dto/admin.dto';
export declare class AdminTaskController {
    private readonly adminTaskService;
    constructor(adminTaskService: AdminTaskService);
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
    updateTask(id: string, body: AdminUpdateTaskDto): Promise<{
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
