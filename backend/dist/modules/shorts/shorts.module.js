"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ShortsModule = void 0;
const common_1 = require("@nestjs/common");
const shorts_service_1 = require("./shorts.service");
const shorts_controller_1 = require("./shorts.controller");
let ShortsModule = class ShortsModule {
};
exports.ShortsModule = ShortsModule;
exports.ShortsModule = ShortsModule = __decorate([
    (0, common_1.Module)({
        providers: [shorts_service_1.ShortsService],
        controllers: [shorts_controller_1.ShortsController],
        exports: [shorts_service_1.ShortsService],
    })
], ShortsModule);
//# sourceMappingURL=shorts.module.js.map