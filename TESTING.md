# TESTING.md — Test Strategy & Guidelines

This document defines the testing strategy, structure, and conventions for all **Parabdi** codebases.

---

## 1. Testing Philosophy

- **Target Coverage:** 80%+ for business logic, 60%+ overall
- **Test Pyramid:** Unit tests (base) → Widget tests (middle) → Integration tests (top)
- **CI Requirement:** All tests must pass before merge to `main`
- **Test-First:** Write tests for critical flows (payment, order lifecycle, auth) before implementation

---

## 2. Backend Testing (NestJS + Prisma)

### 2.1 Directory Structure

```
backend/
├── src/
│   └── modules/
│       └── auth/
│           ├── auth.controller.ts
│           ├── auth.service.ts
│           └── auth.module.ts
└── test/
    ├── unit/
    │   └── auth/
    │       ├── auth.service.spec.ts
    │       └── auth.controller.spec.ts
    ├── integration/
    │   ├── auth.integration.spec.ts
    │   └── order.integration.spec.ts
    ├── e2e/
    │   └── app.e2e-spec.ts
    └── helpers/
        ├── test-database.ts
        ├── mock-data.ts
        └── test-app.ts
```

### 2.2 Unit Tests

**What to test per layer:**

| Layer | What to Test | Example |
|-------|-------------|---------|
| **Service** | Business logic, calculations, state transitions | Order total calculation, coupon validation, OTP generation |
| **Guard** | Role checking, token validation | RBAC guard blocks customer from admin endpoints |
| **Pipe** | Input validation, transformation | Phone number format validation, UUID format |
| **Helper/Util** | Pure functions, calculations | Price calculation with GST, discount application |

**Example Unit Test:**

```typescript
// auth.service.spec.ts
describe('AuthService', () => {
  let service: AuthService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [AuthService, { provide: PrismaService, useValue: mockPrisma }],
    }).compile();
    service = module.get(AuthService);
  });

  describe('generateOtp', () => {
    it('should generate a 6-digit OTP', () => {
      const otp = service.generateOtp();
      expect(otp).toHaveLength(6);
      expect(parseInt(otp)).toBeGreaterThan(99999);
    });
  });

  describe('validatePhone', () => {
    it('should accept valid Indian phone number', () => {
      expect(service.validatePhone('+919825079765')).toBe(true);
    });

    it('should reject non-Indian phone number', () => {
      expect(service.validatePhone('+15551234567')).toBe(false);
    });

    it('should reject phone with less than 10 digits', () => {
      expect(service.validatePhone('+91982507976')).toBe(false);
    });
  });
});
```

### 2.3 Integration Tests

**What to test:**
- Complete request/response cycle (controller → service → database)
- Database operations (create, read, update, delete)
- Authentication + authorization flows
- Payment webhook processing
- Order status transitions

**Test Database Setup:**

```typescript
// helpers/test-database.ts
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient({
  datasources: { db: { url: process.env.TEST_DATABASE_URL } },
});

beforeAll(async () => {
  await prisma.$executeRaw`TRUNCATE TABLE users CASCADE`;
  // Seed test data
});

afterAll(async () => {
  await prisma.$disconnect();
});

export { prisma };
```

**Example Integration Test:**

```typescript
// auth.integration.spec.ts
describe('Auth (Integration)', () => {
  it('should send OTP and verify successfully', async () => {
    // 1. Send OTP
    const sendResponse = await request(app.getHttpServer())
      .post('/api/v1/auth/send-otp')
      .send({ phone_number: '+919825079765' })
      .expect(201);

    // 2. Get OTP from test cache (not real SMS in tests)
    const otp = testCache.get(`otp:+919825079765`);

    // 3. Verify OTP
    const verifyResponse = await request(app.getHttpServer())
      .post('/api/v1/auth/verify-otp')
      .send({ phone_number: '+919825079765', otp })
      .expect(201);

    expect(verifyResponse.body.data).toHaveProperty('access_token');
    expect(verifyResponse.body.data.user.role).toBe('customer');
  });
});
```

### 2.4 E2E Tests

**Critical Order Lifecycle Test:**

```typescript
// e2e/order-lifecycle.e2e-spec.ts
describe('Order Lifecycle E2E', () => {
  let customerToken: string;
  let chefToken: string;

  it('should complete full order flow', async () => {
    // 1. Customer login
    // 2. Add items to cart
    // 3. Place order
    // 4. Verify payment
    // 5. Chef accepts order
    // 6. Chef starts preparing
    // 7. Chef marks ready
    // 8. Verify order status is 'ready'
  });
});
```

### 2.5 Run Backend Tests

```bash
cd backend

# Run all unit tests
npm run test

# Run with coverage
npm run test:cov

# Run integration tests
npm run test:integration

# Run E2E tests
npm run test:e2e

# Run specific test file
npm run test -- --testFile=auth.service.spec.ts
```

---

## 3. Flutter Testing (Mobile App)

### 3.1 Directory Structure

```
test/
├── unit/
│   ├── models/
│   │   ├── food_item_test.dart
│   │   ├── cart_test.dart
│   │   └── order_test.dart
│   ├── services/
│   │   ├── api_service_test.dart
│   │   └── auth_service_test.dart
│   └── providers/
│       ├── auth_provider_test.dart
│       └── cart_provider_test.dart
├── widget/
│   ├── splash_screen_test.dart
│   ├── home_tab_test.dart
│   ├── cart_screen_test.dart
│   └── meal_detail_screen_test.dart
├── integration/
│   ├── auth_flow_test.dart
│   ├── order_flow_test.dart
│   └── payment_flow_test.dart
└── helpers/
    ├── mock_data.dart
    ├── test_providers.dart
    └── pump_app.dart
```

### 3.2 Unit Tests

**What to test:**

| Layer | What to Test |
|-------|-------------|
| **Models** | `fromJson`/`toJson` serialization, computed properties |
| **Providers** | State transitions, API calls (mocked), business logic |
| **Services** | HTTP client, token management, error handling |
| **Helpers** | Formatters, validators, utility functions |

**Example Unit Test:**

```dart
// test/unit/models/food_item_test.dart
void main() {
  group('FoodItem', () {
    test('should deserialize from JSON correctly', () {
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'category_id': '770e8400-e29b-41d4-a716-446655440002',
        'name': 'Gujarati Thali',
        'price': 250.00,
        'image_urls': ['https://example.com/thali.jpg'],
        'is_veg': true,
        'is_jain_available': true,
        'rating': 4.75,
        'reviews_count': 128,
        'created_at': '2026-08-21T10:00:00.000Z',
      };

      final foodItem = FoodItem.fromJson(json);

      expect(foodItem.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(foodItem.name, 'Gujarati Thali');
      expect(foodItem.price, 250.00);
      expect(foodItem.isVeg, true);
      expect(foodItem.imageUrls, hasLength(1));
    });

    test('should serialize to JSON correctly', () {
      final foodItem = FoodItem(
        id: 'test-id',
        categoryId: 'cat-id',
        name: 'Test Food',
        price: 100.00,
        createdAt: DateTime(2026, 8, 21),
      );

      final json = foodItem.toJson();

      expect(json['name'], 'Test Food');
      expect(json['price'], 100.00);
    });
  });
}
```

### 3.3 Provider Tests

```dart
// test/unit/providers/cart_provider_test.dart
void main() {
  group('CartNotifier', () {
    late CartNotifier notifier;

    setUp(() {
      notifier = CartNotifier();
    });

    test('should add item to cart', () {
      final item = CartItem(
        id: 'item-1',
        foodItem: mockFoodItem,
        quantity: 1,
        unitPrice: 250.00,
        totalPrice: 250.00,
        createdAt: DateTime.now(),
      );

      notifier.addItem(item);

      expect(notifier.state.items, hasLength(1));
      expect(notifier.state.subtotal, 250.00);
    });

    test('should increase quantity for duplicate items', () {
      final item = CartItem(
        id: 'item-1',
        foodItem: mockFoodItem,
        quantity: 1,
        unitPrice: 250.00,
        totalPrice: 250.00,
        createdAt: DateTime.now(),
      );

      notifier.addItem(item);
      notifier.addItem(item);

      expect(notifier.state.items, hasLength(1));
      expect(notifier.state.items.first.quantity, 2);
      expect(notifier.state.subtotal, 500.00);
    });

    test('should remove item from cart', () {
      final item = CartItem(
        id: 'item-1',
        foodItem: mockFoodItem,
        quantity: 1,
        unitPrice: 250.00,
        totalPrice: 250.00,
        createdAt: DateTime.now(),
      );

      notifier.addItem(item);
      notifier.removeItem('item-1');

      expect(notifier.state.items, isEmpty);
      expect(notifier.state.subtotal, 0.00);
    });
  });
}
```

### 3.4 Widget Tests

```dart
// test/widget/cart_screen_test.dart
void main() {
  testWidgets('CartScreen shows empty state when cart is empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartProvider.overrideWith((ref) => CartNotifier()..state = CartState()),
        ],
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });

  testWidgets('CartScreen displays cart items', (tester) async {
    final cartState = CartState(
      items: [
        CartItem(
          id: 'item-1',
          foodItem: mockFoodItem,
          quantity: 2,
          unitPrice: 250.00,
          totalPrice: 500.00,
          createdAt: DateTime.now(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartProvider.overrideWith((ref) => CartNotifier()..state = cartState),
        ],
        child: const MaterialApp(home: CartScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Gujarati Thali'), findsOneWidget);
    expect(find.text('₹500.00'), findsOneWidget);
  });
}
```

### 3.5 Run Flutter Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/unit/models/food_item_test.dart

# Run tests in a specific directory
flutter test test/unit/

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

---

## 4. Admin Panel Testing (Next.js)

### 4.1 Directory Structure

```
admin/
├── __tests__/
│   ├── components/
│   │   ├── food-table.test.tsx
│   │   └── order-grid.test.tsx
│   ├── pages/
│   │   ├── dashboard.test.tsx
│   │   └── login.test.tsx
│   └── helpers/
│       └── test-utils.tsx
```

### 4.2 Component Tests

```tsx
// __tests__/components/food-table.test.tsx
import { render, screen, waitFor } from '@testing-library/react';
import { FoodTable } from '@/components/food-table';
import { mockFoods } from '../helpers/mock-data';

describe('FoodTable', () => {
  it('renders food items in table', async () => {
    render(<FoodTable foods={mockFoods} />);

    expect(screen.getByText('Gujarati Thali')).toBeInTheDocument();
    expect(screen.getByText('₹250.00')).toBeInTheDocument();
  });

  it('displays empty state when no foods', () => {
    render(<FoodTable foods={[]} />);

    expect(screen.getByText('No food items found')).toBeInTheDocument();
  });
});
```

### 4.3 Run Admin Tests

```bash
cd admin
npm run test
```

---

## 5. Test Data Management

### 5.1 Mock Data

- **Backend:** Use factories for User, Order, FoodItem, etc.
- **Flutter:** Use `mock_constants.dart` with preset test data
- **Admin:** Use JSON fixtures in `__tests__/helpers/fixtures/`

### 5.2 Database Seeding for Tests

```typescript
// test/helpers/seed.ts
export async function seedTestData() {
  // Create test user
  await prisma.user.create({
    data: {
      id: 'test-user-001',
      phoneNumber: '+919825079765',
      fullName: 'Test Customer',
      role: 'customer',
    },
  });

  // Create test category
  await prisma.category.create({
    data: {
      id: 'test-cat-001',
      name: 'Test Category',
      icon: '🍛',
    },
  });

  // Create test food items
  // Create test addresses
  // etc.
}
```

---

## 6. CI/CD Test Pipeline

### 6.1 GitHub Actions Workflow

```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  backend-tests:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test_user
          POSTGRES_PASSWORD: test_pass
          POSTGRES_DB: test_db
        ports: ['5432:5432']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: cd backend && npm ci
      - run: cd backend && npx prisma migrate deploy
      - run: cd backend && npm run test:cov

  flutter-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19'
      - run: flutter pub get
      - run: flutter test --coverage

  admin-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: cd admin && npm ci
      - run: cd admin && npm run test
```

---

## 7. Test Checklist Per Feature

Before marking a feature as complete, verify:

| Feature | Required Tests |
|---------|---------------|
| Authentication | OTP send/verify, Google OAuth, JWT refresh, role guards |
| Cart | Add/remove/update items, coupon application, price calculation |
| Orders | Order creation, status transitions, cancellation, reorder |
| Payments | Razorpay create, verify, webhook, failure handling |
| Subscriptions | Subscribe, pause, resume, skip, cancel |
| Menu | List, search, filter, food detail with customizations |
| Admin CRUD | Create/update/delete categories, foods, banners, shorts |
