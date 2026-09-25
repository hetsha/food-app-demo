# Phase 2: Authentication System — Tracking Document

**Status:** ✅ COMPLETE (79/79 backend tests passing, Flutter auth integrated)
**Depends On:** Phase 1 (Backend Setup)
**Estimated Hours:** 43h

---

## Tasks Checklist

### 2.1 Backend Auth Module
| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.1.1 | Create auth.module.ts | ✅ DONE | JWT, Passport, ConfigModule, UsersModule |
| 2.1.2 | Create jwt.strategy.ts | ✅ DONE | Extracts JWT, validates user exists + not blocked |
| 2.1.3 | Create jwt-auth.guard.ts | ✅ DONE | Supports @Public() bypass |
| 2.1.4 | Create roles.guard.ts | ✅ DONE | Checks user role against @Roles() |
| 2.1.5 | Create @Roles() decorator | ✅ DONE | Metadata decorator for UserRole enum |
| 2.1.6 | Create auth.service.ts | ✅ DONE | OTP send/verify, Google auth, tokens, profile |
| 2.1.7 | Create auth.controller.ts | ✅ DONE | All 8 auth endpoints |
| 2.1.8 | Create send-otp.dto.ts | ✅ DONE | Phone validation with regex |
| 2.1.9 | Create verify-otp.dto.ts | ✅ DONE | Phone + 6-digit OTP validation |
| 2.1.10 | Create refresh-token.dto.ts | ✅ DONE | Refresh token string validation |
| 2.1.11 | Create google-auth.dto.ts | ✅ DONE | ID token + optional FCM token |

### 2.2 Backend Token Management
| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.2.1 | Create refresh_tokens table service | ✅ DONE | Prisma schema + CRUD |
| 2.2.2 | Implement token rotation logic | ✅ DONE | Old token revoked on each refresh |
| 2.2.3 | Implement OTP storage | ✅ DONE | SHA-256 hash, 5min TTL, max 3 attempts |

### 2.3 Backend User Module
| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.3.1 | Create users.module.ts | ✅ DONE | UsersModule |
| 2.3.2 | Create users.service.ts | ✅ DONE | findByPhoneNumber, findById, create, update |
| 2.3.3 | Create users.controller.ts | ✅ DONE | Admin user list endpoint |

### 2.4 Common / Infrastructure
| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.4.1 | AllExceptionsFilter | ✅ DONE | Consistent error envelope |
| 2.4.2 | TransformInterceptor | ✅ DONE | { success, data } envelope |
| 2.4.3 | @Public() decorator | ✅ DONE | Skip JWT validation |
| 2.4.4 | @Roles() decorator | ✅ DONE | RBAC metadata |
| 2.4.5 | Global ValidationPipe | ✅ DONE | whitelist, transform, forbidNonWhitelisted |
| 2.4.6 | Swagger configuration | ✅ DONE | /api/docs with Bearer auth |
| 2.4.7 | CORS configuration | ✅ DONE | Configurable origins |
| 2.4.8 | ThrottlerGuard on OTP | ✅ DONE | Rate limiting on send-otp, verify-otp |

### 2.5 Flutter Auth Integration
| # | Task | Status | Notes |
|---|------|--------|-------|
| 2.5.1 | Create api_client.dart | ✅ DONE | Dio setup with interceptors |
| 2.5.2 | Create auth_interceptor.dart | ✅ DONE | JWT attachment + auto-refresh on 401 |
| 2.5.3 | Create error_interceptor.dart | ✅ DONE | Consistent error messages from API |
| 2.5.4 | Create local_storage.dart | ✅ DONE | SharedPreferences wrapper with auth methods |
| 2.5.5 | Create auth_repository.dart | ✅ DONE | sendOtp, verifyOtp, googleAuth, refresh, logout, profile |
| 2.5.6 | Create auth_provider.dart | ✅ DONE | Real API calls, replaces mock entirely |
| 2.5.7 | Create User model (freezed) | ✅ DONE | Freezed + json_serializable with snake_case keys |
| 2.5.8 | Connect auth_screen.dart | ✅ DONE | Async OTP flow, Google/Apple placeholders |
| 2.5.9 | Connect splash_screen.dart | ✅ DONE | Checks local storage for existing auth |
| 2.5.10 | Token refresh on 401 | ✅ DONE | Auto-retry in AuthInterceptor |

---

## Summary

| Category | Done | Total | Progress |
|----------|------|-------|----------|
| Backend Auth Module | 11 | 11 | 100% |
| Token Management | 3 | 3 | 100% |
| User Module | 3 | 3 | 100% |
| Common / Infrastructure | 8 | 8 | 100% |
| Flutter Auth Integration | 10 | 10 | 100% |
| **TOTAL (Backend)** | **25** | **25** | **100%** |
| **TOTAL (Full Phase 2)** | **35** | **35** | **100%** |

---

## API Endpoints Implemented

| Endpoint | Method | Auth | Status |
|----------|--------|------|--------|
| /auth/send-otp | POST | Public | ✅ |
| /auth/verify-otp | POST | Public | ✅ |
| /auth/google | POST | Public | ✅ |
| /auth/refresh | POST | Public | ✅ |
| /auth/logout | POST | JWT | ✅ |
| /auth/me | GET | JWT | ✅ |
| /auth/profile | PATCH | JWT | ✅ |
| /auth/fcm-token | POST | JWT | ✅ |

---

## Test Results (79/79 ✅)

| Category | Tests | Status |
|----------|-------|--------|
| Send OTP | 3 | ✅ |
| OTP Expiry | 2 | ✅ |
| OTP Attempt Limit | 2 | ✅ |
| Invalid OTP Rejection | 2 | ✅ |
| Correct OTP Verification | 8 | ✅ |
| JWT Access Token | 4 | ✅ |
| Refresh Token | 3 | ✅ |
| Refresh Token Rotation | 4 | ✅ |
| Old Refresh Token Rejection | 4 | ✅ |
| Token DB Cleanup | 2 | ✅ |
| Logout | 2 | ✅ |
| Token Rejection After Logout | 1 | ✅ |
| Logout All (Revoke All) | 2 | ✅ |
| Current User / Profile | 6 | ✅ |
| Update Profile | 3 | ✅ |
| Duplicate Email | 1 | ✅ |
| Validation | 6 | ✅ |
| Rate Limiting | 2 | ✅ |
| CORS | 1 | ✅ |
| Swagger | 8 | ✅ |
| RBAC (admin/chef/delivery) | 6 | ✅ |
| FCM Token Registration | 2 | ✅ |
| Google Auth Endpoint | 2 | ✅ |
| **TOTAL** | **79** | **✅ 100%** |

### Bug Fix: Refresh Token Collision (2026-09-07)
**Root cause:** `generateTokens()` produced identical JWT strings for tokens created within the same second (same payload + same secret + same `iat` in seconds = identical hash). This caused `findFirst({ isRevoked: false })` to match the NEW token instead of failing with 401.

**Fix:** Added `jti: crypto.randomUUID()` to every JWT payload in `generateTokens()`, ensuring each token is cryptographically unique regardless of generation timing.

**Changed:** `auth.service.ts` — `generateTokens()` method
