# Daily Dev Commands

## Start Everything (4 terminals)

### Terminal 1 — Database
```bash
cd D:\food-app-demo
docker-compose up -d postgres
```

### Terminal 2 — Backend
```bash
cd D:\food-app-demo\backend
npm run start:dev
```

### Terminal 3 — Admin Panel
```bash
cd D:\food-app-demo\admin
npm run dev
```

### Terminal 4 — Flutter App
```bash
cd D:\food-app-demo
flutter run -d CPH2717
```

---

## After Changing Flutter Models (freezed/provider)
```bash
cd D:\food-app-demo
dart run build_runner build --delete-conflicting-outputs
flutter run -d CPH2717
```

## After Changing Backend Code
```bash
cd D:\food-app-demo\backend
npm run build
# then restart: Ctrl+C and npm run start:dev
```

## After Changing Prisma Schema
```bash
cd D:\food-app-demo\backend
npx prisma migrate dev
npx prisma generate
# then restart backend
```

## Rebuild Flutter APK (install on device)
```bash
cd D:\food-app-demo
flutter install -d CPH2717 --debug
```

## Check What's Running
```bash
netstat -ano | findstr ":3000"   # backend
netstat -ano | findstr ":3001"   # admin
netstat -ano | findstr ":5432"   # database
```

## Kill a Process on a Port
```bash
netstat -ano | findstr ":3000"   # find PID
taskkill /F /PID <PID>           # kill it
```

## Quick Flutter Restart (no reinstall)
```bash
# In flutter run terminal, press:
r   # hot reload
R   # hot restart
```

## Database GUI (optional)
```
Host: localhost
Port: 5432
User: postgres
Pass: postgres
DB: parabdi
```
