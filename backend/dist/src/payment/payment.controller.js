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
exports.PaymentController = void 0;
const common_1 = require("@nestjs/common");
const payment_service_1 = require("./payment.service");
const prisma_service_1 = require("../../prisma/prisma.service");
const jwt_auth_guard_1 = require("../../auth/jwt-auth.guard");
let PaymentController = class PaymentController {
    constructor(paymentService, prisma) {
        this.paymentService = paymentService;
        this.prisma = prisma;
    }
    async initializeDeposit(req, body) {
        const user = await this.prisma.user.findUnique({
            where: { id: req.user.userId },
        });
        if (!user) {
            throw new Error('User not found');
        }
        const txRef = `DEP-${user.id}-${Date.now()}`;
        const payment = await this.paymentService.initializePayment({
            amount: body.amount,
            email: user.email,
            name: user.full_name,
            tx_ref: txRef,
        });
        return Object.assign({ message: 'Payment initialized successfully' }, payment);
    }
    async verifyPayment(req, transactionId) {
        const verification = await this.paymentService.verifyPayment(transactionId);
        if (verification.status === 'success' && verification.data.status === 'successful') {
            const wallet = await this.prisma.wallet.findUnique({
                where: { userId: req.user.userId },
            });
            if (!wallet) {
                throw new Error('Wallet not found');
            }
            await this.prisma.wallet.update({
                where: { id: wallet.id },
                data: { balance: { increment: verification.data.amount } },
            });
            await this.prisma.walletTransaction.create({
                data: {
                    walletId: wallet.id,
                    transaction_type: 'DEPOSIT',
                    amount: verification.data.amount,
                    status: 'COMPLETED',
                },
            });
            return {
                message: 'Payment verified and wallet credited',
                amount: verification.data.amount,
            };
        }
        return {
            message: 'Payment verification failed',
            status: verification.data.status,
        };
    }
    async getBanks(country = 'KE') {
        const banks = await this.paymentService.getBanks(country);
        return { banks };
    }
    async handleWebhook(body) {
        console.log('Flutterwave Webhook:', body);
        return { status: 'received' };
    }
};
exports.PaymentController = PaymentController;
__decorate([
    (0, common_1.Post)('deposit/initialize'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], PaymentController.prototype, "initializeDeposit", null);
__decorate([
    (0, common_1.Get)('verify/:transactionId'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    __param(0, (0, common_1.Request)()),
    __param(1, (0, common_1.Param)('transactionId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], PaymentController.prototype, "verifyPayment", null);
__decorate([
    (0, common_1.Get)('banks'),
    (0, common_1.UseGuards)(jwt_auth_guard_1.JwtAuthGuard),
    __param(0, (0, common_1.Query)('country')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], PaymentController.prototype, "getBanks", null);
__decorate([
    (0, common_1.Post)('webhook'),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], PaymentController.prototype, "handleWebhook", null);
exports.PaymentController = PaymentController = __decorate([
    (0, common_1.Controller)('payments'),
    __metadata("design:paramtypes", [payment_service_1.PaymentService,
        prisma_service_1.PrismaService])
], PaymentController);
//# sourceMappingURL=payment.controller.js.map