"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthModule = void 0;
const notification_controller_1 = require("./notification.controller");
const notification_service_1 = require("./notification.service");
const admin_user_controller_1 = require("./admin-user.controller");
const admin_user_service_1 = require("./admin-user.service");
const admin_task_controller_1 = require("./admin-task.controller");
const admin_task_service_1 = require("./admin-task.service");
const admin_payout_controller_1 = require("./admin-payout.controller");
const admin_payout_service_1 = require("./admin-payout.service");
const wallet_controller_1 = require("./wallet.controller");
const wallet_service_1 = require("./wallet.service");
const common_1 = require("@nestjs/common");
const jwt_1 = require("@nestjs/jwt");
const passport_1 = require("@nestjs/passport");
const config_1 = require("@nestjs/config");
const auth_service_1 = require("./auth.service");
const auth_controller_1 = require("./auth.controller");
const prisma_service_1 = require("../prisma/prisma.service");
const jwt_strategy_1 = require("./jwt.strategy");
const worker_profile_controller_1 = require("./worker-profile.controller");
const worker_profile_service_1 = require("./worker-profile.service");
const client_profile_controller_1 = require("./client-profile.controller");
const client_profile_service_1 = require("./client-profile.service");
const task_controller_1 = require("./task.controller");
const task_service_1 = require("./task.service");
const submission_controller_1 = require("./submission.controller");
const submission_service_1 = require("./submission.service");
const storage_module_1 = require("../src/storage/storage.module");
let AuthModule = class AuthModule {
};
exports.AuthModule = AuthModule;
exports.AuthModule = AuthModule = __decorate([
    (0, common_1.Module)({
        imports: [
            passport_1.PassportModule,
            storage_module_1.StorageModule,
            jwt_1.JwtModule.registerAsync({
                imports: [config_1.ConfigModule],
                useFactory: async (configService) => ({
                    secret: configService.get('JWT_SECRET'),
                    signOptions: { expiresIn: configService.get('JWT_EXPIRATION', '7d') },
                }),
                inject: [config_1.ConfigService],
            }),
        ],
        providers: [auth_service_1.AuthService, prisma_service_1.PrismaService, jwt_strategy_1.JwtStrategy, worker_profile_service_1.WorkerProfileService, client_profile_service_1.ClientProfileService, task_service_1.TaskService, submission_service_1.SubmissionService, wallet_service_1.WalletService, admin_user_service_1.AdminUserService, admin_task_service_1.AdminTaskService, admin_payout_service_1.AdminPayoutService, notification_service_1.NotificationService],
        controllers: [auth_controller_1.AuthController, worker_profile_controller_1.WorkerProfileController, client_profile_controller_1.ClientProfileController, task_controller_1.TaskController, submission_controller_1.SubmissionController, wallet_controller_1.WalletController, admin_user_controller_1.AdminUserController, admin_task_controller_1.AdminTaskController, admin_payout_controller_1.AdminPayoutController, notification_controller_1.NotificationController],
    })
], AuthModule);
//# sourceMappingURL=auth.module.js.map