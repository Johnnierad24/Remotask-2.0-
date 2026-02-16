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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WorkerProfileController = void 0;
const common_1 = require("@nestjs/common");
const jwt_auth_guard_1 = require("../auth/jwt-auth.guard");
const worker_profile_service_1 = require("./worker-profile.service");
const worker_profile_dto_1 = require("./dto/worker-profile.dto");
let WorkerProfileController = class WorkerProfileController {
    constructor(workerProfileService) {
        this.workerProfileService = workerProfileService;
    }
    async getMyProfile(req) {
        return this.workerProfileService.getProfile(req.user.userId);
    }
    async createProfile(req, body) {
        return this.workerProfileService.createProfile(req.user.userId, body);
    }
    async updateProfile(req, body) {
        return this.workerProfileService.updateProfile(req.user.userId, body);
    }
    async deleteProfile(req) {
        return this.workerProfileService.deleteProfile(req.user.userId);
    }
};
exports.WorkerProfileController = WorkerProfileController;
__decorate([
    (0, common_1.Get)('me'),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], WorkerProfileController.prototype, "getMyProfile", null);
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, worker_profile_dto_1.CreateWorkerProfileDto]),
    __metadata("design:returntype", Promise)
], WorkerProfileController.prototype, "createProfile", null);
__decorate([
    (0, common_1.Put)(),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, worker_profile_dto_1.UpdateWorkerProfileDto]),
    __metadata("design:returntype", Promise)
], WorkerProfileController.prototype, "updateProfile", null);
__decorate([
    (0, common_1.Delete)(),
    __param(0, (0, common_1.Request)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], WorkerProfileController.prototype, "deleteProfile", null);
exports.WorkerProfileController = WorkerProfileController = __decorate([
    (0, common_1.Controller)('worker-profile'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    __metadata("design:paramtypes", [worker_profile_service_1.WorkerProfileService])
], WorkerProfileController);
//# sourceMappingURL=worker-profile.controller.js.map