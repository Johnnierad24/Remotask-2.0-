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
exports.PaymentService = void 0;
const common_1 = require("@nestjs/common");
const config_1 = require("@nestjs/config");
const axios_1 = require("axios");
let PaymentService = class PaymentService {
    constructor(configService) {
        this.configService = configService;
        this.baseUrl = 'https://api.flutterwave.com/v3';
        this.secretKey = this.configService.get('FLUTTERWAVE_SECRET_KEY') || '';
        this.publicKey = this.configService.get('FLUTTERWAVE_PUBLIC_KEY') || '';
    }
    async initializePayment(data) {
        var _a, _b;
        try {
            const response = await axios_1.default.post(`${this.baseUrl}/payments`, {
                tx_ref: data.tx_ref,
                amount: data.amount,
                currency: 'USD',
                redirect_url: data.redirect_url || `${this.configService.get('FRONTEND_URL')}/payment/callback`,
                payment_options: 'card,mobilemoney,ussd',
                customer: {
                    email: data.email,
                    name: data.name,
                },
                customizations: {
                    title: 'CANARY Wallet Deposit',
                    description: 'Add funds to your wallet',
                    logo: 'https://your-logo-url.com/logo.png',
                },
            }, {
                headers: {
                    Authorization: `Bearer ${this.secretKey}`,
                    'Content-Type': 'application/json',
                },
            });
            return {
                status: 'success',
                data: response.data.data,
                link: response.data.data.link,
            };
        }
        catch (error) {
            throw new Error(`Payment initialization failed: ${((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.message) || error.message}`);
        }
    }
    async verifyPayment(transactionId) {
        var _a, _b;
        try {
            const response = await axios_1.default.get(`${this.baseUrl}/transactions/${transactionId}/verify`, {
                headers: {
                    Authorization: `Bearer ${this.secretKey}`,
                },
            });
            return {
                status: response.data.status,
                data: response.data.data,
            };
        }
        catch (error) {
            throw new Error(`Payment verification failed: ${((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.message) || error.message}`);
        }
    }
    async processPayout(data) {
        var _a, _b;
        try {
            const response = await axios_1.default.post(`${this.baseUrl}/transfers`, {
                account_bank: data.account_bank,
                account_number: data.account_number,
                amount: data.amount,
                currency: data.currency || 'USD',
                narration: data.narration || 'CANARY payout',
                reference: data.reference,
                callback_url: `${this.configService.get('BACKEND_URL')}/api/v1/payments/payout-callback`,
                debit_currency: data.currency || 'USD',
            }, {
                headers: {
                    Authorization: `Bearer ${this.secretKey}`,
                    'Content-Type': 'application/json',
                },
            });
            return {
                status: 'success',
                data: response.data.data,
            };
        }
        catch (error) {
            throw new Error(`Payout failed: ${((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.message) || error.message}`);
        }
    }
    async processMobileMoneyPayout(data) {
        var _a, _b;
        try {
            const response = await axios_1.default.post(`${this.baseUrl}/transfers`, {
                account_bank: 'MPS',
                account_number: data.phone_number,
                amount: data.amount,
                currency: data.currency || 'KES',
                narration: data.narration || 'CANARY payout',
                reference: data.reference,
                callback_url: `${this.configService.get('BACKEND_URL')}/api/v1/payments/payout-callback`,
            }, {
                headers: {
                    Authorization: `Bearer ${this.secretKey}`,
                    'Content-Type': 'application/json',
                },
            });
            return {
                status: 'success',
                data: response.data.data,
            };
        }
        catch (error) {
            throw new Error(`Mobile Money payout failed: ${((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.message) || error.message}`);
        }
    }
    async getBanks(country = 'KE') {
        var _a, _b;
        try {
            const response = await axios_1.default.get(`${this.baseUrl}/banks/${country}`, {
                headers: {
                    Authorization: `Bearer ${this.secretKey}`,
                },
            });
            return response.data.data;
        }
        catch (error) {
            throw new Error(`Failed to fetch banks: ${((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.message) || error.message}`);
        }
    }
    async verifyAccountNumber(accountNumber, accountBank) {
        var _a, _b;
        try {
            const response = await axios_1.default.post(`${this.baseUrl}/accounts/resolve`, {
                account_number: accountNumber,
                account_bank: accountBank,
            }, {
                headers: {
                    Authorization: `Bearer ${this.secretKey}`,
                    'Content-Type': 'application/json',
                },
            });
            return {
                status: 'success',
                data: response.data.data,
            };
        }
        catch (error) {
            throw new Error(`Account verification failed: ${((_b = (_a = error.response) === null || _a === void 0 ? void 0 : _a.data) === null || _b === void 0 ? void 0 : _b.message) || error.message}`);
        }
    }
};
exports.PaymentService = PaymentService;
exports.PaymentService = PaymentService = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [config_1.ConfigService])
], PaymentService);
//# sourceMappingURL=payment.service.js.map