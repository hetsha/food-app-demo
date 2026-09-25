# ENVIRONMENT_SETUP.md — Development Environment Guide

This document provides step-by-step instructions for setting up the complete **Parabdi** development environment across all three codebases: Backend (NestJS), Mobile App (Flutter), and Admin Panel (Next.js).

---

## 1. Prerequisites

### Required Software

| Software | Version | Purpose | Install |
|----------|---------|---------|---------|
| **Node.js** | 18.x or 20.x LTS | Backend & Admin runtime | https://nodejs.org |
| **npm** | 9.x+ (comes with Node) | Package manager | Bundled with Node |
| **Flutter SDK** | 3.19+ (stable channel) | Mobile app | https://flutter.dev/docs/get-started/install |
| **Dart SDK** | 3.3+ (bundled with Flutter) | Dart compiler | Bundled with Flutter |
| **PostgreSQL** | 15+ | Database | https://www.postgresql.org/download |
| **Git** | 2.40+ | Version control | https://git-scm.com |
| **VS Code** | Latest | IDE (recommended) | https://code.visualstudio.com |

### Recommended VS Code Extensions

- Flutter (Dart Code)
- ESLint
- Prettier
- Prisma (syntax highlighting)
- PostgreSQL (database viewer)
- Error Lens

---

## 2. Clone & Open Repository

```bash
git clone <repository-url> parabdi-app
cd parabdi-app
```

Open in VS Code:
```bash
code .
```

---

## 3. Database Setup (PostgreSQL)

### 3.1 Create Database

```sql
-- Connect to PostgreSQL as superuser
psql -U postgres

-- Create dedicated database user
CREATE USER parabdi_user WITH PASSWORD 'parabdi_secret_dev';

-- Create the database
CREATE DATABASE parabdi_db OWNER parabdi_user;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE parabdi_db TO parabdi_user;

-- Connect to the new database
\c parabdi_db

-- Enable UUID extension (required for gen_random_uuid())
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Exit
\q
```

### 3.2 Verify Connection

```bash
psql -U parabdi_user -d parabdi_db -h localhost
```

If prompted for password, enter: `parabdi_secret_dev`

---

## 4. Backend Setup (NestJS + Prisma)

### 4.1 Initialize NestJS Project

```bash
cd backend

# If backend is empty, initialize NestJS:
npx @nestjs/cli new . --package-manager npm --skip-git --strict

# When prompted, select:
# - Package Manager: npm
# - TypeScript: Yes
```

### 4.2 Install Dependencies

```bash
# Core dependencies
npm install @nestjs/config @nestjs/jwt @nestjs/passport passport passport-jwt @nestjs/websockets @nestjs/platform-socket.io socket.io class-validator class-transformer @nestjs/throttler @nestjs/serve-static helmet

# Database (Prisma)
npm install prisma @prisma/client

# File uploads
npm install multer @types/multer

# HTTP client (for external APIs like Google Places, Razorpay)
npm install axios

# Payment gateway
npm install razorpay

# Push notifications
npm install firebase-admin

# Password hashing (if needed for admin panel)
npm install bcrypt @types/bcrypt

# Development dependencies
npm install -D @types/passport-jwt @types/multer @nestjs/testing
```

### 4.3 Initialize Prisma

```bash
npx prisma init

# This creates:
# - prisma/schema.prisma
# - .env (with DATABASE_URL)
```

### 4.4 Configure Environment Variables

Create `backend/.env`:

```ini
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v1

# Database
DATABASE_URL=postgresql://parabdi_user:parabdi_secret_dev@localhost:5432/parabdi_db

# JWT Authentication
JWT_SECRET=dev-jwt-secret-change-in-production-2026
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d

# Google Places API (for address search on backend)
GOOGLE_PLACES_API_KEY=your-google-places-api-key

# Razorpay (Payment Gateway)
RAZORPAY_KEY_ID=rzp_test_xxxxxxxxxxxx
RAZORPAY_KEY_SECRET=xxxxxxxxxxxxxxxxxxxxxxxx

# Firebase Cloud Messaging (Push Notifications)
FIREBASE_PROJECT_ID=parabdi-firebase-project
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@parabdi-firebase-project.iam.gserviceaccount.com
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nMIIEvgIBAAANBg...\n-----END PRIVATE KEY-----\n"

# Google OAuth (Customer Login)
GOOGLE_CLIENT_ID=xxxxx.apps.googleusercontent.com

# Cloudinary (File Storage - Images/Videos)
CLOUDINARY_CLOUD_NAME=parabdi
CLOUDINARY_API_KEY=xxxxxxxxxxxxxxx
CLOUDINARY_API_SECRET=xxxxxxxxxxxxxxx

# CORS
CORS_ORIGIN=http://localhost:3001,http://localhost:3002

# Rate Limiting
THROTTLE_TTL=60000
THROTTLE_LIMIT=100
```

### 4.5 Configure Prisma Schema

Edit `prisma/schema.prisma`:

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Start defining models here — see DATABASE.md for complete schema
// Example:
// model User {
//   id          String   @id @default(uuid()) @db.Uuid
//   phoneNumber String   @unique @map("phone_number") @db.VarChar(15)
//   fullName    String?  @map("full_name") @db.VarChar(100)
//   email       String?  @unique @db.VarChar(255)
//   role        Role     @default(customer)
//   walletBalance Decimal @default(0) @map("wallet_balance") @db.Decimal(10, 2)
//   isBlocked   Boolean  @default(false) @map("is_blocked")
//   createdAt   DateTime @default(now()) @map("created_at")
//   updatedAt   DateTime @updatedAt @map("updated_at")
// }
//
// enum Role {
//   customer
//   admin
//   chef
//   delivery
// }
```

### 4.6 Run Migrations

```bash
# Create initial migration
npx prisma migrate dev --name init

# Generate Prisma client
npx prisma generate

# Seed database (optional)
npx prisma db seed
```

### 4.7 Start Backend Server

```bash
# Development mode with hot-reload
npm run dev

# Server starts at: http://localhost:3000
# API base URL: http://localhost:3000/api/v1
```

### 4.8 Verify Backend

```bash
# Health check
curl http://localhost:3000/api/v1/health

# Should return:
# { "status": "ok", "timestamp": "2026-..." }
```

---

## 5. Flutter Mobile App Setup

### 5.1 Verify Flutter Installation

```bash
flutter doctor

# Ensure all checks pass:
# [✓] Flutter
# [✓] Dart
# [✓] Android toolchain (or Xcode for iOS)
# [✓] VS Code / IntelliJ
```

### 5.2 Install Dependencies

```bash
# From project root (where pubspec.yaml is located)
cd ..
flutter pub get
```

### 5.3 Configure API Base URL

Create/edit `lib/core/constants/api_constants.dart`:

```dart
class ApiConstants {
  static const String devBaseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator
  static const String iosDevBaseUrl = 'http://localhost:3000/api/v1'; // iOS simulator
  static const String prodBaseUrl = 'https://api.parabdikitchen.com/api/v1';

  static String get baseUrl {
    // Platform detection or use environment config
    return devBaseUrl;
  }
}
```

> **Note:** `10.0.2.2` is the Android emulator's alias for the host machine's `localhost`.

### 5.4 Run Code Generation (if using freezed/json_serializable)

```bash
# Install build_runner if not already in dev_dependencies
# (it should already be in pubspec.yaml)

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# For watch mode during development:
dart run build_runner watch --delete-conflicting-outputs
```

### 5.5 Run the App

```bash
# List available devices
flutter devices

# Run on Android emulator
flutter run -d android

# Run on iOS simulator (macOS only)
flutter run -d ios

# Run on Chrome (web)
flutter run -d chrome

# Run on connected device
flutter run
```

### 5.6 Flutter Analysis

```bash
# Check for lint issues
flutter analyze

# Expected: No issues found!
```

---

## 6. Admin Panel Setup (Next.js)

### 6.1 Initialize Next.js Project

```bash
cd admin

# If admin is empty, create Next.js app:
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --use-npm

# When prompted:
# - TypeScript: Yes
# - ESLint: Yes
# - Tailwind CSS: Yes
# - src/ directory: Yes
# - App Router: Yes
# - Import alias: @/*
```

### 6.2 Install Dependencies

```bash
# UI Component Library
npm install @radix-ui/react-dialog @radix-ui/react-dropdown-menu @radix-ui/react-select @radix-ui/react-tabs @radix-ui/react-toast @radix-ui/react-avatar @radix-ui/react-label @radix-ui/react-separator @radix-ui/react-slot @radix-ui/react-switch @radix-ui/react-tooltip

# State Management & Data Fetching
npm install @tanstack/react-query axios

# Charts & Visualization
npm install recharts

# Forms
npm install react-hook-form @hookform/resolvers zod

# Date handling
npm install date-fns

# Notifications
npm install sonner

# Table
npm install @tanstack/react-table

# Icons
npm install lucide-react
```

### 6.3 Configure Environment Variables

Create `admin/.env.local`:

```ini
# Backend API
NEXT_PUBLIC_API_URL=http://localhost:3000/api/v1

# Authentication
NEXT_PUBLIC_APP_URL=http://localhost:3002

# Google OAuth (for admin login)
NEXT_PUBLIC_GOOGLE_CLIENT_ID=xxxxx.apps.googleusercontent.com
```

### 6.4 Start Admin Panel

```bash
npm run dev

# Admin panel starts at: http://localhost:3002
```

### 6.5 Verify Admin Panel

Open `http://localhost:3002` in your browser. You should see the Next.js welcome page (will be replaced with admin login).

---

## 7. Docker Setup (Optional — for PostgreSQL)

If you prefer Docker over a local PostgreSQL installation:

### 7.1 Create `docker-compose.yml` at project root:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: parabdi_db
    environment:
      POSTGRES_USER: parabdi_user
      POSTGRES_PASSWORD: parabdi_secret_dev
      POSTGRES_DB: parabdi_db
    ports:
      - '5432:5432'
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U parabdi_user -d parabdi_db']
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

### 7.2 Start Database with Docker

```bash
# Start PostgreSQL container
docker-compose up -d postgres

# Check status
docker-compose ps

# View logs
docker-compose logs postgres

# Stop
docker-compose down

# Stop and remove data
docker-compose down -v
```

---

## 8. Connecting Everything Together

### 8.1 Architecture Overview

```
┌─────────────────┐         ┌──────────────────┐         ┌────────────┐
│  Flutter App    │────────►│  NestJS Backend  │────────►│ PostgreSQL │
│  (port 5000)    │  HTTP   │  (port 3000)     │  Prisma │ (port 5432)│
└─────────────────┘         └──────────────────┘         └────────────┘
                                    ▲
┌─────────────────┐         │
│  Admin Panel    │─────────┘
│  (port 3002)    │  HTTP
└─────────────────┘
```

### 8.2 Start All Services (Manual)

Terminal 1 — Database:
```bash
# If using Docker:
docker-compose up -d postgres

# If using local PostgreSQL, ensure it's running:
# Windows: net start postgresql-x64-15
# macOS: brew services start postgresql
# Linux: sudo systemctl start postgresql
```

Terminal 2 — Backend:
```bash
cd backend
npm run dev
# Runs on http://localhost:3000
```

Terminal 3 — Admin Panel:
```bash
cd admin
npm run dev
# Runs on http://localhost:3002
```

Terminal 4 — Flutter App:
```bash
flutter run
# Runs on connected device/emulator
```

### 8.3 API Connection Verification

1. Backend health check:
   ```bash
   curl http://localhost:3000/api/v1/health
   ```

2. Admin panel → Backend:
   Open `http://localhost:3002` and check network tab for API calls to `localhost:3000`

3. Flutter → Backend:
   The app should display the splash screen and attempt to check auth status via API

---

## 9. Common Issues & Troubleshooting

### Flutter

| Issue | Solution |
|-------|----------|
| `flutter pub get` fails | Run `flutter clean` then `flutter pub get` |
| Android emulator can't reach backend | Use `10.0.2.2` instead of `localhost` |
| iOS can't reach backend | Use `localhost` or your machine's local IP |
| `build_runner` fails | Run `dart run build_runner build --delete-conflicting-outputs` |
| Hot reload not working | Restart with `flutter run` (hot restart) |

### Backend

| Issue | Solution |
|-------|----------|
| `prisma migrate dev` fails | Check `DATABASE_URL` in `.env` and PostgreSQL is running |
| Port 3000 already in use | Change `PORT` in `.env` or kill the process using the port |
| JWT errors | Ensure `JWT_SECRET` is set in `.env` |
| Razorpay errors | Verify test credentials in `.env`

### Database

| Issue | Solution |
|-------|----------|
| Connection refused | Ensure PostgreSQL is running: `pg_isready -h localhost` |
| Authentication failed | Check username/password in `DATABASE_URL` |
| `uuid-ossp` extension missing | Run `CREATE EXTENSION IF NOT EXISTS "uuid-ossp";` |

---

## 10. Development Workflow

### 10.1 Daily Development Flow

```bash
# 1. Pull latest changes
git pull origin main

# 2. Start database
docker-compose up -d postgres

# 3. Run backend migrations (if schema changed)
cd backend && npx prisma migrate dev

# 4. Start backend
npm run dev

# 5. Start admin panel
cd ../admin && npm run dev

# 6. Run Flutter app
cd .. && flutter run

# 7. If models changed, run code generation
dart run build_runner build --delete-conflicting-outputs
```

### 10.2 Code Generation Commands

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on file changes)
dart run build_runner watch --delete-conflicting-outputs

# Clean generated files
dart run build_runner clean
```

### 10.3 Database Commands

```bash
# Create new migration
cd backend
npx prisma migrate dev --name <migration-name>

# Reset database (WARNING: deletes all data)
npx prisma migrate reset

# Push schema without migration (development only)
npx prisma db push

# Open Prisma Studio (visual database browser)
npx prisma studio

# Seed database
npx prisma db seed
```

---

## 11. Environment Variables Reference

### Backend `.env` Variables

| Variable | Required | Description | Default |
|----------|----------|-------------|---------|
| `NODE_ENV` | Yes | Environment mode | `development` |
| `PORT` | Yes | Server port | `3000` |
| `API_PREFIX` | Yes | API route prefix | `api/v1` |
| `DATABASE_URL` | Yes | PostgreSQL connection string | — |
| `JWT_SECRET` | Yes | JWT signing secret | — |
| `JWT_ACCESS_EXPIRY` | Yes | Access token lifetime | `15m` |
| `JWT_REFRESH_EXPIRY` | Yes | Refresh token lifetime | `7d` |
| `GOOGLE_PLACES_API_KEY` | Yes | Google Places API key | — |
| `RAZORPAY_KEY_ID` | Yes | Razorpay test/live key | — |
| `RAZORPAY_KEY_SECRET` | Yes | Razorpay secret | — |
| `FIREBASE_PROJECT_ID` | Yes | Firebase project ID | — |
| `FIREBASE_CLIENT_EMAIL` | Yes | Firebase service account email | — |
| `FIREBASE_PRIVATE_KEY` | Yes | Firebase private key (escaped newlines) | — |
| `GOOGLE_CLIENT_ID` | Optional | Google OAuth client ID | — |
| `CLOUDINARY_CLOUD_NAME` | Yes | Cloudinary cloud name | — |
| `CLOUDINARY_API_KEY` | Yes | Cloudinary API key | — |
| `CLOUDINARY_API_SECRET` | Yes | Cloudinary API secret | — |
| `CORS_ORIGIN` | Yes | Allowed CORS origins (comma-separated) | `http://localhost:3002` |
| `THROTTLE_TTL` | Yes | Rate limit window (ms) | `60000` |
| `THROTTLE_LIMIT` | Yes | Max requests per window | `100` |

### Flutter Configuration

| File | Variable | Description |
|------|----------|-------------|
| `lib/core/constants/api_constants.dart` | `baseUrl` | Backend API base URL |
| `android/app/build.gradle.kts` | `applicationId` | App package name |
| `ios/Runner/Info.plist` | `CFBundleDisplayName` | App display name |

### Admin Panel `.env.local` Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `NEXT_PUBLIC_API_URL` | Yes | Backend API base URL |
| `NEXT_PUBLIC_APP_URL` | Yes | Admin panel base URL |
| `NEXT_PUBLIC_GOOGLE_CLIENT_ID` | Optional | Google OAuth for admin login |
