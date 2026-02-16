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
exports.WorkerProfileService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let WorkerProfileService = class WorkerProfileService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getProfile(userId) {
        return this.prisma.workerProfile.findUnique({ where: { userId } });
    }
    async createProfile(userId, data) {
        return this.prisma.workerProfile.create({
            data: Object.assign(Object.assign({}, data), { userId }),
        });
    }
    async updateProfile(userId, data) {
        return this.prisma.workerProfile.update({
            where: { userId },
            data,
        });
    }
    async deleteProfile(userId) {
        return this.prisma.workerProfile.delete({ where: { userId } });
    }
};
exports.WorkerProfileService = WorkerProfileService;
exports.WorkerProfileService = WorkerProfileService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], WorkerProfileService);
//# sourceMappingURL=worker-profile.service.js.map