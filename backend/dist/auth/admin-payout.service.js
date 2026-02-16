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
exports.AdminPayoutService = void 0;
const common_1 = require("@nestjs/common");
const prisma_service_1 = require("../prisma/prisma.service");
let AdminPayoutService = class AdminPayoutService {
    constructor(prisma) {
        this.prisma = prisma;
    }
    async getAllPayoutRequests() {
        return this.prisma.payoutRequest.findMany();
    }
    async approvePayout(id) {
        return this.prisma.payoutRequest.update({
            where: { id },
            data: { status: 'APPROVED' },
        });
    }
    async rejectPayout(id, rejection_reason) {
        return this.prisma.payoutRequest.update({
            where: { id },
            data: { status: 'REJECTED', payment_method: rejection_reason },
        });
    }
};
exports.AdminPayoutService = AdminPayoutService;
exports.AdminPayoutService = AdminPayoutService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [prisma_service_1.PrismaService])
], AdminPayoutService);
//# sourceMappingURL=admin-payout.service.js.map