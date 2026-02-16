import { WorkerProfileService } from './worker-profile.service';
import { CreateWorkerProfileDto, UpdateWorkerProfileDto } from './dto/worker-profile.dto';
export declare class WorkerProfileController {
    private readonly workerProfileService;
    constructor(workerProfileService: WorkerProfileService);
    getMyProfile(req: any): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    } | null>;
    createProfile(req: any, body: CreateWorkerProfileDto): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    }>;
    updateProfile(req: any, body: UpdateWorkerProfileDto): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    }>;
    deleteProfile(req: any): Promise<{
        id: string;
        userId: string;
        skills: string[];
        level: number;
        rating: number | null;
        completed_tasks: number;
    }>;
}
