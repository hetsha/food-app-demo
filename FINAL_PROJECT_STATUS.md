# Parabdi — Orders Authentication Bug Fix Report

**Project Path**: `D:\food-app-demo`  
**Date**: September 21, 2026  
**Physical Device**: CPH2717 (Android 16, API 36)  
**Status**: RESOLVED, VERIFIED & FULLY FUNCTIONAL  

---

## 1. Exact Root Cause

1. **Un-synchronized Provider State Initialization**:
   `ordersProvider` in `orders_provider.dart` is evaluated by Riverpod as soon as `MainNavigationScreen` mounts. During initial app startup (or before OTP verification / when in Guest mode), `LocalStorage.getAccessToken()` was unpopulated or not yet set. Because `ordersProvider` immediately invoked `..loadOrders()`, `_repo.getOrders()` threw a `401 Unauthorized` exception (`Authentication required`).
2. **State Cache Persistence across Auth State Changes**:
   When OTP verification (`verifyOtp`) subsequently succeeded, `authProvider` updated state to `isAuthenticated: true` and saved `access_token` to `LocalStorage`. However, `ordersProvider` was never invalidated or notified to reload. As a result, `ordersProvider` persisted its old cached error state (`errorMessage: DioException [bad response]: null\nError: Authentication required`), rendering the red error card even though valid credentials were saved in storage.
3. **Flawed Retry Logic in AuthInterceptor**:
   In `interceptors.dart`, the 401 token refresh retry mechanism attempted `await Dio().fetch(err.requestOptions)`. This constructed a raw, unconfigured `Dio` instance that did not attach `ApiConstants.baseUrl`, nor did it inject `options.headers['Authorization'] = 'Bearer $newToken'`, causing any 401 retry requests to fail.

---

## 2. Exact Files Changed

- `lib/features/orders/presentation/providers/orders_provider.dart`:
  - Added token validation before dispatching HTTP request in `loadOrders()`.
  - Added `clearError: true` flag handling to reset error states cleanly when re-fetching.
  - Implemented clean `_extractError()` handling to format Dio errors without stack trace prefixes.
- `lib/features/orders/presentation/orders_tab.dart`:
  - Added `initState()` post-frame callback to reload orders whenever the tab mounts.
  - Added `ref.listen(authProvider, ...)` to automatically trigger `loadOrders()` as soon as authentication state becomes `true`.
- `lib/core/network/interceptors.dart`:
  - Added `import 'api_client.dart';`.
  - Fixed 401 token refresh retry mechanism in `AuthInterceptor.onError()` to attach `Authorization: Bearer <newToken>` and retry using `ApiClient.instance.fetch()`.

---

## 3. Token-Storage Result

- **OTP Verification (`POST /auth/verify-otp`)**:
  - Response: `{ "success": true, "data": { "accessToken": "eyJhbGci...", "refreshToken": "eyJhbGci..." } }`
  - Storage Action: `LocalStorage.setAccessToken()` and `LocalStorage.setRefreshToken()` save the JWT strings under keys `access_token` and `refresh_token`.
  - Result: **TOKEN PRESENT & VALIDATED**

---

## 4. Authorization-Header Result

- **`AuthInterceptor.onRequest`**:
  - Code:
    ```dart
    final token = LocalStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    ```
  - Header Attached: `Authorization: Bearer eyJhbGci...`
  - Result: **HEADER PRESENT & CORRECTLY FORMATTED**

---

## 5. Orders API Status

- **Status Before Fix**: `401 Unauthorized` (`Error: Authentication required`) due to un-synchronized provider state caching initial unauthenticated error.
- **Status After Fix**: `200 OK` (`{ "success": true, "data": [] }`) returning user orders list cleanly.

---

## 6. Fresh-Login & Logout Verification Result

1. **OTP Verification**: Enter `+919876543210` → Receive OTP → Verify OTP → Token written to `LocalStorage` → `authProvider` triggers `ordersProvider.loadOrders()` → Orders API returns `200 OK`.
2. **Profile Data**: Profile tab retrieves authenticated user payload (`phoneNumber: "+919876543210"`, `role: "customer"`).
3. **Logout**: User taps Logout → `LocalStorage.clearAuth()` purges tokens → `ordersProvider` resets state cleanly.
4. **Re-Login**: Re-authenticate with OTP → Fresh JWT token written to storage → Orders API returns `200 OK` without any error card.

---

## 7. CPH2717 Physical Device Verification

- **App Status**: Rebuilt and launched on physical device `CPH2717` (`9PEQ9PNB6XCABAO7`).
- **My Orders Tab**: Displays "My Orders" app bar with "Ongoing" and "History" category toggles, showing the empty state ("No active orders / Your ongoing orders will appear here") without any "Authentication required" error cards.
- **Flutter Analyze**: `flutter analyze` passed with **0 errors**.
- **Flutter Test**: `flutter test` passed (`00:00 +1: All tests passed!`).
