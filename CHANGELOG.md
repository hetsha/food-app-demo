# CHANGELOG.md - Version History

All notable changes to **Parabdi** will be documented in this file.

---

## [1.2.0] - 2026-09-03

### Added
* **ENVIRONMENT_SETUP.md** — Step-by-step dev environment setup for Backend (NestJS + Prisma), Flutter, and Admin panel (Next.js). Includes Docker Compose for PostgreSQL, .env templates, and troubleshooting guide.
* **DATA_MODELS.md** — Shared entity specifications mapping all 24 database tables ↔ JSON API responses ↔ Dart freezed models with complete fromJson/toJson code. Covers User, Address, Category, FoodItem, CustomizationGroup/Item, Cart/CartItem, Order/OrderItem, Subscription, Coupon, Review, Banner, Short, Wishlist, Notification, WalletTransaction, LoyaltyPoint, FcmToken, OrderStatusHistory, DeliverySlot, Setting, AdminAuditLog, RefreshToken.
* **SECURITY.md** — Complete security implementation guide: JWT strategy (15min access, 7d refresh), OTP flow with SHA-256 hashing, RBAC guard matrix for all endpoints, rate limiting (global + per-endpoint), CORS config, Helmet security headers, input validation (class-validator), Razorpay webhook signature verification, Socket.IO authentication, file upload security rules, database security.
* **TESTING.md** — Test strategy for all codebases: Backend unit/integration/E2E tests with Prisma test database, Flutter unit/widget/integration tests with Riverpod mocking, Admin panel component tests. CI/CD pipeline config (GitHub Actions), coverage targets (80% business logic).
* **DEPLOYMENT.md** — Production deployment guide: Docker multi-stage builds for backend + admin, Nginx reverse proxy with rate limiting + WebSocket support, VPS setup (Ubuntu + Docker), SSL via Let's Encrypt, automated database backups (daily cron), Sentry monitoring, rollback procedure, scaling considerations.
* **ADMIN_PANEL_ARCHITECTURE.md** — Complete admin panel tech architecture: Next.js App Router + shadcn/ui + TanStack Query, directory structure, NextAuth.js authentication, API client with interceptors, page-by-page specifications for all 17 admin pages (Dashboard, Orders, Foods, Categories, Shorts, Banners, Customers, Chefs, Subscriptions, Coupons, Reviews, Payments, Reports, Notifications, Settings, Audit Logs).
* **Location selection specification** — GPS-based location detection (geolocator in Flutter) + backend Google Places API (server-side). No Google Places SDK in Flutter app.
* **Delivery module scope decision** — Rider/Delivery module explicitly OUT OF SCOPE for MVP. Order lifecycle ends at `ready` status.
* **Default values for all client decisions** — Business defaults (delivery radius 5km, min order ₹100, GST 5%, platform fee ₹2, free delivery above ₹200), OTP defaults (6 digits, 5min expiry, max 3 requests), subscription defaults (9 AM cutoff).
* **Edge case business rules** — 30+ documented edge cases for cart/checkout, orders, subscriptions, coupons, reviews, and addresses.

### Changed
* **API_DOCUMENTATION.md** — Complete rewrite with full JSON request/response schemas for all 50+ endpoints. Added: pagination format, error code catalog (20+ codes with HTTP status), RBAC endpoint access matrix, Socket.IO authentication, missing endpoints (wishlist CRUD, notification history, settings, chef stock toggle, subscription pause/resume/skip, delivery slots, wallet transactions, file upload presigned URLs, admin reports/export, audit logs).
* **DATABASE.md** — Added 8 missing tables: `wishlist`, `food_short_likes`, `coupon_usage`, `fcm_tokens`, `notifications`, `order_status_history`, `delivery_slots`, `refresh_tokens`. Added `deleted_at` soft-delete column to `food_items`. Added missing indexes on `food_items.name`, `orders.created_at`, `reviews.food_item_id`, `user_subscriptions.user_id`, `wallet_transactions.user_id`. Added JSONB schema definitions. Added seed data for default settings and delivery slots.
* **SRS.md** — Added Section 4A with default values for all client decisions. Added delivery module scope decision. Added location selection specification (GPS + backend Google Places). Added Section 8A with 30+ edge case business rules.
* **AGENTS.md** — Rewritten with firm technology decisions (NestJS + Prisma, not ambiguous). Added Flutter feature-first directory structure, Freezed model code examples, Repository pattern, Riverpod provider pattern, Dio HTTP client setup with interceptors, Local storage strategy (SharedPreferences), Error handling pattern (Result type), ScreenUtil usage rules, Naming conventions, Testing conventions, Git workflow.
* **UI_FLOW.md** — Corrected bottom nav to 5 tabs (Home, Menu, Shorts, Orders, Profile). Added 10+ missing screens: Location selection, Address CRUD, Shorts feed, Search results, Wishlist, Rating/Review, Subscription detail, Notifications, Edit profile. Added Chef Panel screen specifications. Added Admin Panel reference. Fixed router tree to match actual implementation.
* **FEATURES.md** — Added P0/P1/P2 priority tags to all features. Added API endpoint mapping for each feature. Added missing features: Address CRUD (P0), Push notifications (P1), Guest mode (P0), Offline/cache behavior (P2). Enhanced acceptance criteria with specific timeout values and validation rules.
* **TASKS.md** — Fixed Phase 1 false completion status (backend/admin directories are empty). Added 15+ missing tasks (NestJS init, Prisma setup, Dio setup, local storage, build_runner, .env files, Docker, admin scaffolding). Added estimated hours per task. Added dependency graph between phases. Added total estimated hours (~463h). Fixed phase count (13 phases, not 11).
* **README.md** — Updated document architecture section to reference all 6 new documents.

---

## [1.1.0] - 2026-08-21

### Changed
* Restructured and updated all core project specification documents (`SRS.md`, `DATABASE.md`, `API_DOCUMENTATION.md`, `UI_FLOW.md`, `FEATURES.md`, `TASKS.md`, and `README.md`) to align with the comprehensive 89-section development specification flow for the pure-vegetarian Gujarati cloud kitchen platform.

---

## [1.0.0] - 2026-08-05

### Added
* Created project directory structure guidelines (`AGENTS.md`).
* Documented Software Requirement Specifications (`SRS.md`) covering Gujarati pure-veg cloud kitchen features, subscriptions, user roles, and payment rules.
* Designed PostgreSQL relational schema (`DATABASE.md`) including definitions for users, orders, customization, subscriptions, reviews, and tracking.
* Designed backend RESTful API specifications and WebSocket (Socket.IO) real-time events (`API_DOCUMENTATION.md`).
* Mapped customer app screen navigation, chef boards, rider dashboards, and admin views (`UI_FLOW.md`).
* Outlined functional user stories, acceptance criteria, and checklist items (`FEATURES.md`).
* Compiled project backlog milestones (`TASKS.md`).
* Structured folder layout scaffolding (`backend/` and `admin/`).

### Changed
* Refactored Flutter mobile application naming configuration from `ambo` to `parabdi` across configuration files:
  * Modified `pubspec.yaml` project metadata.
  * Renamed app class references to `ParabdiApp` and app title to `Parabdi Cloud Kitchen` in `lib/main.dart`.
  * Updated Android `namespace` and `applicationId` to `com.parabdi.parabdi` in `android/app/build.gradle.kts`.
  * Moved `MainActivity.kt` to the updated package package directory (`com/parabdi/parabdi`) and cleaned up the old structure.
  * Updated iOS app name and package namespace (`com.parabdi.parabdi`) in `Info.plist` and `Runner.xcodeproj`.
  * Updated macOS package configuration target outputs in `Runner.xcodeproj`.
  * Rewrote `test/widget_test.dart` to assert on the new brand name.
  * Updated web manifest names and index page templates.
  * Replaced hardcoded text assets and constant titles inside tab bars and wallets from Ambo to Parabdi.
