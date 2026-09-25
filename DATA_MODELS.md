# DATA_MODELS.md — Shared Entity Specifications

This document defines the canonical data models shared between **PostgreSQL database**, **NestJS backend (TypeScript)**, and **Flutter mobile app (Dart)**. Every field is mapped across all three layers to ensure zero ambiguity during implementation.

---

## 1. Conventions

### Naming

| Layer | Convention | Example |
|-------|-----------|---------|
| **Database (PostgreSQL)** | `lower_snake_case`, plural tables | `food_items`, `order_status` |
| **Backend (TypeScript/Prisma)** | `camelCase` properties, PascalCase classes | `foodItem`, `FoodItem` |
| **Flutter (Dart)** | `camelCase` properties, `PascalCase` classes, `snake_case` files | `foodItem`, `FoodItem`, `food_item.dart` |
| **JSON API** | `snake_case` keys | `food_item`, `order_status` |

### Serialization Rules

1. **All IDs are UUIDs** — serialized as strings in JSON (e.g., `"550e8400-e29b-41d4-a716-446655440000"`)
2. **All timestamps** — ISO 8601 format in UTC (e.g., `"2026-08-21T12:00:00.000Z"`)
3. **All decimals** — serialized as numbers in JSON (e.g., `250.00`, not `"250.00"`)
4. **Null fields** — included as `null` in JSON responses, never omitted
5. **Boolean fields** — always `true`/`false`, never `"0"`/`"1"`
6. **JSONB fields** — already valid JSON, no additional escaping

### Prisma ↔ JSON Mapping

Prisma uses `camelCase`. The API serializes to `snake_case` using `class-transformer` in NestJS:

```typescript
// In NestJS DTO
export class FoodItemResponse {
  @Transform(({ value }) => value)
  id: string;

  @Expose({ name: 'category_id' })
  categoryId: string;

  @Expose()
  name: string;

  @Expose()
  price: number;
}
```

### Dart ↔ JSON Mapping

Dart models use `freezed` + `json_serializable` with `fieldRename`:

```dart
@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'original_price') double? originalPrice,
    @JsonKey(name: 'image_urls') List<String> imageUrls,
    // ... etc
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
```

---

## 2. User

### Database Schema

```sql
CREATE TYPE user_role AS ENUM ('customer', 'admin', 'chef', 'delivery');

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number VARCHAR(15) UNIQUE NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(255) UNIQUE,
    role user_role DEFAULT 'customer' NOT NULL,
    wallet_balance NUMERIC(10, 2) DEFAULT 0.00 NOT NULL CHECK (wallet_balance >= 0),
    is_blocked BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response (GET /api/v1/auth/me)

```json
{
  "success": true,
  "data": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "phone_number": "+919825079765",
    "full_name": "Raj Patel",
    "email": "raj@example.com",
    "role": "customer",
    "wallet_balance": 120.00,
    "is_blocked": false,
    "created_at": "2026-08-01T10:00:00.000Z",
    "updated_at": "2026-08-21T12:00:00.000Z"
  }
}
```

### Dart Model

```dart
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

### Prisma Model

```prisma
enum Role {
  customer
  admin
  chef
  delivery
}

model User {
  id            String   @id @default(uuid()) @db.Uuid
  phoneNumber   String   @unique @map("phone_number") @db.VarChar(15)
  fullName      String?  @map("full_name") @db.VarChar(100)
  email         String?  @unique @db.VarChar(255)
  role          Role     @default(customer)
  walletBalance Decimal  @default(0) @map("wallet_balance") @db.Decimal(10, 2)
  isBlocked     Boolean  @default(false) @map("is_blocked")
  createdAt     DateTime @default(now()) @map("created_at")
  updatedAt     DateTime @updatedAt @map("updated_at")

  // Relations
  addresses      Address[]
  cart           Cart?
  orders         Order[]
  reviews        Review[]
  subscriptions  UserSubscription[]
  walletTransactions WalletTransaction[]
  loyaltyPoints  LoyaltyPoint[]
  wishlist       Wishlist[]
  notifications  Notification[]
  fcmTokens      FcmToken[]

  @@map("users")
}
```

---

## 3. Address

### Database Schema

```sql
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(50) NOT NULL,
    address_line1 TEXT NOT NULL,
    address_line2 TEXT,
    city VARCHAR(100) DEFAULT 'Ahmedabad' NOT NULL,
    state VARCHAR(100) DEFAULT 'Gujarat' NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    latitude NUMERIC(9, 6) NOT NULL,
    longitude NUMERIC(9, 6) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "660e8400-e29b-41d4-a716-446655440001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "label": "Home",
  "address_line1": "42, Maple Avenue, Satellite Road",
  "address_line2": "Near Jupiter Park",
  "city": "Ahmedabad",
  "state": "Gujarat",
  "postal_code": "380015",
  "latitude": 23.0225,
  "longitude": 72.5714,
  "phone": "+919825079765",
  "is_default": true,
  "created_at": "2026-08-01T10:30:00.000Z"
}
```

### Dart Model

```dart
@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String label,
    @JsonKey(name: 'address_line1') required String addressLine1,
    @JsonKey(name: 'address_line2') String? addressLine2,
    @Default('Ahmedabad') String city,
    @Default('Gujarat') String state,
    @JsonKey(name: 'postal_code') required String postalCode,
    required double latitude,
    required double longitude,
    required String phone,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
```

### Prisma Model

```prisma
model Address {
  id           String  @id @default(uuid()) @db.Uuid
  userId       String  @map("user_id") @db.Uuid
  label        String  @db.VarChar(50)
  addressLine1 String  @map("address_line1") @db.Text
  addressLine2 String? @map("address_line2") @db.Text
  city         String  @default("Ahmedabad") @db.VarChar(100)
  state        String  @default("Gujarat") @db.VarChar(100)
  postalCode   String  @map("postal_code") @db.VarChar(10)
  latitude     Decimal @db.Decimal(9, 6)
  longitude    Decimal @db.Decimal(9, 6)
  phone        String  @db.VarChar(15)
  isDefault    Boolean @default(false) @map("is_default")
  createdAt    DateTime @default(now()) @map("created_at")

  user User @relation(fields: [userId], references: [id], onDelete: Cascade)

  @@index([userId])
  @@map("addresses")
}
```

---

## 4. Category

### Database Schema

```sql
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    icon VARCHAR(10) NOT NULL,
    display_order INTEGER DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "770e8400-e29b-41d4-a716-446655440002",
  "name": "Gujarati Thali",
  "icon": "🍛",
  "display_order": 1,
  "is_active": true,
  "created_at": "2026-08-01T10:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required String icon,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
```

### Prisma Model

```prisma
model Category {
  id           String   @id @default(uuid()) @db.Uuid
  name         String   @unique @db.VarChar(100)
  icon         String   @db.VarChar(10)
  displayOrder Int      @default(0) @map("display_order")
  isActive     Boolean  @default(true) @map("is_active")
  createdAt    DateTime @default(now()) @map("created_at")

  // Relations
  foodItems    FoodItem[]

  @@map("categories")
}
```

---

## 5. Food Item

### Database Schema

```sql
CREATE TABLE food_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    original_price NUMERIC(10, 2) CHECK (original_price >= price),
    image_urls JSONB DEFAULT '[]'::jsonb NOT NULL,
    video_url TEXT,
    calories INTEGER,
    preparation_time_minutes INTEGER DEFAULT 20 NOT NULL,
    is_veg BOOLEAN DEFAULT TRUE NOT NULL CHECK (is_veg = TRUE),
    is_jain_available BOOLEAN DEFAULT FALSE NOT NULL,
    is_fasting_friendly BOOLEAN DEFAULT FALSE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    is_bestseller BOOLEAN DEFAULT FALSE NOT NULL,
    is_healthy_pick BOOLEAN DEFAULT FALSE NOT NULL,
    rating NUMERIC(3, 2) DEFAULT 0.00 NOT NULL,
    reviews_count INTEGER DEFAULT 0 NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "880e8400-e29b-41d4-a716-446655440003",
  "category_id": "770e8400-e29b-41d4-a716-446655440002",
  "name": "Gujarati Thali",
  "description": "Traditional unlimited Gujarati thali with dal, kadhi, rice, roti, sabzi, pickle, and sweets.",
  "price": 250.00,
  "original_price": 300.00,
  "image_urls": [
    "https://res.cloudinary.com/parabdi/image/upload/v1/food/thali-1.jpg",
    "https://res.cloudinary.com/parabdi/image/upload/v1/food/thali-2.jpg"
  ],
  "video_url": "https://res.cloudinary.com/parabdi/video/upload/v1/food/thali-prep.mp4",
  "calories": 650,
  "preparation_time_minutes": 25,
  "is_veg": true,
  "is_jain_available": true,
  "is_fasting_friendly": false,
  "is_active": true,
  "is_bestseller": true,
  "is_healthy_pick": false,
  "rating": 4.75,
  "reviews_count": 128,
  "category": {
    "id": "770e8400-e29b-41d4-a716-446655440002",
    "name": "Gujarati Thali",
    "icon": "🍛"
  },
  "customization_groups": [
    {
      "id": "990e8400-e29b-41d4-a716-446655440004",
      "name": "Portion Size",
      "min_selections": 1,
      "max_selections": 1,
      "items": [
        {
          "id": "aa0e8400-e29b-41d4-a716-446655440005",
          "name": "Full",
          "additional_price": 0.00,
          "is_active": true
        },
        {
          "id": "bb0e8400-e29b-41d4-a716-446655440006",
          "name": "Half",
          "additional_price": -100.00,
          "is_active": true
        }
      ]
    },
    {
      "id": "cc0e8400-e29b-41d4-a716-446655440007",
      "name": "Add-ons",
      "min_selections": 0,
      "max_selections": 5,
      "items": [
        {
          "id": "dd0e8400-e29b-41d4-a716-446655440008",
          "name": "Extra Ghee",
          "additional_price": 20.00,
          "is_active": true
        },
        {
          "id": "ee0e8400-e29b-41d4-a716-446655440009",
          "name": "Extra Roti",
          "additional_price": 15.00,
          "is_active": true
        }
      ]
    }
  ],
  "created_at": "2026-08-01T10:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'original_price') double? originalPrice,
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    @JsonKey(name: 'video_url') String? videoUrl,
    int? calories,
    @JsonKey(name: 'preparation_time_minutes') @Default(20) int preparationTimeMinutes,
    @JsonKey(name: 'is_veg') @Default(true) bool isVeg,
    @JsonKey(name: 'is_jain_available') @Default(false) bool isJainAvailable,
    @JsonKey(name: 'is_fasting_friendly') @Default(false) bool isFastingFriendly,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_bestseller') @Default(false) bool isBestseller,
    @JsonKey(name: 'is_healthy_pick') @Default(false) bool isHealthyPick,
    @Default(0.0) double rating,
    @JsonKey(name: 'reviews_count') @Default(0) int reviewsCount,
    Category? category,
    @JsonKey(name: 'customization_groups')
    @Default([])
    List<CustomizationGroup> customizationGroups,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
```

---

## 6. Customization Group & Item

### Database Schema

```sql
CREATE TABLE customization_groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    food_item_id UUID NOT NULL REFERENCES food_items(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    min_selections INTEGER DEFAULT 0 NOT NULL,
    max_selections INTEGER DEFAULT 1 NOT NULL,
    display_order INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE customization_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    group_id UUID NOT NULL REFERENCES customization_groups(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    additional_price NUMERIC(10, 2) DEFAULT 0.00 NOT NULL CHECK (additional_price >= 0),
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    display_order INTEGER DEFAULT 0 NOT NULL
);
```

### JSON API Response

```json
{
  "id": "990e8400-e29b-41d4-a716-446655440004",
  "name": "Spice Level",
  "min_selections": 1,
  "max_selections": 1,
  "items": [
    {
      "id": "ff0e8400-e29b-41d4-a716-446655440010",
      "name": "Mild",
      "additional_price": 0.00,
      "is_active": true
    },
    {
      "id": "aa1e8400-e29b-41d4-a716-446655440011",
      "name": "Medium",
      "additional_price": 0.00,
      "is_active": true
    },
    {
      "id": "bb1e8400-e29b-41d4-a716-446655440012",
      "name": "Spicy",
      "additional_price": 0.00,
      "is_active": true
    }
  ]
}
```

### Dart Models

```dart
@freezed
class CustomizationGroup with _$CustomizationGroup {
  const factory CustomizationGroup({
    required String id,
    required String name,
    @JsonKey(name: 'min_selections') @Default(0) int minSelections,
    @JsonKey(name: 'max_selections') @Default(1) int maxSelections,
    @Default([]) List<CustomizationItem> items,
  }) = _CustomizationGroup;

  factory CustomizationGroup.fromJson(Map<String, dynamic> json) =>
      _$CustomizationGroupFromJson(json);
}

@freezed
class CustomizationItem with _$CustomizationItem {
  const factory CustomizationItem({
    required String id,
    required String name,
    @JsonKey(name: 'additional_price') @Default(0.0) double additionalPrice,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _CustomizationItem;

  factory CustomizationItem.fromJson(Map<String, dynamic> json) =>
      _$CustomizationItemFromJson(json);
}
```

---

## 7. Cart & Cart Items

### Database Schema

```sql
CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    food_item_id UUID NOT NULL REFERENCES food_items(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    customization_items JSONB DEFAULT '[]'::jsonb NOT NULL,
    special_instructions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### `cart_items.customization_items` JSONB Schema

```json
[
  {
    "customization_item_id": "ff0e8400-e29b-41d4-a716-446655440010",
    "name": "Mild",
    "additional_price": 0.00
  },
  {
    "customization_item_id": "dd0e8400-e29b-41d4-a716-446655440008",
    "name": "Extra Ghee",
    "additional_price": 20.00
  }
]
```

### JSON API Response (GET /api/v1/cart)

```json
{
  "id": "cart-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "items": [
    {
      "id": "ci-uuid-001",
      "food_item": {
        "id": "880e8400-e29b-41d4-a716-446655440003",
        "name": "Gujarati Thali",
        "price": 250.00,
        "image_urls": ["https://res.cloudinary.com/parabdi/image/upload/v1/food/thali-1.jpg"],
        "is_veg": true
      },
      "quantity": 2,
      "customization_items": [
        {
          "customization_item_id": "ff0e8400-e29b-41d4-a716-446655440010",
          "name": "Mild",
          "additional_price": 0.00
        }
      ],
      "special_instructions": "Extra spicy please",
      "unit_price": 250.00,
      "total_price": 500.00,
      "created_at": "2026-08-21T10:00:00.000Z"
    }
  ],
  "subtotal": 500.00,
  "item_count": 2,
  "updated_at": "2026-08-21T10:00:00.000Z"
}
```

### Dart Models

```dart
@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default([]) List<CartItem> items,
    @Default(0.0) double subtotal,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    @JsonKey(name: 'food_item') required FoodItem foodItem,
    @Default(1) int quantity,
    @JsonKey(name: 'customization_items')
    @Default([])
    List<SelectedCustomization> customizationItems,
    @JsonKey(name: 'special_instructions') String? specialInstructions,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'total_price') required double totalPrice,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

@freezed
class SelectedCustomization with _$SelectedCustomization {
  const factory SelectedCustomization({
    @JsonKey(name: 'customization_item_id') required String customizationItemId,
    required String name,
    @JsonKey(name: 'additional_price') @Default(0.0) double additionalPrice,
  }) = _SelectedCustomization;

  factory SelectedCustomization.fromJson(Map<String, dynamic> json) =>
      _$SelectedCustomizationFromJson(json);
}
```

---

## 8. Order

### Database Schema

```sql
CREATE TYPE order_status AS ENUM (
    'pending_payment', 'placed', 'confirmed', 'preparing', 'ready',
    'rider_assigned', 'picked_up', 'out_for_delivery', 'delivered',
    'cancelled', 'rejected'
);
CREATE TYPE payment_method AS ENUM ('upi', 'card', 'net_banking', 'wallet', 'cod');
CREATE TYPE payment_status AS ENUM ('pending', 'paid', 'failed', 'refunded');

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    address_id UUID REFERENCES addresses(id) ON DELETE RESTRICT,
    status order_status DEFAULT 'placed' NOT NULL,
    payment_method payment_method DEFAULT 'upi' NOT NULL,
    payment_status payment_status DEFAULT 'pending' NOT NULL,
    payment_reference_id VARCHAR(255),
    item_total NUMERIC(10, 2) NOT NULL,
    tax_amount NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    delivery_fee NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    platform_fee NUMERIC(10, 2) DEFAULT 2.00 NOT NULL,
    discount_amount NUMERIC(10, 2) DEFAULT 0.00 NOT NULL,
    grand_total NUMERIC(10, 2) NOT NULL,
    special_instructions TEXT,
    delivery_slot VARCHAR(100) NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    chef_id UUID REFERENCES users(id) ON DELETE SET NULL,
    delivery_boy_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response (GET /api/v1/orders/:id)

```json
{
  "id": "order-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "status": "preparing",
  "payment_method": "upi",
  "payment_status": "paid",
  "payment_reference_id": "pay_RZP123456789",
  "item_total": 500.00,
  "tax_amount": 25.00,
  "delivery_fee": 0.00,
  "platform_fee": 2.00,
  "discount_amount": 100.00,
  "grand_total": 427.00,
  "special_instructions": "Extra spicy please",
  "delivery_slot": "12:30 PM - 1:00 PM",
  "otp_code": "482916",
  "address": {
    "id": "660e8400-e29b-41d4-a716-446655440001",
    "label": "Home",
    "address_line1": "42, Maple Avenue, Satellite Road",
    "city": "Ahmedabad",
    "latitude": 23.0225,
    "longitude": 72.5714
  },
  "chef": {
    "id": "chef-uuid-001",
    "full_name": "Chef Mahesh"
  },
  "items": [
    {
      "id": "oi-uuid-001",
      "food_item": {
        "id": "880e8400-e29b-41d4-a716-446655440003",
        "name": "Gujarati Thali",
        "image_urls": ["https://res.cloudinary.com/parabdi/image/upload/v1/food/thali-1.jpg"]
      },
      "quantity": 2,
      "unit_price": 250.00,
      "customization_items": [
        {
          "name": "Mild",
          "price": 0.00
        }
      ]
    }
  ],
  "status_history": [
    {
      "status": "placed",
      "timestamp": "2026-08-21T10:00:00.000Z",
      "triggered_by": "system"
    },
    {
      "status": "confirmed",
      "timestamp": "2026-08-21T10:05:00.000Z",
      "triggered_by": "chef"
    },
    {
      "status": "preparing",
      "timestamp": "2026-08-21T10:10:00.000Z",
      "triggered_by": "chef"
    }
  ],
  "created_at": "2026-08-21T10:00:00.000Z",
  "updated_at": "2026-08-21T10:10:00.000Z"
}
```

### Dart Model

```dart
@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String status,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'payment_reference_id') String? paymentReferenceId,
    @JsonKey(name: 'item_total') required double itemTotal,
    @JsonKey(name: 'tax_amount') @Default(0.0) double taxAmount,
    @JsonKey(name: 'delivery_fee') @Default(0.0) double deliveryFee,
    @JsonKey(name: 'platform_fee') @Default(2.0) double platformFee,
    @JsonKey(name: 'discount_amount') @Default(0.0) double discountAmount,
    @JsonKey(name: 'grand_total') required double grandTotal,
    @JsonKey(name: 'special_instructions') String? specialInstructions,
    @JsonKey(name: 'delivery_slot') required String deliverySlot,
    @JsonKey(name: 'otp_code') String? otpCode,
    Address? address,
    OrderChef? chef,
    @Default([]) List<OrderItem> items,
    @JsonKey(name: 'status_history') @Default([]) List<OrderStatusEvent> statusHistory,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    @JsonKey(name: 'food_item') required OrderFoodItem foodItem,
    required int quantity,
    @JsonKey(name: 'unit_price') required double unitPrice,
    @JsonKey(name: 'customization_items')
    @Default([])
    List<OrderCustomization> customizationItems,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class OrderFoodItem with _$OrderFoodItem {
  const factory OrderFoodItem({
    required String id,
    required String name,
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
  }) = _OrderFoodItem;

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) =>
      _$OrderFoodItemFromJson(json);
}

@freezed
class OrderCustomization with _$OrderCustomization {
  const factory OrderCustomization({
    required String name,
    required double price,
  }) = _OrderCustomization;

  factory OrderCustomization.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomizationFromJson(json);
}

@freezed
class OrderStatusEvent with _$OrderStatusEvent {
  const factory OrderStatusEvent({
    required String status,
    required DateTime timestamp,
    @JsonKey(name: 'triggered_by') required String triggeredBy,
  }) = _OrderStatusEvent;

  factory OrderStatusEvent.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusEventFromJson(json);
}

@freezed
class OrderChef with _$OrderChef {
  const factory OrderChef({
    required String id,
    @JsonKey(name: 'full_name') String? fullName,
  }) = _OrderChef;

  factory OrderChef.fromJson(Map<String, dynamic> json) =>
      _$OrderChefFromJson(json);
}
```

---

## 9. Subscription

### Database Schema

```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    duration_days INTEGER NOT NULL CHECK (duration_days > 0),
    meals_count INTEGER NOT NULL CHECK (meals_count > 0),
    meal_type VARCHAR(50) NOT NULL,
    benefits JSONB DEFAULT '[]'::jsonb NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TYPE sub_status AS ENUM ('active', 'paused', 'completed', 'cancelled');

CREATE TABLE user_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    subscription_id UUID NOT NULL REFERENCES subscriptions(id) ON DELETE RESTRICT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    meals_remaining INTEGER NOT NULL CHECK (meals_remaining >= 0),
    status sub_status DEFAULT 'active' NOT NULL,
    skip_dates JSONB DEFAULT '[]'::jsonb NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### `user_subscriptions.skip_dates` JSONB Schema

```json
["2026-08-25", "2026-08-28"]
```

### `subscriptions.benefits` JSONB Schema

```json
[
  "Free delivery on all orders",
  "Priority kitchen processing",
  "10% off on add-ons",
  "Skip or pause anytime before 9 AM"
]
```

### JSON API Response

```json
{
  "id": "sub-uuid-001",
  "name": "Daily Lunch Plan",
  "description": "30-day lunch subscription with fresh Gujarati meals delivered daily.",
  "price": 4500.00,
  "duration_days": 30,
  "meals_count": 30,
  "meal_type": "lunch",
  "benefits": [
    "Free delivery on all orders",
    "Priority kitchen processing",
    "10% off on add-ons",
    "Skip or pause anytime before 9 AM"
  ],
  "is_active": true
}
```

### User Subscription Response

```json
{
  "id": "usub-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "subscription": {
    "id": "sub-uuid-001",
    "name": "Daily Lunch Plan",
    "meal_type": "lunch"
  },
  "start_date": "2026-08-01",
  "end_date": "2026-08-31",
  "meals_remaining": 18,
  "status": "active",
  "skip_dates": ["2026-08-25", "2026-08-28"],
  "created_at": "2026-08-01T10:00:00.000Z"
}
```

### Dart Models

```dart
@freezed
class SubscriptionPlan with _$SubscriptionPlan {
  const factory SubscriptionPlan({
    required String id,
    required String name,
    String? description,
    required double price,
    @JsonKey(name: 'duration_days') required int durationDays,
    @JsonKey(name: 'meals_count') required int mealsCount,
    @JsonKey(name: 'meal_type') required String mealType,
    @Default([]) List<String> benefits,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _SubscriptionPlan;

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);
}

@freezed
class UserSubscription with _$UserSubscription {
  const factory UserSubscription({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required SubscriptionPlan subscription,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') required DateTime endDate,
    @JsonKey(name: 'meals_remaining') required int mealsRemaining,
    required String status,
    @JsonKey(name: 'skip_dates') @Default([]) List<DateTime> skipDates,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _UserSubscription;

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);
}
```

---

## 10. Coupon

### Database Schema

```sql
CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL,
    discount_value NUMERIC(10, 2) NOT NULL,
    min_order_value NUMERIC(10, 2) DEFAULT 0.00,
    max_discount_value NUMERIC(10, 2),
    max_uses INTEGER,
    max_uses_per_user INTEGER DEFAULT 1,
    current_uses INTEGER DEFAULT 0,
    is_first_order_only BOOLEAN DEFAULT FALSE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE coupon_usage (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    coupon_id UUID NOT NULL REFERENCES coupons(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    used_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "coupon-uuid-001",
  "code": "HEALTH20",
  "description": "20% off on orders above ₹200",
  "discount_type": "percentage",
  "discount_value": 20.00,
  "min_order_value": 200.00,
  "max_discount_value": 100.00,
  "max_uses": 1000,
  "max_uses_per_user": 1,
  "is_first_order_only": false,
  "is_active": true,
  "expires_at": "2026-12-31T23:59:59.000Z",
  "created_at": "2026-08-01T10:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String code,
    String? description,
    @JsonKey(name: 'discount_type') required String discountType,
    @JsonKey(name: 'discount_value') required double discountValue,
    @JsonKey(name: 'min_order_value') @Default(0.0) double minOrderValue,
    @JsonKey(name: 'max_discount_value') double? maxDiscountValue,
    @JsonKey(name: 'max_uses') int? maxUses,
    @JsonKey(name: 'max_uses_per_user') @Default(1) int maxUsesPerUser,
    @JsonKey(name: 'is_first_order_only') @Default(false) bool isFirstOrderOnly,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) =>
      _$CouponFromJson(json);
}
```

---

## 11. Review

### Database Schema

```sql
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    food_item_id UUID NOT NULL REFERENCES food_items(id) ON DELETE CASCADE,
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    images JSONB DEFAULT '[]'::jsonb NOT NULL,
    is_approved BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### `reviews.images` JSONB Schema

```json
[
  "https://res.cloudinary.com/parabdi/image/upload/v1/reviews/img1.jpg",
  "https://res.cloudinary.com/parabdi/image/upload/v1/reviews/img2.jpg"
]
```

### JSON API Response

```json
{
  "id": "review-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "food_item_id": "880e8400-e29b-41d4-a716-446655440003",
  "order_id": "order-uuid-001",
  "rating": 5,
  "comment": "Excellent thali! Authentic Gujarati taste.",
  "images": [],
  "is_approved": true,
  "user": {
    "full_name": "Raj Patel"
  },
  "created_at": "2026-08-21T14:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'food_item_id') required String foodItemId,
    @JsonKey(name: 'order_id') required String orderId,
    required int rating,
    String? comment,
    @Default([]) List<String> images,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    ReviewUser? user,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}

@freezed
class ReviewUser with _$ReviewUser {
  const factory ReviewUser({
    @JsonKey(name: 'full_name') String? fullName,
  }) = _ReviewUser;

  factory ReviewUser.fromJson(Map<String, dynamic> json) =>
      _$ReviewUserFromJson(json);
}
```

---

## 12. Banner

### Database Schema

```sql
CREATE TABLE banners (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(150) NOT NULL,
    subtitle VARCHAR(255),
    image_url TEXT NOT NULL,
    click_action VARCHAR(50),
    action_value VARCHAR(255),
    display_order INTEGER DEFAULT 0 NOT NULL,
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "banner-uuid-001",
  "title": "Flat 20% Off on Thalis",
  "subtitle": "Use code HEALTH20 at checkout",
  "image_url": "https://res.cloudinary.com/parabdi/image/upload/v1/banners/thali-offer.jpg",
  "click_action": "food",
  "action_value": "880e8400-e29b-41d4-a716-446655440003",
  "display_order": 1,
  "is_active": true
}
```

### Dart Model

```dart
@freezed
class Banner with _$Banner {
  const factory Banner({
    required String id,
    required String title,
    String? subtitle,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'click_action') String? clickAction,
    @JsonKey(name: 'action_value') String? actionValue,
    @JsonKey(name: 'display_order') @Default(0) int displayOrder,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _Banner;

  factory Banner.fromJson(Map<String, dynamic> json) =>
      _$BannerFromJson(json);
}
```

---

## 13. Short (Food Video)

### Database Schema

```sql
CREATE TABLE shorts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    video_url TEXT NOT NULL,
    thumbnail_url TEXT NOT NULL,
    caption TEXT,
    food_item_id UUID REFERENCES food_items(id) ON DELETE SET NULL,
    category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
    likes_count INTEGER DEFAULT 0 NOT NULL,
    views_count INTEGER DEFAULT 0 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE food_short_likes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    short_id UUID NOT NULL REFERENCES shorts(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(user_id, short_id)
);
```

### JSON API Response

```json
{
  "id": "short-uuid-001",
  "video_url": "https://res.cloudinary.com/parabdi/video/upload/v1/shorts/thali-prep.mp4",
  "thumbnail_url": "https://res.cloudinary.com/parabdi/image/upload/v1/shorts/thali-thumb.jpg",
  "caption": "Watch how we prepare our famous Gujarati Thali!",
  "food_item_id": "880e8400-e29b-41d4-a716-446655440003",
  "category_id": "770e8400-e29b-41d4-a716-446655440002",
  "likes_count": 245,
  "views_count": 1820,
  "is_liked_by_user": true,
  "is_saved_by_user": false,
  "created_at": "2026-08-20T10:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class FoodShort with _$FoodShort {
  const factory FoodShort({
    required String id,
    @JsonKey(name: 'video_url') required String videoUrl,
    @JsonKey(name: 'thumbnail_url') required String thumbnailUrl,
    String? caption,
    @JsonKey(name: 'food_item_id') String? foodItemId,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
    @JsonKey(name: 'views_count') @Default(0) int viewsCount,
    @JsonKey(name: 'is_liked_by_user') @Default(false) bool isLikedByUser,
    @JsonKey(name: 'is_saved_by_user') @Default(false) bool isSavedByUser,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FoodShort;

  factory FoodShort.fromJson(Map<String, dynamic> json) =>
      _$FoodShortFromJson(json);
}
```

---

## 14. Wishlist

### Database Schema

```sql
CREATE TABLE wishlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    food_item_id UUID NOT NULL REFERENCES food_items(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(user_id, food_item_id)
);
```

### JSON API Response

```json
{
  "id": "wishlist-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "food_item": {
    "id": "880e8400-e29b-41d4-a716-446655440003",
    "name": "Gujarati Thali",
    "price": 250.00,
    "image_urls": ["https://res.cloudinary.com/parabdi/image/upload/v1/food/thali-1.jpg"],
    "rating": 4.75,
    "is_veg": true
  },
  "created_at": "2026-08-21T10:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'food_item') required FoodItem foodItem,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);
}
```

---

## 15. Notification

### Database Schema

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    body TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    reference_id VARCHAR(255),
    is_read BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "notif-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Order Confirmed!",
  "body": "Your order #ORD-001 has been confirmed and is being prepared.",
  "type": "order_update",
  "reference_id": "order-uuid-001",
  "is_read": false,
  "created_at": "2026-08-21T10:05:00.000Z"
}
```

### Dart Model

```dart
@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String body,
    required String type,
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
```

---

## 16. Wallet Transaction

### Database Schema

```sql
CREATE TYPE tx_type AS ENUM ('credit', 'debit');

CREATE TABLE wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    type tx_type NOT NULL,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    description VARCHAR(255) NOT NULL,
    reference_order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
{
  "id": "tx-uuid-001",
  "user_id": "550e8400-e29b-41d4-a716-446655440000",
  "type": "credit",
  "amount": 100.00,
  "description": "Refund for order #ORD-001",
  "reference_order_id": "order-uuid-001",
  "created_at": "2026-08-21T14:00:00.000Z"
}
```

### Dart Model

```dart
@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String type,
    required double amount,
    required String description,
    @JsonKey(name: 'reference_order_id') String? referenceOrderId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}
```

---

## 17. FCM Token

### Database Schema

```sql
CREATE TABLE fcm_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform VARCHAR(20) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### Dart Model

```dart
@freezed
class FcmToken with _$FcmToken {
  const factory FcmToken({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String token,
    required String platform,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _FcmToken;

  factory FcmToken.fromJson(Map<String, dynamic> json) =>
      _$FcmTokenFromJson(json);
}
```

---

## 18. Order Status History

### Database Schema

```sql
CREATE TABLE order_status_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    from_status VARCHAR(30),
    to_status VARCHAR(30) NOT NULL,
    triggered_by UUID REFERENCES users(id) ON DELETE SET NULL,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### Dart Model

```dart
@freezed
class OrderStatusHistory with _$OrderStatusHistory {
  const factory OrderStatusHistory({
    required String id,
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'from_status') String? fromStatus,
    @JsonKey(name: 'to_status') required String toStatus,
    @JsonKey(name: 'triggered_by') String? triggeredBy,
    String? notes,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _OrderStatusHistory;

  factory OrderStatusHistory.fromJson(Map<String, dynamic> json) =>
      _$OrderStatusHistoryFromJson(json);
}
```

---

## 19. Settings

### Database Schema

```sql
CREATE TABLE settings (
    key VARCHAR(100) PRIMARY KEY,
    value TEXT NOT NULL,
    value_type VARCHAR(20) DEFAULT 'string' NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response (GET /api/v1/admin/settings)

```json
{
  "data": [
    {
      "key": "kitchen_latitude",
      "value": "23.0225",
      "value_type": "number",
      "description": "Kitchen GPS latitude"
    },
    {
      "key": "kitchen_longitude",
      "value": "72.5714",
      "value_type": "number",
      "description": "Kitchen GPS longitude"
    },
    {
      "key": "delivery_radius_km",
      "value": "5",
      "value_type": "number",
      "description": "Maximum delivery radius in kilometers"
    },
    {
      "key": "minimum_order_value",
      "value": "100",
      "value_type": "number",
      "description": "Minimum order value in rupees"
    },
    {
      "key": "platform_fee",
      "value": "2",
      "value_type": "number",
      "description": "Platform fee per order in rupees"
    },
    {
      "key": "gst_rate",
      "value": "5",
      "value_type": "number",
      "description": "GST rate percentage"
    },
    {
      "key": "free_delivery_above",
      "value": "200",
      "value_type": "number",
      "description": "Free delivery threshold in rupees"
    },
    {
      "key": "kitchen_opening_time",
      "value": "08:00",
      "value_type": "string",
      "description": "Kitchen opening time (HH:MM)"
    },
    {
      "key": "kitchen_closing_time",
      "value": "22:00",
      "value_type": "string",
      "description": "Kitchen closing time (HH:MM)"
    },
    {
      "key": "cutoff_time_skip_meal",
      "value": "09:00",
      "value_type": "string",
      "description": "Cutoff time for skipping tomorrow's subscription meal"
    },
    {
      "key": "maintenance_mode",
      "value": "false",
      "value_type": "boolean",
      "description": "Enable maintenance mode to block customer access"
    }
  ]
}
```

### Dart Model

```dart
@freezed
class Setting with _$Setting {
  const factory Setting({
    required String key,
    required String value,
    @JsonKey(name: 'value_type') @Default('string') String valueType,
    String? description,
  }) = _Setting;

  factory Setting.fromJson(Map<String, dynamic> json) =>
      _$SettingFromJson(json);
}
```

---

## 20. Loyalty Points

### Database Schema

```sql
CREATE TABLE loyalty_points (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    points INTEGER NOT NULL,
    transaction_type VARCHAR(20) NOT NULL,
    description VARCHAR(255) NOT NULL,
    reference_order_id UUID REFERENCES orders(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### Dart Model

```dart
@freezed
class LoyaltyPoint with _$LoyaltyPoint {
  const factory LoyaltyPoint({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required int points,
    @JsonKey(name: 'transaction_type') required String transactionType,
    required String description,
    @JsonKey(name: 'reference_order_id') String? referenceOrderId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _LoyaltyPoint;

  factory LoyaltyPoint.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyPointFromJson(json);
}
```

---

## 21. Admin Audit Log

### Database Schema

```sql
CREATE TABLE admin_audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    action VARCHAR(100) NOT NULL,
    entity VARCHAR(100) NOT NULL,
    entity_id UUID,
    old_value JSONB,
    new_value JSONB,
    ip_address VARCHAR(45),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### Dart Model

```dart
@freezed
class AdminAuditLog with _$AdminAuditLog {
  const factory AdminAuditLog({
    required String id,
    @JsonKey(name: 'admin_id') required String adminId,
    required String action,
    required String entity,
    @JsonKey(name: 'entity_id') String? entityId,
    @JsonKey(name: 'old_value') Map<String, dynamic>? oldValue,
    @JsonKey(name: 'new_value') Map<String, dynamic>? newValue,
    @JsonKey(name: 'ip_address') String? ipAddress,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _AdminAuditLog;

  factory AdminAuditLog.fromJson(Map<String, dynamic> json) =>
      _$AdminAuditLogFromJson(json);
}
```

---

## 22. Delivery Slot

### Database Schema

```sql
CREATE TABLE delivery_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    start_time VARCHAR(5) NOT NULL,
    end_time VARCHAR(5) NOT NULL,
    max_orders INTEGER DEFAULT 10 NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    display_order INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### JSON API Response

```json
[
  {
    "id": "slot-uuid-001",
    "name": "12:00 PM - 12:30 PM",
    "start_time": "12:00",
    "end_time": "12:30",
    "max_orders": 10,
    "is_active": true
  },
  {
    "id": "slot-uuid-002",
    "name": "12:30 PM - 1:00 PM",
    "start_time": "12:30",
    "end_time": "13:00",
    "max_orders": 10,
    "is_active": true
  },
  {
    "id": "slot-uuid-003",
    "name": "1:00 PM - 1:30 PM",
    "start_time": "13:00",
    "end_time": "13:30",
    "max_orders": 8,
    "is_active": true
  }
]
```

### Dart Model

```dart
@freezed
class DeliverySlot with _$DeliverySlot {
  const factory DeliverySlot({
    required String id,
    required String name,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    @JsonKey(name: 'max_orders') @Default(10) int maxOrders,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _DeliverySlot;

  factory DeliverySlot.fromJson(Map<String, dynamic> json) =>
      _$DeliverySlotFromJson(json);
}
```
