export declare class CreateTaskDto {
    title: string;
    task_type: string;
    instructions: string;
    pay_per_task: number;
    required_submissions: number;
    status?: string;
}
export declare class UpdateTaskDto {
    title?: string;
    task_type?: string;
    instructions?: string;
    pay_per_task?: number;
    required_submissions?: number;
    status?: string;
}
