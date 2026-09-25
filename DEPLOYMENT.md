# DEPLOYMENT.md — Deployment & Infrastructure Guide

This document covers Docker configuration, VPS setup, CI/CD pipeline, monitoring, and production deployment for **Parabdi**.

---

## 1. Docker Configuration

### 1.1 Project Docker Structure

```
parabdi-app/
├── docker-compose.yml          # Production orchestration
├── docker-compose.dev.yml      # Development environment
├── backend/
│   ├── Dockerfile              # Backend image
│   └── .dockerignore
├── admin/
│   ├── Dockerfile              # Admin panel image
│   └── .dockerignore
└── nginx/
    └── nginx.conf              # Reverse proxy config
```

### 1.2 Backend Dockerfile

```dockerfile
# backend/Dockerfile
# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci
RUN npx prisma generate

COPY . .

RUN npm run build

# Stage 2: Production
FROM node:20-alpine AS runner

WORKDIR /app

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001

COPY --from=builder --chown=nestjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nestjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nestjs:nodejs /app/package.json ./package.json
COPY --from=builder --chown=nestjs:nodejs /app/prisma ./prisma

USER nestjs

EXPOSE 3000

CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]
```

### 1.3 Admin Panel Dockerfile

```dockerfile
# admin/Dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ARG NEXT_PUBLIC_API_URL
ARG NEXT_PUBLIC_APP_URL

RUN npm run build

# Production
FROM node:20-alpine AS runner

WORKDIR /app

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

USER nextjs

EXPOSE 3002

ENV PORT=3002
ENV HOSTNAME="0.0.0.0"

CMD ["node", "server.js"]
```

### 1.4 Nginx Configuration

```nginx
# nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    upstream backend {
        server backend:3000;
    }

    upstream admin {
        server admin:3002;
    }

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=api:10m rate=100r/m;
    limit_req_zone $binary_remote_addr zone=auth:10m rate=10r/m;

    server {
        listen 80;
        server_name api.parabdikitchen.com;

        # Redirect HTTP to HTTPS
        return 301 https://$server_name$request_uri;
    }

    server {
        listen 443 ssl http2;
        server_name api.parabdikitchen.com;

        ssl_certificate /etc/letsencrypt/live/api.parabdikitchen.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/api.parabdikitchen.com/privkey.pem;

        # Security headers
        add_header X-Frame-Options "DENY" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

        # API routes
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        # Auth routes (stricter rate limit)
        location /api/v1/auth/ {
            limit_req zone=auth burst=5 nodelay;
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        # WebSocket (Socket.IO)
        location /socket.io/ {
            proxy_pass http://backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        # Payment webhooks (no rate limit)
        location /api/v1/payments/webhook {
            proxy_pass http://backend;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }

    # Admin panel
    server {
        listen 443 ssl http2;
        server_name admin.parabdikitchen.com;

        ssl_certificate /etc/letsencrypt/live/admin.parabdikitchen.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/admin.parabdikitchen.com/privkey.pem;

        location / {
            proxy_pass http://admin;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

### 1.5 Docker Compose (Production)

```yaml
# docker-compose.yml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: parabdi_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backup:/backup
    ports:
      - '127.0.0.1:5432:5432'
    healthcheck:
      test: ['CMD-SHELL', 'pg_isready -U ${DB_USER} -d ${DB_NAME}']
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: parabdi_redis
    restart: unless-stopped
    volumes:
      - redis_data:/data

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: parabdi_backend
    restart: unless-stopped
    env_file:
      - ./backend/.env
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_started
    expose:
      - '3000'

  admin:
    build:
      context: ./admin
      dockerfile: Dockerfile
    container_name: parabdi_admin
    restart: unless-stopped
    env_file:
      - ./admin/.env.local
    expose:
      - '3002'

  nginx:
    image: nginx:alpine
    container_name: parabdi_nginx
    restart: unless-stopped
    ports:
      - '80:80'
      - '443:443'
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./certbot/conf:/etc/letsencrypt:ro
      - ./certbot/www:/var/www/certbot:ro
    depends_on:
      - backend
      - admin

  certbot:
    image: certbot/certbot
    container_name: parabdi_certbot
    volumes:
      - ./certbot/conf:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew; sleep 12h & wait $${!}; done;'"

volumes:
  postgres_data:
  redis_data:
```

---

## 2. VPS Setup

### 2.1 Recommended Provider & Specs

| Provider | Instance | Specs | Monthly Cost |
|----------|----------|-------|-------------|
| DigitalOcean | Basic Droplet | 2 vCPU, 4GB RAM, 80GB SSD | ~$24 |
| AWS Lightsail | Basic | 2 vCPU, 4GB RAM, 80GB SSD | ~$20 |
| Hetzner | CPX21 | 3 vCPU, 4GB RAM, 80GB SSD | ~$11 |

**OS:** Ubuntu 22.04 LTS

### 2.2 Initial Server Setup

```bash
# SSH into server
ssh root@your-server-ip

# Update system
apt update && apt upgrade -y

# Create non-root user
adduser parabdi
usermod -aG sudo parabdi

# Setup firewall
ufw allow OpenSSH
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable

# Switch to parabdi user
su - parabdi
```

### 2.3 Install Docker

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker parabdi

# Install Docker Compose
sudo apt install docker-compose -y

# Verify
docker --version
docker-compose --version
```

### 2.4 Deploy Application

```bash
# Clone repository
git clone <repo-url> /home/parabdi/parabdi-app
cd /home/parabdi/parabdi-app

# Create production .env files
cp backend/.env.example backend/.env
cp admin/.env.example admin/.env.local

# Edit with production values
nano backend/.env
nano admin/.env.local

# Build and start
docker-compose up -d --build

# Verify all containers are running
docker-compose ps
docker-compose logs -f
```

---

## 3. CI/CD Pipeline (GitHub Actions)

### 3.1 Workflow Files

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: cd backend && npm ci && npm run test
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19'
      - run: flutter test

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Deploy to VPS
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SERVER_SSH_KEY }}
          script: |
            cd /home/parabdi/parabdi-app
            git pull origin main
            docker-compose down
            docker-compose up -d --build
            docker-compose exec backend npx prisma migrate deploy
```

### 3.2 Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `SERVER_HOST` | VPS IP address or domain |
| `SERVER_USER` | SSH username (parabdi) |
| `SERVER_SSH_KEY` | Private SSH key for deployment |
| `DB_USER` | Production database username |
| `DB_PASSWORD` | Production database password |

---

## 4. SSL Certificate (Let's Encrypt)

```bash
# Install Certbot
sudo apt install certbot -y

# Obtain certificate (stop nginx first)
docker-compose stop nginx

sudo certbot certonly --standalone \
  -d api.parabdikitchen.com \
  -d admin.parabdikitchen.com \
  --non-interactive \
  --agree-tos \
  --email admin@parabdikitchen.com

# Copy certs to nginx directory
sudo cp -r /etc/letsencrypt /home/parabdi/parabdi-app/certbot/conf

# Start nginx
docker-compose start nginx

# Auto-renewal (via certbot container in docker-compose)
```

---

## 5. Database Backup

### 5.1 Automated Daily Backup

```bash
# Create backup script
cat > /home/parabdi/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/parabdi/parabdi-app/backup"
DATE=$(date +%Y_%m_%d_%H_%M)
docker exec parabdi_db pg_dump -U parabdi_user parabdi_db | gzip > "$BACKUP_DIR/parabdi_$DATE.sql.gz"

# Keep only last 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete
EOF

chmod +x /home/parabdi/backup.sh

# Add to crontab (daily at 3 AM)
crontab -e
0 3 * * * /home/parabdi/backup.sh
```

### 5.2 Restore from Backup

```bash
# Stop backend
docker-compose stop backend

# Restore database
gunzip -c backup/parabdi_2026_08_21_03_00.sql.gz | docker exec -i parabdi_db psql -U parabdi_user -d parabdi_db

# Restart backend
docker-compose start backend
```

---

## 6. Monitoring & Logging

### 6.1 Application Monitoring

**Sentry (Error Tracking):**

```typescript
// backend/src/main.ts
import * as Sentry from '@sentry/node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
  tracesSampleRate: 1.0,
});
```

### 6.2 Log Management

```typescript
// backend/src/common/filters/all-exceptions.filter.ts
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();

    console.error(`[${new Date().toISOString()}]`, exception);

    // Send to Sentry in production
    if (process.env.NODE_ENV === 'production') {
      Sentry.captureException(exception);
    }

    response.status(500).json({
      success: false,
      error: {
        message: 'Internal server error',
        code: 'INTERNAL_SERVER_ERROR',
      },
    });
  }
}
```

### 6.3 Health Check Endpoint

```typescript
// backend/src/modules/health/health.controller.ts
@Controller('health')
export class HealthController {
  @Get()
  async check() {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: await this.checkDatabase(),
    };
  }
}
```

---

## 7. Domain & DNS Configuration

### 7.1 DNS Records

| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | api.parabdikitchen.com | YOUR_SERVER_IP | 300 |
| A | admin.parabdikitchen.com | YOUR_SERVER_IP | 300 |
| CNAME | www.parabdikitchen.com | parabdikitchen.com | 300 |

### 7.2 SSL Verification

```bash
# Check SSL certificate
curl -I https://api.parabdikitchen.com/health
# Should show HTTP/2 200 with SSL headers
```

---

## 8. Environment Promotion

### 8.1 Environment Flow

```
Development (local) → Staging (VPS dev) → Production (VPS prod)
```

### 8.2 Environment Differences

| Feature | Development | Staging | Production |
|---------|-------------|---------|------------|
| Database | Local PostgreSQL | VPS PostgreSQL | VPS PostgreSQL (separate) |
| Razorpay | Test mode | Test mode | Live mode |
| SMS Provider | Mock | Test SMS | Real SMS |
| Logging | Console | File + Sentry | Sentry + structured logs |
| Backups | None | Daily | Daily + offsite |
| SSL | None | Let's Encrypt | Let's Encrypt |
| Rate Limiting | Disabled | Enabled | Enabled (stricter) |

---

## 9. Rollback Procedure

```bash
# 1. Identify the last working commit
git log --oneline -10

# 2. Checkout the working version
git checkout <commit-hash>

# 3. Rebuild and restart
docker-compose down
docker-compose up -d --build

# 4. If database migration needs rollback
docker-compose exec backend npx prisma migrate reset

# 5. Verify
docker-compose logs -f backend
curl https://api.parabdikitchen.com/health
```

---

## 10. Scaling Considerations

### Current Architecture (Single Server)

```
Nginx → Backend (1 instance) → PostgreSQL (1 instance)
```

### Future Scaling (Multi-Server)

```
Load Balancer → Backend (N instances) → PostgreSQL (Primary + Replica)
                                     → Redis (Session store)
                                     → Cloudinary (Media CDN)
```

**When to scale:**
- Server response time > 500ms consistently
- Database CPU > 80% sustained
- Memory usage > 85%
- More than 100 concurrent users
