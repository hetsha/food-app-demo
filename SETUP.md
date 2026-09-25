# Parabdi - Full Stack Setup Guide

## Prerequisites

Install these before starting:

| Tool | Version | Download |
|------|---------|----------|
| Node.js | v20.15.0+ | https://nodejs.org |
| Flutter | 3.44.8+ | https://flutter.dev |
| Docker | Latest | https://docker.com |
| Git | Latest | https://git-scm.com |

Verify installations:
```bash
node --version        # v20.15.0 or higher
flutter --version     # 3.44.8 or higher
docker --version      # Latest
```

---

## Step 1: Clone & Install Dependencies

```bash
# Clone the repo
git clone <repo-url> food-app-demo
cd food-app-demo

# Install backend dependencies
cd backend
npm install

# Install admin panel dependencies
cd ../admin
npm install

# Install Flutter dependencies
cd ..
flutter pub get
```

---

## Step 2: Start PostgreSQL Database

```bash
# Start PostgreSQL via Docker
docker-compose up -d postgres

# Verify it's running
docker ps

# Check logs
docker logs parabdi-postgres-1
```

The database will be available at `localhost:5432` with:
- **User:** `postgres`
- **Password:** `postgres`
- **Database:** `parabdi`

---

## Step 3: Setup Backend

```bash
cd backend

# Generate Prisma client
npx prisma generate

# Run database migrations
npx prisma migrate dev

# Seed the database with admin user and sample data
node seed-admin.js
node seed-data.js

# Start the backend server
npm run start:dev
```

Backend runs at `http://localhost:3000`

### Verify Backend
```bash
# Test API is working
curl http://localhost:3000/api/v1/banners

# Login as admin
curl -X POST http://localhost:3000/api/v1/auth/admin-login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@parabdi.com","password":"admin123"}'
```

---

## Step 4: Setup Admin Panel

```bash
cd admin

# Create environment file
echo "NEXT_PUBLIC_API_URL=http://localhost:3000/api/v1" > .env.local

# Start the admin panel
npm run dev
```

Admin panel runs at `http://localhost:3001`

### Login Credentials
- **Email:** admin@parabdi.com
- **Password:** admin123

---

## Step 5: Setup Flutter App

### For Physical Device (Recommended)
Update `lib/core/constants/api_constants.dart`:
```dart
// Change this to your machine's local IP
static const String baseUrl = 'http://YOUR_IP_ADDRESS:3000/api/v1';
```

Find your IP:
```bash
# Windows
ipconfig

# Mac/Linux
ifconfig
```

### For Android Emulator
```dart
// Use this for emulator
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

### Run the App
```bash
# List connected devices
flutter devices

# Run on your device
flutter run -d <DEVICE_ID>

# Example: Run on Android device
flutter run -d CP2577
```

---

## Step 6: Generate Code (After Model Changes)

If you modify any Freezed models or providers:

```bash
# Generate freezed code
dart run build_runner build --delete-conflicting-outputs

# Or watch for changes
dart run build_runner watch --delete-conflicting-outputs
```

---

## Quick Start (All Services)

Open 3 separate terminals:

### Terminal 1: Database
```bash
cd food-app-demo
docker-compose up -d postgres
```

### Terminal 2: Backend
```bash
cd food-app-demo/backend
npm run start:dev
```

### Terminal 3: Admin Panel
```bash
cd food-app-demo/admin
npm run dev
```

### Terminal 4: Flutter App
```bash
cd food-app-demo
flutter run -d <DEVICE_ID>
```

---

## Common Commands

### Database
```bash
# View database
docker exec -it parabdi-postgres-1 psql -U postgres -d parabdi

# Reset database
npx prisma migrate reset

# Create new migration
npx prisma migrate dev --name <migration_name>

# Regenerate Prisma client
npx prisma generate
```

### Backend
```bash
# Development
npm run start:dev

# Build for production
npm run build
npm run start:prod

# Run tests
npm run test
```

### Admin Panel
```bash
# Development
npm run dev

# Build for production
npm run build

# Lint
npm run lint
```

### Flutter
```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk

# Clean build
flutter clean
flutter pub get
flutter run
```

---

## Troubleshooting

### Database Connection Issues
```bash
# Check if PostgreSQL is running
docker ps

# Restart database
docker-compose down
docker-compose up -d postgres
```

### Backend Won't Start
```bash
# Regenerate Prisma client
cd backend
npx prisma generate

# Check for port conflicts
netstat -ano | findstr :3000

# Kill process using port 3000
taskkill /F /PID <PID>
```

### Flutter Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Admin Panel Won't Connect
```bash
# Verify backend is running
curl http://localhost:3000/api/v1/banners

# Check .env.local exists
cat admin/.env.local
```

---

## API Endpoints

| Service | URL |
|---------|-----|
| Backend API | http://localhost:3000/api/v1 |
| Admin Panel | http://localhost:3001 |
| Flutter App | Connects to backend API |

### Key Endpoints
- `POST /auth/send-otp` - Send OTP to phone
- `POST /auth/verify-otp` - Verify OTP and login
- `POST /auth/admin-login` - Admin login
- `GET /categories` - List categories
- `GET /foods` - List food items
- `GET /banners` - List banners
- `POST /addresses` - Create address
- `POST /orders` - Place order

---

## Project Structure

```
food-app-demo/
├── backend/                 # NestJS API
│   ├── src/
│   │   ├── modules/        # Feature modules
│   │   ├── common/         # Shared utilities
│   │   └── config/         # Configuration
│   ├── prisma/             # Database schema
│   └── seed-data.js        # Sample data
│
├── admin/                   # Next.js Admin Panel
│   └── src/
│       ├── app/            # Pages (App Router)
│       ├── components/     # UI components
│       └── lib/            # Utilities
│
├── lib/                     # Flutter Customer App
│   └── features/           # Feature modules
│       ├── authentication/
│       ├── home/
│       ├── menu/
│       ├── cart/
│       ├── checkout/
│       ├── orders/
│       └── profile/
│
└── docker-compose.yml      # Docker services
```

---

## Environment Variables

### Backend (.env)
```env
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/parabdi?schema=public"
JWT_SECRET="your-jwt-secret"
JWT_EXPIRES_IN="15m"
JWT_REFRESH_SECRET="your-refresh-secret"
JWT_REFRESH_EXPIRES_IN="7d"
PORT=3000
NODE_ENV=development
```

### Admin Panel (.env.local)
```env
NEXT_PUBLIC_API_URL=http://localhost:3000/api/v1
```

### Flutter (lib/core/constants/api_constants.dart)
```dart
static const String baseUrl = 'http://YOUR_IP:3000/api/v1';
```

---

## Development Tips

1. **Hot Reload**: Press `r` in Flutter terminal for hot reload
2. **Backend Auto-restart**: NestJS watches for file changes automatically
3. **Admin Hot Reload**: Next.js supports hot reload by default
4. **Database GUI**: Use pgAdmin or DBeaver to view database
5. **API Testing**: Use Postman or curl to test endpoints

---

## Support

If you encounter issues:
1. Check this guide first
2. Verify all services are running (`docker ps`, check ports)
3. Check logs for errors
4. Ensure environment variables are set correctly
