import { SubmissionService } from './submission.service';
import { CreateSubmissionDto, ReviewSubmissionDto } from './dto/submission.dto';
export declare class SubmissionController {
    private readonly submissionService;
    constructor(submissionService: SubmissionService);
    getSubmissionsForTask(taskId: string): Promise<{
        id: string;
        created_at: Date;
        status: string;
        rejection_reason: string | null;
        taskId: string;
        workerId: string;
        response: string;
    }[]>;
    submitTask(req: any, taskId: string, body: CreateSubmissionDto): Promise<{
        id: string;
        created_at: Date;
        status: string;
        rejection_reason: string | null;
        taskId: string;
        workerId: string;
        response: string;
    }>;
    reviewSubmission(req: any, id: string, body: ReviewSubmissionDto): Promise<{
        id: string;
        created_at: Date;
        status: string;
        rejection_reason: string | null;
        taskId: string;
        workerId: string;
        response: string;
    }>;
}
