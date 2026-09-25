# DATABASE.md — PostgreSQL Schema & Relational Model

This document defines the complete PostgreSQL database schema for **Parabdi**. Uses UUID primary keys, JSONB for flexible data, and explicit indexes for performance.

**Database:** PostgreSQL 15+
**ORM:** Prisma (see `prisma/schema.prisma` for canonical source)

---

## 1. Entity Relationship Overview

```
 [Users] ──< [Addresses]
    │
    ├─< [FCM Tokens]
    ├─< [Carts] ──< [Cart Items]
    │
    ├─< [Orders] ──< [Order Items] ──< [Order Item Customizations]
    │      │             │
    │      │             └─> [Food Items] ──< [Customization Groups] ──< [Customization Items]
    │      │                    │
    │      │                    ├─< [Shorts] ──< [Food Short Likes]
    │      │                    ├─< [Reviews]
    │      │                    └─< [Wishlist]
    │      │
    │      ├─< [Order Status History]
    │      ├─> [Chefs (Users)]
    │      └─> [Delivery Boys (Users)]
    │
    ├─< [User Subscriptions] ──> [Subscriptions]
    ├─< [Wallet Transactions]
    ├─< [Loyalty Points]
    ├─< [Notifications]
    └─< [Admin Audit Logs]

 [Coupons] ──< [Coupon Usage] ──> [Orders]
 [Delivery Slots] (standalone)
 [Settings] (key-value)
 [Banners] (standalone)
```

---

## 2. Table Specifications

### 2.1 Users (`users`)

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

CREATE INDEX idx_users_phone ON users(phone_number);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_email ON users(email);
```

---

### 2.2 Addresses (`addresses`)

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

CREATE INDEX idx_addresses_user ON addresses(user_id);
```

---

### 2.3 FCM Tokens (`fcm_tokens`)

```sql
CREATE TABLE fcm_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform VARCHAR(20) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_fcm_tokens_user ON fcm_tokens(user_id);
CREATE INDEX idx_fcm_tokens_active ON fcm_tokens(is_active);
```

---

### 2.4 Categories (`categories`)

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

---

### 2.5 Food Items (`food_items`)

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

CREATE INDEX idx_food_items_category ON food_items(category_id);
CREATE INDEX idx_food_items_active ON food_items(is_active);
CREATE INDEX idx_food_items_name ON food_items(name);
CREATE INDEX idx_food_items_bestseller ON food_items(is_bestseller);
CREATE INDEX idx_food_items_deleted ON food_items(deleted_at);
```

---

### 2.6 Customization Groups & Items

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

CREATE INDEX idx_customization_groups_food ON customization_groups(food_item_id);
CREATE INDEX idx_customization_items_group ON customization_items(group_id);
```

---

### 2.7 Carts & Cart Items

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

CREATE INDEX idx_cart_items_cart ON cart_items(cart_id);
```

**`cart_items.customization_items` JSONB Schema:**
```json
[
  {
    "customization_item_id": "uuid",
    "name": "Extra Ghee",
    "additional_price": 20.00
  }
]
```

---

### 2.8 Banners

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

---

### 2.9 Food Shorts

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

CREATE INDEX idx_shorts_food ON shorts(food_item_id);
CREATE INDEX idx_shorts_category ON shorts(category_id);
CREATE INDEX idx_short_likes_user ON food_short_likes(user_id);
CREATE INDEX idx_short_likes_short ON food_short_likes(short_id);
```

---

### 2.10 Orders

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

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_delivery_boy ON orders(delivery_boy_id);
CREATE INDEX idx_orders_chef ON orders(chef_id);
CREATE INDEX idx_orders_created ON orders(created_at);
CREATE INDEX idx_orders_payment_status ON orders(payment_status);
```

---

### 2.11 Order Status History

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

CREATE INDEX idx_order_status_history_order ON order_status_history(order_id);
```

---

### 2.12 Order Items & Customizations

```sql
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    food_item_id UUID NOT NULL REFERENCES food_items(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE order_item_customizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id UUID NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
    customization_item_id UUID NOT NULL REFERENCES customization_items(id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL
);

CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_item_customizations_item ON order_item_customizations(order_item_id);
```

---

### 2.13 Subscriptions

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

CREATE INDEX idx_user_subscriptions_user ON user_subscriptions(user_id);
CREATE INDEX idx_user_subscriptions_status ON user_subscriptions(status);
```

**`user_subscriptions.skip_dates` JSONB Schema:**
```json
["2026-08-25", "2026-08-28"]
```

---

### 2.14 Coupons

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

CREATE INDEX idx_coupon_usage_coupon ON coupon_usage(coupon_id);
CREATE INDEX idx_coupon_usage_user ON coupon_usage(user_id);
CREATE INDEX idx_coupons_code ON coupons(code);
```

---

### 2.15 Reviews

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

CREATE INDEX idx_reviews_food ON reviews(food_item_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);
CREATE INDEX idx_reviews_approved ON reviews(is_approved);
```

**`reviews.images` JSONB Schema:**
```json
[
  "https://res.cloudinary.com/parabdi/image/upload/v1/reviews/img1.jpg"
]
```

---

### 2.16 Wishlist

```sql
CREATE TABLE wishlist (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    food_item_id UUID NOT NULL REFERENCES food_items(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE(user_id, food_item_id)
);

CREATE INDEX idx_wishlist_user ON wishlist(user_id);
CREATE INDEX idx_wishlist_food ON wishlist(food_item_id);
```

---

### 2.17 Wallet Transactions

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

CREATE INDEX idx_wallet_transactions_user ON wallet_transactions(user_id);
CREATE INDEX idx_wallet_transactions_order ON wallet_transactions(reference_order_id);
```

---

### 2.18 Loyalty Points

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

CREATE INDEX idx_loyalty_points_user ON loyalty_points(user_id);
```

---

### 2.19 Notifications

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

CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at);
```

---

### 2.20 Delivery Slots

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

---

### 2.21 Admin Audit Logs

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

CREATE INDEX idx_audit_logs_admin ON admin_audit_logs(admin_id);
CREATE INDEX idx_audit_logs_entity ON admin_audit_logs(entity, entity_id);
CREATE INDEX idx_audit_logs_created ON admin_audit_logs(created_at);
```

---

### 2.22 Settings

```sql
CREATE TABLE settings (
    key VARCHAR(100) PRIMARY KEY,
    value TEXT NOT NULL,
    value_type VARCHAR(20) DEFAULT 'string' NOT NULL,
    description TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

---

### 2.23 Refresh Tokens

```sql
CREATE TABLE refresh_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token_hash VARCHAR(255) NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    is_revoked BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX idx_refresh_tokens_user ON refresh_tokens(user_id);
CREATE INDEX idx_refresh_tokens_hash ON refresh_tokens(token_hash);
```

---

### 2.24 Courier Locations (Temporarily Disabled)

```sql
-- NOTE: Delivery module temporarily removed from scope
-- CREATE TABLE courier_locations (
--     delivery_boy_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
--     latitude NUMERIC(9, 6) NOT NULL,
--     longitude NUMERIC(9, 6) NOT NULL,
--     updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
-- );
```

---

## 3. JSONB Schema Definitions

### `cart_items.customization_items`
```json
[
  {
    "customization_item_id": "uuid",
    "name": "Extra Ghee",
    "additional_price": 20.00
  }
]
```

### `subscriptions.benefits`
```json
[
  "Free delivery on all orders",
  "Priority kitchen processing",
  "10% off on add-ons"
]
```

### `user_subscriptions.skip_dates`
```json
["2026-08-25", "2026-08-28"]
```

### `reviews.images`
```json
["https://res.cloudinary.com/parabdi/image/upload/v1/reviews/img1.jpg"]
```

### `food_items.image_urls`
```json
["https://res.cloudinary.com/parabdi/image/upload/v1/food/thali-1.jpg"]
```

---

## 4. Database Rules

1. **UUID Primary Keys:** All tables use `gen_random_uuid()` for primary keys.
2. **Unique Constraints:** `phone_number`, `email`, `code` (coupons), `name` (subscriptions/categories).
3. **Indexes:** Explicit indexes on all foreign keys and frequently queried columns (`status`, `is_active`, `created_at`, `name`).
4. **Soft Deletes:** `food_items` uses `deleted_at` column. Other tables use hard delete unless specified.
5. **Transactions:** All multi-row operations (order creation, payment logging) use PostgreSQL transactions.
6. **JSONB Validation:** JSONB columns validated at application layer (Prisma/Dart models) not at database level.
7. **Cascading Deletes:** User deletion cascades to addresses, carts, orders (soft), reviews, subscriptions, wallet transactions, notifications, FCM tokens. Food item deletion cascades to customization groups, cart items, reviews.
8. **Check Constraints:** `price >= 0`, `quantity > 0`, `wallet_balance >= 0`, `rating BETWEEN 1 AND 5`.

---

## 5. Seed Data

### Default Settings

```sql
INSERT INTO settings (key, value, value_type, description) VALUES
('kitchen_latitude', '23.0225', 'number', 'Kitchen GPS latitude'),
('kitchen_longitude', '72.5714', 'number', 'Kitchen GPS longitude'),
('delivery_radius_km', '5', 'number', 'Maximum delivery radius in kilometers'),
('minimum_order_value', '100', 'number', 'Minimum order value in rupees'),
('platform_fee', '2', 'number', 'Platform fee per order in rupees'),
('gst_rate', '5', 'number', 'GST rate percentage'),
('free_delivery_above', '200', 'number', 'Free delivery threshold in rupees'),
('kitchen_opening_time', '08:00', 'string', 'Kitchen opening time'),
('kitchen_closing_time', '22:00', 'string', 'Kitchen closing time'),
('cutoff_time_skip_meal', '09:00', 'string', 'Cutoff time for subscription skip'),
('maintenance_mode', 'false', 'boolean', 'Maintenance mode toggle');
```

### Default Delivery Slots

```sql
INSERT INTO delivery_slots (name, start_time, end_time, max_orders, display_order) VALUES
('12:00 PM - 12:30 PM', '12:00', '12:30', 10, 1),
('12:30 PM - 1:00 PM', '12:30', '13:00', 10, 2),
('1:00 PM - 1:30 PM', '13:00', '13:30', 8, 3),
('1:30 PM - 2:00 PM', '13:30', '14:00', 8, 4),
('7:00 PM - 7:30 PM', '19:00', '19:30', 10, 5),
('7:30 PM - 8:00 PM', '19:30', '20:00', 10, 6),
('8:00 PM - 8:30 PM', '20:00', '20:30', 8, 7);
```
