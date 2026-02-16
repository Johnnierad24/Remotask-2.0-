import { ConfigService } from '@nestjs/config';
interface MulterFile {
    fieldname: string;
    originalname: string;
    encoding: string;
    mimetype: string;
    size: number;
    buffer: Buffer;
}
export declare class StorageService {
    private configService;
    private supabase;
    private bucketName;
    constructor(configService: ConfigService);
    uploadFile(file: MulterFile, folder?: string): Promise<{
        url: string;
        path: string;
    }>;
    uploadFiles(files: MulterFile[], folder?: string): Promise<Array<{
        url: string;
        path: string;
    }>>;
    deleteFile(filePath: string): Promise<void>;
    getSignedUrl(filePath: string, expiresIn?: number): Promise<string>;
}
export {};
