import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

// Multer file type definition
interface MulterFile {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  size: number;
  buffer: Buffer;
}

@Injectable()
export class StorageService {
  private supabase: SupabaseClient | null = null;
  private bucketName: string;

  constructor(private configService: ConfigService) {
    const supabaseUrl = this.configService.get<string>('SUPABASE_URL');
    const supabaseKey = this.configService.get<string>('SUPABASE_SERVICE_ROLE_KEY');
    this.bucketName = this.configService.get<string>('SUPABASE_BUCKET_NAME') || 'remotask-files';

    if (supabaseUrl && supabaseKey) {
      this.supabase = createClient(supabaseUrl, supabaseKey);
    }
  }

  /**
   * Upload a file to Supabase Storage
   */
  async uploadFile(
    file: MulterFile,
    folder: string = 'tasks',
  ): Promise<{ url: string; path: string }> {
    if (!this.supabase) {
      throw new Error('Supabase not configured. Please set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY');
    }

    const fileExt = file.originalname.split('.').pop();
    const fileName = `${folder}/${Date.now()}-${Math.random().toString(36).substring(7)}.${fileExt}`;

    const { data, error } = await this.supabase.storage
      .from(this.bucketName)
      .upload(fileName, file.buffer, {
        contentType: file.mimetype,
        upsert: false,
      });

    if (error) {
      throw new Error(`File upload failed: ${error.message}`);
    }

    const { data: urlData } = this.supabase.storage
      .from(this.bucketName)
      .getPublicUrl(data.path);

    return {
      url: urlData.publicUrl,
      path: data.path,
    };
  }

  /**
   * Upload multiple files
   */
  async uploadFiles(
    files: MulterFile[],
    folder: string = 'tasks',
  ): Promise<Array<{ url: string; path: string }>> {
    const uploadPromises = files.map((file) => this.uploadFile(file, folder));
    return Promise.all(uploadPromises);
  }

  /**
   * Delete a file from storage
   */
  async deleteFile(filePath: string): Promise<void> {
    if (!this.supabase) {
      throw new Error('Supabase not configured');
    }

    const { error } = await this.supabase.storage
      .from(this.bucketName)
      .remove([filePath]);

    if (error) {
      throw new Error(`File deletion failed: ${error.message}`);
    }
  }

  /**
   * Get a signed URL for private files (optional, for secure access)
   */
  async getSignedUrl(filePath: string, expiresIn: number = 3600): Promise<string> {
    if (!this.supabase) {
      throw new Error('Supabase not configured');
    }

    const { data, error } = await this.supabase.storage
      .from(this.bucketName)
      .createSignedUrl(filePath, expiresIn);

    if (error) {
      throw new Error(`Failed to generate signed URL: ${error.message}`);
    }

    return data.signedUrl;
  }
}
