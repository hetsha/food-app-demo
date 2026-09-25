# AGENTS.md — Development & Architect Guidelines

This document defines coding standards, architecture patterns, technology decisions, and implementation guidelines for the **Parabdi** codebase.

---

## 1. Firm Technology Decisions

| Component | Decision | NOT |
|-----------|----------|-----|
| Backend Framework | **NestJS** (Node.js + TypeScript) | Not Express |
| ORM | **Prisma** (with PostgreSQL) | Not TypeORM, not raw pg |
| Mobile Framework | **Flutter** (Dart) | Not React Native |
| State Management | **Riverpod** (with Freezed models) | Not Provider, not BLoC |
| Routing (Flutter) | **go_router** | Not auto_route |
| Admin Panel | **Next.js** (App Router) + shadcn/ui | Not Pages Router |
| Database | **PostgreSQL 15** | Not MongoDB, not MySQL |
| Realtime | **Socket.IO** | Not plain WebSockets |
| Payments | **Razorpay** | Not Stripe |
| File Storage | **Cloudinary** | Not AWS S3 directly |
| Notifications | **Firebase Cloud Messaging** | Not OneSignal |

---

## 2. Directory Structure

### 2.1 Monorepo Layout

```
parabdi-app/
├── backend/                    # NestJS API server
├── admin/                      # Next.js admin panel
├── lib/                        # Flutter customer app (root)
├── docker-compose.yml          # PostgreSQL + Redis
├── ENVIRONMENT_SETUP.md        # Dev setup guide
├── DATA_MODELS.md              # Shared entity specs
├── SECURITY.md                 # Security implementation
├── TESTING.md                  # Test strategy
├── DEPLOYMENT.md               # Deployment guide
└── ADMIN_PANEL_ARCHITECTURE.md # Admin panel specs
```

### 2.2 Flutter Feature-First Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── storage_keys.dart
│   ├── routes/
│   │   └── app_router.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── app_colors.dart
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── interceptors.dart
│   │   └── endpoints.dart
│   ├── storage/
│   │   └── local_storage.dart
│   └── utils/
│       ├── formatters.dart
│       └── validators.dart
└── features/
    ├── authentication/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── user.dart       # Freezed model
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── services/
    │   │       └── auth_api_service.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── auth_provider.dart
    │       ├── screens/
    │       │   ├── splash_screen.dart
    │       │   ├── onboarding_screen.dart
    │       │   └── auth_screen.dart
    │       └── widgets/
    │           └── otp_input.dart
    ├── home/
    │   ├── data/
    │   │   ├── models/
    │   │   └── repositories/
    │   └── presentation/
    │       ├── providers/
    │       ├── screens/
    │       └── widgets/
    ├── menu/
    │   ├── data/
    │   ├── presentation/
    ├── cart/
    │   ├── data/
    │   ├── presentation/
    ├── checkout/
    │   ├── data/
    │   ├── presentation/
    ├── orders/
    │   ├── data/
    │   ├── presentation/
    ├── subscription/
    │   ├── data/
    │   ├── presentation/
    ├── profile/
    │   ├── data/
    │   ├── presentation/
    ├── wishlist/
    │   ├── data/
    │   ├── presentation/
    ├── shorts/
    │   ├── data/
    │   ├── presentation/
    └── address/
        ├── data/
        └── presentation/
```

### 2.3 Backend NestJS Module Structure

```
backend/src/
├── modules/
│   ├── auth/
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── dto/
│   │   │   ├── send-otp.dto.ts
│   │   │   └── verify-otp.dto.ts
│   │   ├── guards/
│   │   │   ├── jwt-auth.guard.ts
│   │   │   └── roles.guard.ts
│   │   └── strategies/
│   │       └── jwt.strategy.ts
│   ├── users/
│   ├── addresses/
│   ├── categories/
│   ├── foods/
│   ├── cart/
│   ├── orders/
│   ├── payments/
│   ├── subscriptions/
│   ├── coupons/
│   ├── reviews/
│   ├── wishlist/
│   ├── shorts/
│   ├── banners/
│   ├── notifications/
│   ├── chefs/
│   ├── admin/
│   └── health/
├── common/
│   ├── filters/
│   │   └── all-exceptions.filter.ts
│   ├── interceptors/
│   │   └── transform.interceptor.ts
│   └── pipes/
├── config/
│   ├── database.config.ts
│   └── app.config.ts
├── guards/
├── main.ts
└── app.module.ts
```

---

## 3. Flutter Architecture Patterns

### 3.1 Freezed Model Pattern

```dart
// lib/features/authentication/data/models/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    required String role,
    @JsonKey(name: 'wallet_balance') @Default(0.0) double walletBalance,
    @JsonKey(name: 'is_blocked') @Default(false) bool isBlocked,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Run code generation:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3.2 Repository Pattern

```dart
// lib/features/authentication/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await _dio.post('/auth/send-otp', data: {
      'phone_number': phoneNumber,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    final response = await _dio.post('/auth/verify-otp', data: {
      'phone_number': phoneNumber,
      'otp': otp,
    });
    return response.data;
  }

  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }
}
```

### 3.3 Riverpod Provider Pattern

```dart
// lib/features/authentication/presentation/providers/auth_provider.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// State class
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    @Default(false) bool isVerifyingOtp,
    String? phoneNumber,
    String? errorMessage,
    User? user,
  }) = _AuthState;
}

// Notifier
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState();

  Future<void> sendOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.sendOtp(phoneNumber);
      state = state.copyWith(isLoading: false, isVerifyingOtp: true, phoneNumber: phoneNumber);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      final data = await repo.verifyOtp(state.phoneNumber!, otp);
      // Store tokens, update state...
      state = state.copyWith(isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}
```

### 3.4 Dio HTTP Client Setup

```dart
// lib/core/network/api_client.dart
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'interceptors.dart';

class ApiClient {
  static Dio create() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
```

```dart
// lib/core/network/interceptors.dart
import 'package:dio/dio.dart';
import '../storage/local_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = LocalStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try refresh token
      final refreshed = await _refreshToken();
      if (refreshed) {
        // Retry original request
        final retryResponse = await Dio().fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      }
    }
    handler.next(err);
  }
}
```

---

## 4. Local Storage Strategy

```dart
// lib/core/storage/local_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth tokens
  static String? getAccessToken() => _prefs.getString('access_token');
  static Future<void> setAccessToken(String token) => _prefs.setString('access_token', token);

  static String? getRefreshToken() => _prefs.getString('refresh_token');
  static Future<void> setRefreshToken(String token) => _prefs.setString('refresh_token', token);

  // User data
  static String? getUserId() => _prefs.getString('user_id');
  static Future<void> setUserId(String id) => _prefs.setString('user_id', id);

  // App settings
  static bool get hasSeenOnboarding => _prefs.getBool('onboarding_complete') ?? false;
  static Future<void> setOnboardingComplete() => _prefs.setBool('onboarding_complete', true);

  static bool get isDarkMode => _prefs.getBool('dark_mode') ?? false;
  static Future<void> setDarkMode(bool value) => _prefs.setBool('dark_mode', value);

  // Clear all (logout)
  static Future<void> clearAll() async {
    await _prefs.clear();
  }
}
```

**Storage key allocation:**
| Key | Type | Purpose |
|-----|------|---------|
| `access_token` | String | JWT access token |
| `refresh_token` | String | JWT refresh token |
| `user_id` | String | Current user ID |
| `onboarding_complete` | bool | Has seen onboarding |
| `dark_mode` | bool | Theme preference |
| `last_order_address_id` | String | Last used address |

---

## 5. Error Handling Pattern

```dart
// Success/Failure union type
sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(String message, {int? statusCode}) = Failure<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final String message;
  final int? statusCode;
  const Failure(this.message, {this.statusCode});
}

// Usage in repository
Future<Result<User>> login(String phone, String otp) async {
  try {
    final response = await _dio.post('/auth/verify-otp', data: {
      'phone_number': phone,
      'otp': otp,
    });
    final user = User.fromJson(response.data['data']['user']);
    return Result.success(user);
  } on DioException catch (e) {
    final message = e.response?.data['error']?['message'] ?? 'Network error';
    final statusCode = e.response?.statusCode;
    return Result.failure(message, statusCode: statusCode);
  }
}

// Usage in provider
Future<void> verifyOtp(String otp) async {
  state = state.copyWith(isLoading: true, errorMessage: null);
  final result = await _repo.login(state.phoneNumber!, otp);
  switch (result) {
    case Success(:final data):
      state = state.copyWith(isAuthenticated: true, user: data, isLoading: false);
    case Failure(:final message):
      state = state.copyWith(isLoading: false, errorMessage: message);
  }
}
```

---

## 6. ScreenUtil Usage Rules

**Initialization (already in main.dart):**
```dart
ScreenUtilInit(
  designSize: const Size(390, 844), // iPhone 13/14
  builder: (context, child) => ...
)
```

**When to use:**
| Value Type | Extension | Example |
|-----------|-----------|---------|
| Font sizes | `.sp` | `TextStyle(fontSize: 16.sp)` |
| Widths | `.w` | `SizedBox(width: 24.w)` |
| Heights | `.h` | `SizedBox(height: 16.h)` |
| Border radius | `.r` | `BorderRadius.circular(12.r)` |

**What NOT to convert:**
- Icon sizes (use `.sp` only if icon is part of text)
- Animation durations
- Opacity values
- Padding/margin that uses `AppSpacing` constants (already defined)

---

## 7. Backend Error Response Format

```typescript
// Success envelope
{
  "success": true,
  "data": { ... },
  "message": "Optional message"
}

// Error envelope
{
  "success": false,
  "error": {
    "message": "Human readable error",
    "code": "ERROR_CODE",
    "details": []
  }
}
```

---

## 8. Naming Conventions

| Layer | Convention | Example |
|-------|-----------|---------|
| Dart files | `snake_case` | `auth_repository.dart` |
| Dart classes | `PascalCase` | `AuthRepository` |
| Dart methods | `camelCase` | `sendOtp()` |
| Dart variables | `camelCase` | `phoneNumber` |
| TypeScript files | `kebab-case` or `camelCase` | `auth.service.ts` |
| TypeScript classes | `PascalCase` | `AuthService` |
| TypeScript methods | `camelCase` | `sendOtp()` |
| Database tables | `lower_snake_case` (plural) | `food_items` |
| Database columns | `lower_snake_case` | `phone_number` |
| API JSON keys | `snake_case` | `phone_number` |
| Prisma fields | `camelCase` | `phoneNumber` |

---

## 9. UI/UX Rules

- **Fonts:** Google Fonts `Inter` (primary) or `Outfit`. Never system sans-serif.
- **Colors:** Warm amber/green HSL palette. See `AppColors` in `app_theme.dart`.
- **Animations:** Use `flutter_animate` for micro-interactions (button scale, list fade-in).
- **Empty States:** Custom illustrations with warm descriptive text (not blank screens).
- **Loading States:** Shimmer skeletons or branded spinners.
- **Error States:** Human-readable messages with retry buttons.

---

## 10. Testing Conventions

| Test Type | Location | Framework |
|-----------|----------|-----------|
| Flutter Unit | `test/unit/` | `flutter_test` |
| Flutter Widget | `test/widget/` | `flutter_test` |
| Flutter Integration | `test/integration/` | `integration_test` |
| Backend Unit | `test/unit/` | `@nestjs/testing` |
| Backend E2E | `test/e2e/` | `supertest` |

**Run commands:**
```bash
# Flutter
flutter test
flutter test --coverage

# Backend
npm run test
npm run test:cov
npm run test:e2e
```

---

## 11. Git Workflow

- **Main branch:** `main` (production-ready)
- **Development branch:** `develop`
- **Feature branches:** `feature/feature-name`
- **Bug fixes:** `fix/bug-description`
- **Commit messages:** Present tense, concise ("Add auth provider", not "Added auth provider")
- **PR required** before merging to `main`
- **All tests must pass** before merge
