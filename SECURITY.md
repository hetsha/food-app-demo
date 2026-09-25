# SECURITY.md — Security Implementation Guide

This document defines all security measures, authentication strategies, and protection mechanisms for the **Parabdi** backend.

---

## 1. Authentication Architecture

### 1.1 JWT Token Strategy

**Access Token:**
- Algorithm: HS256
- Payload: `{ sub: user_id, role: user_role, iat: issued_at, exp: expires_at }`
- Expiry: 15 minutes
- Stored: Flutter secure storage (flutter_secure_storage)

**Refresh Token:**
- Algorithm: HS256
- Payload: `{ sub: user_id, type: "refresh", iat: issued_at, exp: expires_at }`
- Expiry: 7 days
- Stored: HttpOnly secure cookie (admin) / Flutter secure storage (mobile)
- Server-side: Refresh token ID stored in `refresh_tokens` table for revocation

**Token Refresh Flow:**
```
1. Client sends expired access token + valid refresh token
2. Backend validates refresh token against database
3. Backend issues new access token + new refresh token (rotation)
4. Old refresh token is invalidated
5. If refresh token is invalid/expired → force re-login
```

### 1.2 OTP Authentication Flow

```
1. Customer sends phone_number to POST /auth/send-otp
2. Backend validates phone format (10-digit Indian number, +91 prefix)
3. Backend checks rate limit (max 3 OTP requests per phone per 10 minutes)
4. Backend generates 6-digit OTP, stores hash in Redis/memory with 5-min TTL
5. Backend sends OTP via SMS provider (MSG91 / Twilio)
6. Customer sends phone_number + OTP to POST /auth/verify-otp
7. Backend validates OTP against stored hash
8. Backend creates/finds user, generates JWT tokens
9. Backend returns tokens + user profile
```

**OTP Storage:**
- Never store raw OTP in database
- Store SHA-256 hash of OTP in Redis with key: `otp:{phone_hash}`
- TTL: 300 seconds (5 minutes)
- Max attempts: 3 per OTP before regeneration required

### 1.3 Google OAuth Flow

```
1. Flutter app gets Google ID token via google_sign_in package
2. Flutter sends ID token to POST /auth/google
3. Backend verifies ID token with Google's tokeninfo endpoint
4. Backend extracts: email, name, sub (Google user ID)
5. Backend creates/finds user by email
6. Backend generates JWT tokens
7. Backend returns tokens + user profile
```

### 1.4 Password Policy

- Admin panel: Minimum 8 characters, at least 1 uppercase, 1 number, 1 special character
- Customer: No password (OTP-only authentication)
- Chef: PIN-based login (4-6 digit PIN)

---

## 2. Role-Based Access Control (RBAC)

### 2.1 Role Hierarchy

```
admin > chef > customer > guest
```

### 2.2 Endpoint Access Matrix

| Endpoint Pattern | Guest | Customer | Chef | Admin |
|-----------------|-------|----------|------|-------|
| `GET /api/v1/health` | ✅ | ✅ | ✅ | ✅ |
| `POST /api/v1/auth/send-otp` | ✅ | ✅ | ✅ | ✅ |
| `POST /api/v1/auth/verify-otp` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/categories` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/foods` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/foods/:id` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/banners` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/shorts` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/delivery-slots` | ✅ | ✅ | ✅ | ✅ |
| `POST /api/v1/auth/refresh` | ✅ | ✅ | ✅ | ✅ |
| `GET /api/v1/auth/me` | ❌ | ✅ | ✅ | ✅ |
| `POST /api/v1/auth/logout` | ❌ | ✅ | ✅ | ✅ |
| `POST /api/v1/cart/*` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/orders` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/orders` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/orders/:id` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/orders/:id/cancel` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/orders/:id/reorder` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/payments/create` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/payments/verify` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/subscriptions/plans` | ✅ | ✅ | ✅ | ✅ |
| `POST /api/v1/subscriptions/subscribe` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/subscriptions/my` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/subscriptions/:id/pause` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/subscriptions/:id/resume` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/subscriptions/:id/skip` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/subscriptions/:id/cancel` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/wishlist` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/wishlist/:foodItemId` | ❌ | ✅ | ❌ | ❌ |
| `DELETE /api/v1/wishlist/:foodItemId` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/addresses` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/addresses` | ❌ | ✅ | ❌ | ❌ |
| `PATCH /api/v1/addresses/:id` | ❌ | ✅ | ❌ | ❌ |
| `DELETE /api/v1/addresses/:id` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/notifications` | ❌ | ✅ | ❌ | ❌ |
| `PATCH /api/v1/notifications/:id/read` | ❌ | ✅ | ❌ | ❌ |
| `PATCH /api/v1/notifications/read-all` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/reviews` | ❌ | ✅ | ❌ | ❌ |
| `GET /api/v1/foods/:id/reviews` | ✅ | ✅ | ✅ | ✅ |
| `POST /api/v1/shorts/:id/like` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/shorts/:id/save` | ❌ | ✅ | ❌ | ❌ |
| `POST /api/v1/chef/orders/:id/accept` | ❌ | ❌ | ✅ | ❌ |
| `POST /api/v1/chef/orders/:id/reject` | ❌ | ❌ | ✅ | ❌ |
| `POST /api/v1/chef/orders/:id/start` | ❌ | ❌ | ✅ | ❌ |
| `POST /api/v1/chef/orders/:id/ready` | ❌ | ❌ | ✅ | ❌ |
| `GET /api/v1/chef/orders` | ❌ | ❌ | ✅ | ❌ |
| `GET /api/v1/chef/dashboard` | ❌ | ❌ | ✅ | ❌ |
| `PATCH /api/v1/chef/foods/:id/stock` | ❌ | ❌ | ✅ | ❌ |
| `GET /api/v1/admin/orders` | ❌ | ❌ | ❌ | ✅ |
| `GET /api/v1/admin/users` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/categories` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/categories/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/categories/:id` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/foods` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/foods/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/foods/:id` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/banners` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/banners/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/banners/:id` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/shorts` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/shorts/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/shorts/:id` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/coupons` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/coupons/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/coupons/:id` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/subscriptions/plans` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/subscriptions/plans/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/subscriptions/plans/:id` | ❌ | ❌ | ❌ | ✅ |
| `GET /api/v1/admin/settings` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/settings` | ❌ | ❌ | ❌ | ✅ |
| `GET /api/v1/admin/audit-logs` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/admin/chefs` | ❌ | ❌ | ❌ | ✅ |
| `PATCH /api/v1/admin/chefs/:id` | ❌ | ❌ | ❌ | ✅ |
| `DELETE /api/v1/admin/chefs/:id` | ❌ | ❌ | ❌ | ✅ |
| `GET /api/v1/admin/reports/revenue` | ❌ | ❌ | ❌ | ✅ |
| `GET /api/v1/admin/reports/orders` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/payments/webhook` | ✅* | ❌ | ❌ | ❌ |
| `POST /api/v1/upload/image` | ❌ | ❌ | ❌ | ✅ |
| `POST /api/v1/upload/video` | ❌ | ❌ | ❌ | ✅ |

*\*Payment webhook is IP-whitelisted from Razorpay, not user-authenticated.*

### 2.3 NestJS Guard Implementation

```typescript
// auth.guard.ts
@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeader(request);
    if (!token) throw new UnauthorizedException();

    try {
      const payload = await this.jwtService.verifyAsync(token);
      request.user = payload;
      return true;
    } catch {
      throw new UnauthorizedException();
    }
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }
}

// roles.guard.ts
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.get<string[]>('roles', context.getHandler());
    if (!requiredRoles) return true;

    const request = context.switchToHttp().getRequest();
    const userRole = request.user.role;
    return requiredRoles.includes(userRole);
  }
}

// Usage in controller
@Post('admin/foods')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
async createFood(@Body() dto: CreateFoodDto) { ... }
```

---

## 3. Rate Limiting

### 3.1 Global Rate Limit

- **Window:** 60 seconds (configurable via `THROTTLE_TTL`)
- **Limit:** 100 requests per IP per window (configurable via `THROTTLE_LIMIT`)
- **Library:** `@nestjs/throttler` with in-memory storage (Redis in production)

### 3.2 Endpoint-Specific Rate Limits

| Endpoint | Window | Max Requests | Reason |
|----------|--------|-------------|--------|
| `POST /auth/send-otp` | 10 min | 3 per phone | Prevent OTP spam |
| `POST /auth/verify-otp` | 10 min | 5 per phone | Prevent brute force |
| `POST /auth/refresh` | 15 min | 10 per user | Prevent token theft abuse |
| `POST /payments/webhook` | 1 min | 100 | Razorpay retry tolerance |
| `POST /orders` | 1 min | 5 per user | Prevent order spam |

### 3.3 Implementation

```typescript
// In main.ts
app.useGlobalGuards(new ThrottlerGuard([{ ttl: 60000, limit: 100 }]));

// Per-endpoint override
@Post('send-otp')
@UseGuards(ThrottlerGuard)
@Throttle({ sendOtp: { ttl: 600000, limit: 3 } })
async sendOtp(@Body() dto: SendOtpDto) { ... }
```

---

## 4. CORS Configuration

### 4.1 Allowed Origins

| Environment | Origins |
|-------------|---------|
| Development | `http://localhost:3002` (Admin), `http://localhost:3000` (API docs) |
| Production | `https://admin.parabdikitchen.com` |

### 4.2 NestJS CORS Setup

```typescript
// main.ts
app.enableCors({
  origin: process.env.CORS_ORIGIN?.split(',') || ['http://localhost:3002'],
  methods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
  maxAge: 86400,
});
```

---

## 5. Security Headers (Helmet)

```typescript
// main.ts
import helmet from 'helmet';

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https://res.cloudinary.com"],
      connectSrc: ["'self'", "https://api.parabdikitchen.com"],
    },
  },
  crossOriginEmbedderPolicy: false,
  crossOriginResourcePolicy: { policy: "cross-origin" },
}));
```

**Headers set by Helmet:**
- `X-Content-Type-Options: nosniff`
- `X-Frame-Options: DENY`
- `X-XSS-Protection: 1; mode=block`
- `Strict-Transport-Security: max-age=31536000; includeSubDomains`
- `Referrer-Policy: strict-origin-when-cross-origin`
- `Permissions-Policy: camera=(), microphone=(), geolocation=()`

---

## 6. Input Validation

### 6.1 Library: class-validator + class-transformer

```typescript
// dto/create-order.dto.ts
export class CreateOrderDto {
  @IsUUID()
  address_id: string;

  @IsString()
  @IsNotEmpty()
  delivery_slot: string;

  @IsEnum(['upi', 'card', 'net_banking', 'wallet', 'cod'])
  payment_method: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  special_instructions?: string;

  @IsOptional()
  @IsString()
  coupon_code?: string;
}
```

### 6.2 Global Validation Pipe

```typescript
// main.ts
app.useGlobalPipes(new ValidationPipe({
  whitelist: true,
  forbidNonWhitelisted: true,
  transform: true,
  transformOptions: {
    enableImplicitConversion: true,
  },
}));
```

### 6.3 Phone Number Validation

```typescript
@IsString()
@Matches(/^\+91\d{10}$/, { message: 'Phone number must be 10 digits with +91 prefix' })
phone_number: string;
```

### 6.4 SQL Injection Prevention

- **Prisma ORM** parameterizes all queries automatically
- Never use raw SQL unless absolutely necessary (spatial queries)
- If raw SQL required, always use parameterized queries:
  ```typescript
  await prisma.$queryRaw`SELECT * FROM users WHERE phone_number = ${phone}`;
  ```

---

## 7. Payment Security

### 7.1 Razorpay Integration

**Server-side flow:**
```
1. Flutter creates order via POST /payments/create
2. Backend creates Razorpay order, returns order_id + amount + currency
3. Flutter opens Razorpay SDK with order details
4. Customer completes payment in Razorpay UI
5. Razorpay sends webhook to POST /payments/webhook
6. Backend verifies webhook signature using HMAC SHA256
7. Backend updates order payment_status to 'paid'
8. Backend triggers order status transition to 'confirmed'
```

### 7.2 Webhook Signature Verification

```typescript
// payments.controller.ts
@Post('webhook')
async handleWebhook(
  @Headers('x-razorpay-signature') signature: string,
  @Body() payload: any,
) {
  const isValid = Razorpay.validateWebhookSignature(
    JSON.stringify(payload),
    signature,
    process.env.RAZORPAY_WEBHOOK_SECRET,
  );

  if (!isValid) {
    throw new BadRequestException('Invalid webhook signature');
  }

  // Process payment event...
}
```

### 7.3 Server-Side Payment Verification

```typescript
// After Razorpay SDK confirms payment on Flutter side:
@Post('verify')
async verifyPayment(@Body() dto: VerifyPaymentDto) {
  const expectedSignature = crypto
    .createHmac('sha256', process.env.RAZORPAY_KEY_SECRET)
    .update(`${dto.order_id}|${dto.payment_id}`)
    .digest('hex');

  if (expectedSignature !== dto.signature) {
    throw new BadRequestException('Payment verification failed');
  }

  // Update payment status in database
  // NEVER trust frontend response alone — verify server-side
}
```

### 7.4 Razorpay Test Credentials

| Mode | Key ID | Key Secret |
|------|--------|------------|
| Test | `rzp_test_xxxx` | `xxxx` |
| Live | `rzp_live_xxxx` | `xxxx` |

**Test Card Numbers:**
| Card | Number | CVV | Expiry |
|------|--------|-----|--------|
| Success | 4111 1111 1111 1111 | Any 3 digits | Any future date |
| Failure | 4000 0000 0000 0002 | Any 3 digits | Any future date |

---

## 8. File Upload Security

### 8.1 Allowed MIME Types

| Upload Type | Allowed MIME Types | Max Size |
|------------|-------------------|----------|
| Food Images | `image/jpeg`, `image/png`, `image/webp` | 5 MB |
| Food Videos | `video/mp4`, `video/webm` | 50 MB |
| Banner Images | `image/jpeg`, `image/png`, `image/webp` | 3 MB |
| Short Thumbnails | `image/jpeg`, `image/png`, `image/webp` | 2 MB |
| Short Videos | `video/mp4`, `video/webm` | 100 MB |
| Review Images | `image/jpeg`, `image/png`, `image/webp` | 3 MB |

### 8.2 Upload Flow

```
1. Admin selects file in admin panel
2. Admin panel requests presigned URL from POST /upload/presigned-url
3. Backend generates Cloudinary presigned URL with 5-minute expiry
4. Admin panel uploads directly to Cloudinary using presigned URL
5. Cloudinary returns CDN URL
6. Admin saves CDN URL to database via PATCH /admin/foods/:id
```

### 8.3 Security Rules

- Validate file extension AND MIME type (both)
- Scan uploaded files for malware (production)
- Never store user-uploaded files on the same server as the application
- Use CDN (Cloudinary) for all media delivery
- Generate random filenames (UUID-based) to prevent path traversal
- Strip EXIF data from images (privacy)

---

## 9. Socket.IO Security

### 9.1 Connection Authentication

```typescript
// On Flutter client
final socket = IO.io('https://api.parabdikitchen.com', {
  'auth': {'token': jwtAccessToken},
  'transports': ['websocket'],
});

// On NestJS server
@WebSocketGateway({ cors: true })
export class OrderGateway implements OnGatewayConnection {
  handleConnection(client: Socket) {
    const token = client.handshake.auth.token;
    try {
      const payload = jwt.verify(token, process.env.JWT_SECRET);
      client.data.user = payload;
    } catch {
      client.disconnect();
    }
  }
}
```

### 9.2 Room Join Validation

```typescript
@SubscribeMessage('join_order_room')
async handleJoinRoom(client: Socket, payload: { order_id: string }) {
  const userId = client.data.user.sub;
  const order = await this.ordersService.findById(payload.order_id);

  if (!order) {
    return { error: 'Order not found' };
  }

  // Customers can only join their own order rooms
  if (client.data.user.role === 'customer' && order.userId !== userId) {
    return { error: 'Unauthorized' };
  }

  // Chefs can only join orders assigned to them
  if (client.data.user.role === 'chef' && order.chefId !== userId) {
    return { error: 'Unauthorized' };
  }

  client.join(`order:${payload.order_id}`);
  return { success: true };
}
```

---

## 10. Data Protection

### 10.1 Sensitive Data Handling

| Data | Storage | Access |
|------|---------|--------|
| Phone numbers | Hashed in logs, plain in DB | User + Admin only |
| OTP codes | SHA-256 hash in Redis, TTL 5 min | Never exposed after verification |
| JWT secrets | Environment variables only | Server process only |
| Payment signatures | Environment variables only | Server process only |
| User passwords | bcrypt hash (admin panel only) | Never readable |
| FCM tokens | Plain in DB, encrypted at rest | Server process only |

### 10.2 What NOT to Log

```typescript
// NEVER log:
// - OTP values
// - JWT tokens
// - Payment signatures
// - Google OAuth client secrets
// - Razorpay key secrets
// - User phone numbers (log masked: +91****79765)
// - Full credit card numbers
// - Personal addresses
```

### 10.3 What TO Log

```typescript
// ALWAYS log:
// - Authentication attempts (success/failure)
// - Payment events (created, verified, failed)
// - Order status transitions
// - Admin actions (audit trail)
// - API errors (with sanitized context)
// - Rate limit violations
```

---

## 11. HTTPS Enforcement

### Production Configuration

```typescript
// Redirect HTTP to HTTPS
app.use((req, res, next) => {
  if (req.headers['x-forwarded-proto'] !== 'https' && process.env.NODE_ENV === 'production') {
    return res.redirect(301, `https://${req.headers.host}${req.url}`);
  }
  next();
});
```

### SSL Certificate

- Use Let's Encrypt (free) via Certbot
- Auto-renewal via cron job
- Enforce HSTS with 1-year max-age

---

## 12. Database Security

### 12.1 Connection Security

```ini
# Production DATABASE_URL
DATABASE_URL=postgresql://parabdi_user:strong_password@db-host:5432/parabdi_db?sslmode=require
```

### 12.2 User Privileges

```sql
-- Production: limited privileges
REVOKE ALL ON DATABASE parabdi_db FROM parabdi_user;
GRANT CONNECT ON DATABASE parabdi_db TO parabdi_user;
GRANT USAGE ON SCHEMA public TO parabdi_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO parabdi_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO parabdi_user;

-- Never grant DROP, ALTER, or CREATE in production
```

### 12.3 Backup Security

- Backups encrypted at rest
- Backup access limited to admin IPs
- Backup retention: 30 days minimum
- Test restore monthly
