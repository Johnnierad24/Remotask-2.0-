"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.StorageService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const supabase_js_1 = require("@supabase/supabase-js");
let StorageService = class StorageService {
    constructor(configService) {
        this.configService = configService;
        this.supabase = null;
        const supabaseUrl = this.configService.get('SUPABASE_URL');
        const supabaseKey = this.configService.get('SUPABASE_SERVICE_ROLE_KEY');
        this.bucketName = this.configService.get('SUPABASE_BUCKET_NAME') || 'remotask-files';
        if (supabaseUrl && supabaseKey) {
            this.supabase = (0, supabase_js_1.createClient)(supabaseUrl, supabaseKey);
        }
    }
    async uploadFile(file, folder = 'tasks') {
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
    async uploadFiles(files, folder = 'tasks') {
        const uploadPromises = files.map((file) => this.uploadFile(file, folder));
        return Promise.all(uploadPromises);
    }
    async deleteFile(filePath) {
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
    async getSignedUrl(filePath, expiresIn = 3600) {
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
};
exports.StorageService = StorageService;
exports.StorageService = StorageService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], StorageService);
//# sourceMappingURL=storage.service.js.map