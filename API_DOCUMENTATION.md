# API_DOCUMENTATION.md — REST & WebSocket API Specification

This document details the complete NestJS backend API for **Parabdi** — every endpoint with full request/response JSON schemas, pagination, error codes, RBAC, and Socket.IO events.

**Base URL (Development):** `http://localhost:3000/api/v1`
**Base URL (Production):** `https://api.parabdikitchen.com/api/v1`

---

## 1. Global Standards

### 1.1 Response Envelope

**Success:**
```json
{
  "success": true,
  "data": { },
  "message": "Optional success message"
}
```

**Success (Paginated):**
```json
{
  "success": true,
  "data": {
    "items": [],
    "meta": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "totalPages": 8
    }
  }
}
```

**Error:**
```json
{
  "success": false,
  "error": {
    "message": "Human readable error description",
    "code": "ERROR_CODE",
    "details": []
  }
}
```

### 1.2 Pagination Parameters

All list endpoints accept these query parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | integer | 1 | Page number |
| `limit` | integer | 20 | Items per page (max 100) |
| `sort_by` | string | `created_at` | Sort field |
| `sort_order` | string | `desc` | `asc` or `desc` |
| `search` | string | — | Search term |

### 1.3 Error Code Catalog

| HTTP Status | Error Code | Description |
|-------------|-----------|-------------|
| 400 | `VALIDATION_ERROR` | Request body validation failed |
| 400 | `INVALID_OTP` | OTP code is incorrect |
| 400 | `OTP_EXPIRED` | OTP has expired (5 min TTL) |
| 400 | `PAYMENT_VERIFICATION_FAILED` | Razorpay signature mismatch |
| 400 | `COUPON_INVALID` | Coupon code doesn't exist or is inactive |
| 400 | `COUPON_EXPIRED` | Coupon has passed expiry date |
| 400 | `COUPON_MIN_ORDER` | Order total below minimum for coupon |
| 400 | `COUPON_MAX_USES` | Coupon usage limit reached |
| 400 | `ADDRESS_OUT_OF_RANGE` | Delivery address outside kitchen radius |
| 400 | `ITEM_OUT_OF_STOCK` | Food item is not available |
| 400 | `KITCHEN_CLOSED` | Kitchen is not accepting orders now |
| 400 | `MIN_ORDER_NOT_MET` | Order below minimum value |
| 400 | `SUBSCRIPTION_CUTOFF_PASSED` | Past cutoff time for skip/pause |
| 401 | `UNAUTHORIZED` | Missing or invalid JWT token |
| 401 | `TOKEN_EXPIRED` | JWT access token expired |
| 401 | `INVALID_REFRESH_TOKEN` | Refresh token invalid or revoked |
| 403 | `FORBIDDEN` | User role lacks permission |
| 403 | `ACCOUNT_BLOCKED` | User account is blocked |
| 404 | `NOT_FOUND` | Resource not found |
| 404 | `USER_NOT_FOUND` | User account not found |
| 404 | `ORDER_NOT_FOUND` | Order not found |
| 404 | `FOOD_NOT_FOUND` | Food item not found |
| 409 | `ALREADY_EXISTS` | Resource already exists (duplicate) |
| 409 | `ORDER_ALREADY_ACCEPTED` | Chef already accepted this order |
| 429 | `RATE_LIMIT_EXCEEDED` | Too many requests |
| 429 | `OTP_RATE_LIMIT` | Too many OTP requests (3 per 10 min) |
| 500 | `INTERNAL_SERVER_ERROR` | Server error |

### 1.4 Headers

```
Content-Type: application/json
Authorization: Bearer <JWT_TOKEN>
X-Request-ID: <uuid> (for tracing)
```

---

## 2. Authentication Module (`/api/v1/auth`)

### 2.1 POST `/auth/send-otp`

Sends a 6-digit OTP to the provided phone number.

**Request:**
```json
{
  "phone_number": "+919825079765"
}
```

**Validation:**
- `phone_number`: Required, must match `+91` followed by 10 digits

**Response (201):**
```json
{
  "success": true,
  "data": {
    "message": "OTP sent successfully",
    "expires_in": 300
  }
}
```

**Errors:**
- 429 `OTP_RATE_LIMIT`: Max 3 OTP requests per phone per 10 minutes
- 400 `VALIDATION_ERROR`: Invalid phone format

---

### 2.2 POST `/auth/verify-otp`

Validates OTP and returns JWT tokens.

**Request:**
```json
{
  "phone_number": "+919825079765",
  "otp": "123456"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "token_type": "Bearer",
    "expires_in": 900,
    "user": {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "phone_number": "+919825079765",
      "full_name": null,
      "role": "customer",
      "wallet_balance": 0.00,
      "is_blocked": false,
      "created_at": "2026-08-21T10:00:00.000Z"
    }
  }
}
```

**Errors:**
- 400 `INVALID_OTP`: Incorrect OTP code
- 400 `OTP_EXPIRED`: OTP expired after 5 minutes

---

### 2.3 POST `/auth/google`

Authenticates via Google OAuth ID token.

**Request:**
```json
{
  "id_token": "eyJhbGciOiJSUzI1NiIs..."
}
```

**Response (201):** Same as verify-otp response.

---

### 2.4 POST `/auth/refresh`

Refreshes an expired access token.

**Request:**
```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIs...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
    "token_type": "Bearer",
    "expires_in": 900
  }
}
```

---

### 2.5 POST `/auth/logout` 🔒

Invalidates the current session.

**Headers:** `Authorization: Bearer <token>`

**Response (200):**
```json
{
  "success": true,
  "data": { "message": "Logged out successfully" }
}
```

---

### 2.6 GET `/auth/me` 🔒

Returns the current authenticated user's profile.

**Response (200):**
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

---

### 2.7 PATCH `/auth/profile` 🔒

Updates the current user's profile.

**Request:**
```json
{
  "full_name": "Raj Patel",
  "email": "raj@example.com"
}
```

**Response (200):** Updated user object.

---

## 3. Categories Module (`/api/v1/categories`)

### 3.1 GET `/categories`

Public — fetches all active categories.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "770e8400-e29b-41d4-a716-446655440002",
      "name": "Gujarati Thali",
      "icon": "🍛",
      "display_order": 1,
      "is_active": true,
      "food_count": 8
    }
  ]
}
```

---

### 3.2 POST `/admin/categories` 🔒_admin

**Request:**
```json
{
  "name": "Kathiyawadi",
  "icon": "🍲",
  "display_order": 2,
  "is_active": true
}
```

**Response (201):** Created category object.

---

### 3.3 PATCH `/admin/categories/:id` 🔒_admin

**Request:** Partial update of any category field.

**Response (200):** Updated category object.

---

### 3.4 DELETE `/admin/categories/:id` 🔒_admin

Soft-deletes a category (sets `is_active = false`).

**Response (200):**
```json
{
  "success": true,
  "data": { "message": "Category deactivated successfully" }
}
```

---

## 4. Foods Module (`/api/v1/foods`)

### 4.1 GET `/foods`

Public — searches and filters food items.

**Query Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `category_id` | UUID | Filter by category |
| `search` | string | Search name/description |
| `is_veg` | boolean | Filter vegetarian |
| `is_jain` | boolean | Filter jain available |
| `is_fasting` | boolean | Filter fasting friendly |
| `is_bestseller` | boolean | Filter bestsellers |
| `min_price` | number | Minimum price filter |
| `max_price` | number | Maximum price filter |
| `min_rating` | number | Minimum rating filter |
| `sort_by` | string | `price`, `rating`, `name`, `created_at` |
| `page` | integer | Page number |
| `limit` | integer | Items per page |

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "880e8400-e29b-41d4-a716-446655440003",
        "category_id": "770e8400-e29b-41d4-a716-446655440002",
        "name": "Gujarati Thali",
        "description": "Traditional unlimited Gujarati thali...",
        "price": 250.00,
        "original_price": 300.00,
        "image_urls": ["https://res.cloudinary.com/parabdi/..."],
        "video_url": null,
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
        "created_at": "2026-08-01T10:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 45, "totalPages": 3 }
  }
}
```

---

### 4.2 GET `/foods/:id`

Public — fetches a single food item with customization groups.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "880e8400-e29b-41d4-a716-446655440003",
    "name": "Gujarati Thali",
    "description": "Traditional unlimited Gujarati thali...",
    "price": 250.00,
    "original_price": 300.00,
    "image_urls": ["https://..."],
    "video_url": "https://...",
    "calories": 650,
    "preparation_time_minutes": 25,
    "is_veg": true,
    "is_jain_available": true,
    "is_fasting_friendly": false,
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
          { "id": "aa0e8400-...", "name": "Full", "additional_price": 0.00, "is_active": true },
          { "id": "bb0e8400-...", "name": "Half", "additional_price": -100.00, "is_active": true }
        ]
      },
      {
        "id": "cc0e8400-...",
        "name": "Add-ons",
        "min_selections": 0,
        "max_selections": 5,
        "items": [
          { "id": "dd0e8400-...", "name": "Extra Ghee", "additional_price": 20.00, "is_active": true },
          { "id": "ee0e8400-...", "name": "Extra Roti", "additional_price": 15.00, "is_active": true }
        ]
      }
    ],
    "created_at": "2026-08-01T10:00:00.000Z"
  }
}
```

---

### 4.3 POST `/admin/foods` 🔒_admin

Creates a new food item. Accepts `multipart/form-data`.

**Fields:**
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | Yes | Food name |
| `description` | string | No | Description |
| `category_id` | UUID | Yes | Category ID |
| `price` | number | Yes | Selling price |
| `original_price` | number | No | Original/strikethrough price |
| `calories` | integer | No | Calorie count |
| `preparation_time_minutes` | integer | No | Prep time (default 20) |
| `is_veg` | boolean | No | Default true |
| `is_jain_available` | boolean | No | Default false |
| `is_fasting_friendly` | boolean | No | Default false |
| `is_bestseller` | boolean | No | Default false |
| `is_healthy_pick` | boolean | No | Default false |
| `images` | file[] | No | Up to 5 images (JPEG/PNG/WebP, max 5MB each) |
| `video` | file | No | Video file (MP4/WebM, max 50MB) |
| `customizations` | JSON string | No | Customization groups JSON |

**Response (201):** Created food item object.

---

### 4.4 PATCH `/admin/foods/:id` 🔒_admin

Updates a food item. Accepts `multipart/form-data` or JSON.

**Response (200):** Updated food item object.

---

### 4.5 DELETE `/admin/foods/:id` 🔒_admin

Soft-deletes (sets `is_active = false` and `deleted_at`).

---

### 4.6 PATCH `/chef/foods/:id/stock` 🔒_chef

Toggles food item stock status.

**Request:**
```json
{
  "is_active": false
}
```

---

## 5. Cart Module (`/api/v1/cart`) 🔒

All cart endpoints require customer authentication.

### 5.1 GET `/cart`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "cart-uuid-001",
    "user_id": "550e8400-...",
    "items": [
      {
        "id": "ci-uuid-001",
        "food_item": {
          "id": "880e8400-...",
          "name": "Gujarati Thali",
          "price": 250.00,
          "image_urls": ["https://..."],
          "is_veg": true
        },
        "quantity": 2,
        "customization_items": [
          { "customization_item_id": "ff0e8400-...", "name": "Mild", "additional_price": 0.00 }
        ],
        "special_instructions": "Extra spicy",
        "unit_price": 250.00,
        "total_price": 500.00
      }
    ],
    "subtotal": 500.00,
    "item_count": 2,
    "updated_at": "2026-08-21T10:00:00.000Z"
  }
}
```

---

### 5.2 POST `/cart/items`

**Request:**
```json
{
  "food_item_id": "880e8400-e29b-41d4-a716-446655440003",
  "quantity": 2,
  "customization_items": [
    { "customization_item_id": "ff0e8400-...", "name": "Mild", "additional_price": 0.00 },
    { "customization_item_id": "dd0e8400-...", "name": "Extra Ghee", "additional_price": 20.00 }
  ],
  "special_instructions": "Extra spicy please"
}
```

**Response (201):** Updated cart object with new item.

**Errors:**
- 400 `ITEM_OUT_OF_STOCK`: Food item is inactive
- 400 `VALIDATION_ERROR`: Missing food_item_id or invalid quantity

---

### 5.3 PATCH `/cart/items/:id`

**Request:**
```json
{
  "quantity": 3
}
```

**Response (200):** Updated cart object.

---

### 5.4 DELETE `/cart/items/:id`

**Response (200):** Updated cart object without the removed item.

---

### 5.5 DELETE `/cart`

Empties the entire cart.

**Response (200):**
```json
{
  "success": true,
  "data": { "message": "Cart cleared" }
}
```

---

### 5.6 POST `/cart/apply-coupon`

**Request:**
```json
{
  "code": "HEALTH20"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "coupon": {
      "id": "coupon-uuid-001",
      "code": "HEALTH20",
      "discount_type": "percentage",
      "discount_value": 20.00,
      "max_discount_value": 100.00
    },
    "discount_amount": 100.00,
    "new_subtotal": 400.00,
    "message": "Coupon applied! You saved ₹100.00"
  }
}
```

**Errors:**
- 400 `COUPON_INVALID`: Code doesn't exist
- 400 `COUPON_EXPIRED`: Past expiry date
- 400 `COUPON_MIN_ORDER`: Order below minimum value
- 400 `COUPON_MAX_USES`: Usage limit reached
- 400 `COUPON_FIRST_ORDER_ONLY`: Only for first orders

---

### 5.7 DELETE `/cart/coupon`

Removes the applied coupon.

---

## 6. Orders Module (`/api/v1/orders`)

### 6.1 POST `/orders` 🔒_customer

Places a new order. Backend recalculates all prices server-side.

**Request:**
```json
{
  "address_id": "660e8400-e29b-41d4-a716-446655440001",
  "delivery_slot": "12:30 PM - 1:00 PM",
  "payment_method": "upi",
  "special_instructions": "Ring doorbell twice",
  "coupon_code": "HEALTH20"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order-uuid-001",
      "status": "placed",
      "payment_method": "upi",
      "payment_status": "pending",
      "item_total": 500.00,
      "tax_amount": 25.00,
      "delivery_fee": 0.00,
      "platform_fee": 2.00,
      "discount_amount": 100.00,
      "grand_total": 427.00,
      "delivery_slot": "12:30 PM - 1:00 PM",
      "otp_code": "482916",
      "created_at": "2026-08-21T10:00:00.000Z"
    },
    "payment": {
      "razorpay_order_id": "order_RZP123456789",
      "amount": 42700,
      "currency": "INR",
      "key": "rzp_test_xxxx"
    }
  }
}
```

**Errors:**
- 400 `ADDRESS_OUT_OF_RANGE`: Address outside delivery radius
- 400 `KITCHEN_CLOSED`: Kitchen not accepting orders
- 400 `MIN_ORDER_NOT_MET`: Below minimum order value
- 400 `ITEM_OUT_OF_STOCK`: One or more items unavailable

---

### 6.2 GET `/orders` 🔒_customer

Lists current user's orders (paginated).

**Query Parameters:** `page`, `limit`, `status` (filter by status)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "order-uuid-001",
        "status": "preparing",
        "payment_method": "upi",
        "payment_status": "paid",
        "item_total": 500.00,
        "tax_amount": 25.00,
        "delivery_fee": 0.00,
        "platform_fee": 2.00,
        "discount_amount": 100.00,
        "grand_total": 427.00,
        "delivery_slot": "12:30 PM - 1:00 PM",
        "items_summary": "2x Gujarati Thali",
        "item_count": 2,
        "created_at": "2026-08-21T10:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 15, "totalPages": 1 }
  }
}
```

---

### 6.3 GET `/orders/:id` 🔒_customer

**Response (200):** Full order detail (see DATA_MODELS.md Order schema).

---

### 6.4 POST `/orders/:id/cancel` 🔒_customer

Cancels an order (only if status is `placed` or `confirmed`).

**Response (200):**
```json
{
  "success": true,
  "data": {
    "order": { "id": "order-uuid-001", "status": "cancelled" },
    "refund": {
      "amount": 427.00,
      "method": "wallet",
      "message": "Refund credited to wallet"
    }
  }
}
```

**Errors:**
- 400 `ORDER_CANNOT_CANCEL`: Order already being prepared

---

### 6.5 POST `/orders/:id/reorder` 🔒_customer

Loads historical order items back into the active cart.

**Response (200):** Updated cart object.

---

### 6.6 GET `/admin/orders` 🔒_admin

Lists all orders with filters.

**Query Parameters:** `status`, `date_from`, `date_to`, `search` (order ID/customer name), `page`, `limit`

---

## 7. Chef Endpoints (`/api/v1/chef`) 🔒_chef

### 7.1 GET `/chef/orders`

Lists orders assigned to this chef.

**Query Parameters:** `status` (placed, confirmed, preparing, ready)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "order-uuid-001",
        "status": "placed",
        "items": [
          {
            "id": "oi-uuid-001",
            "food_item": { "id": "...", "name": "Gujarati Thali" },
            "quantity": 2,
            "customization_items": [
              { "name": "Mild", "price": 0.00 }
            ],
            "special_instructions": "Extra spicy"
          }
        ],
        "created_at": "2026-08-21T10:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 5, "totalPages": 1 }
  }
}
```

---

### 7.2 POST `/chef/orders/:id/accept` 🔒_chef

Chef accepts an order. Updates status from `placed` to `confirmed`.

**Response (200):**
```json
{
  "success": true,
  "data": { "id": "order-uuid-001", "status": "confirmed" }
}
```

---

### 7.3 POST `/chef/orders/:id/reject` 🔒_chef

Chef rejects an order. Triggers refund.

**Request:**
```json
{
  "reason": "Out of ingredients"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": { "id": "order-uuid-001", "status": "rejected" }
}
```

---

### 7.4 POST `/chef/orders/:id/start` 🔒_chef

Marks order as `preparing`.

**Response (200):**
```json
{
  "success": true,
  "data": { "id": "order-uuid-001", "status": "preparing" }
}
```

---

### 7.5 POST `/chef/orders/:id/ready` 🔒_chef

Marks order as `ready` for pickup.

**Response (200):**
```json
{
  "success": true,
  "data": { "id": "order-uuid-001", "status": "ready" }
}
```

---

### 7.6 GET `/chef/dashboard` 🔒_chef

Returns today's chef statistics.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "today_orders_accepted": 12,
    "today_orders_completed": 8,
    "avg_cooking_time_minutes": 18,
    "pending_orders": 4,
    "busy_hours": ["12:00-13:00", "13:00-14:00"]
  }
}
```

---

## 8. Payments Module (`/api/v1/payments`)

### 8.1 POST `/payments/create` 🔒_customer

Creates a Razorpay order for payment.

**Request:**
```json
{
  "order_id": "order-uuid-001"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "razorpay_order_id": "order_RZP123456789",
    "amount": 42700,
    "currency": "INR",
    "key": "rzp_test_xxxx"
  }
}
```

---

### 8.2 POST `/payments/verify` 🔒_customer

Verifies payment signature after Razorpay checkout.

**Request:**
```json
{
  "razorpay_order_id": "order_RZP123456789",
  "razorpay_payment_id": "pay_RZP123456789",
  "razorpay_signature": "xxxxx"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "order": {
      "id": "order-uuid-001",
      "status": "confirmed",
      "payment_status": "paid"
    },
    "message": "Payment verified successfully"
  }
}
```

---

### 8.3 POST `/payments/webhook`

Razorpay webhook endpoint (IP-whitelisted, no auth required).

**Headers:** `x-razorpay-signature: <signature>`

**Razorpay sends events:**
- `payment.captured` → Update order payment_status to `paid`, trigger `confirmed`
- `payment.failed` → Update order payment_status to `failed`

---

### 8.4 POST `/payments/refund` 🔒_admin

**Request:**
```json
{
  "order_id": "order-uuid-001",
  "amount": 427.00,
  "reason": "Chef rejected order"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "refund_id": "refund-uuid-001",
    "amount": 427.00,
    "status": "processed"
  }
}
```

---

## 9. Addresses Module (`/api/v1/addresses`) 🔒_customer

### 9.1 GET `/addresses`

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "660e8400-...",
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
  ]
}
```

---

### 9.2 POST `/addresses`

**Request:**
```json
{
  "label": "Office",
  "address_line1": "501, Corporate Tower, SG Highway",
  "address_line2": "Near Science City",
  "city": "Ahmedabad",
  "state": "Gujarat",
  "postal_code": "380060",
  "latitude": 23.0300,
  "longitude": 72.5100,
  "phone": "+919825079765",
  "is_default": false
}
```

**Response (201):** Created address object.

---

### 9.3 PATCH `/addresses/:id`

**Request:** Partial update of address fields.

**Response (200):** Updated address object.

---

### 9.4 DELETE `/addresses/:id`

**Response (200):**
```json
{
  "success": true,
  "data": { "message": "Address deleted" }
}
```

---

## 10. Subscriptions Module (`/api/v1/subscriptions`)

### 10.1 GET `/subscriptions/plans`

Public — lists available subscription plans.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "sub-uuid-001",
      "name": "Daily Lunch Plan",
      "description": "30-day lunch subscription...",
      "price": 4500.00,
      "duration_days": 30,
      "meals_count": 30,
      "meal_type": "lunch",
      "benefits": ["Free delivery", "Priority processing"],
      "is_active": true
    }
  ]
}
```

---

### 10.2 POST `/subscriptions/subscribe` 🔒_customer

**Request:**
```json
{
  "subscription_id": "sub-uuid-001",
  "payment_method": "upi"
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "subscription": {
      "id": "usub-uuid-001",
      "status": "active",
      "start_date": "2026-08-21",
      "end_date": "2026-09-20",
      "meals_remaining": 30
    },
    "payment": {
      "razorpay_order_id": "...",
      "amount": 450000,
      "currency": "INR",
      "key": "rzp_test_xxxx"
    }
  }
}
```

---

### 10.3 GET `/subscriptions/my` 🔒_customer

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "usub-uuid-001",
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
  ]
}
```

---

### 10.4 POST `/subscriptions/:id/pause` 🔒_customer

Pauses a subscription. No meals delivered until resumed.

**Response (200):**
```json
{
  "success": true,
  "data": { "id": "usub-uuid-001", "status": "paused" }
}
```

---

### 10.5 POST `/subscriptions/:id/resume` 🔒_customer

Resumes a paused subscription.

**Response (200):**
```json
{
  "success": true,
  "data": { "id": "usub-uuid-001", "status": "active" }
}
```

---

### 10.6 POST `/subscriptions/:id/skip` 🔒_customer

Skips the next meal delivery. Must be before cutoff time (9:00 AM).

**Request:**
```json
{
  "skip_date": "2026-08-25"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": "usub-uuid-001",
    "skip_dates": ["2026-08-25", "2026-08-28"],
    "meals_remaining": 17
  }
}
```

**Errors:**
- 400 `SUBSCRIPTION_CUTOFF_PASSED`: Past 9:00 AM cutoff

---

### 10.7 POST `/subscriptions/:id/cancel` 🔒_customer

Cancels a subscription. Refund for remaining meals.

---

## 11. Wishlist Module (`/api/v1/wishlist`) 🔒_customer

### 11.1 GET `/wishlist`

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "wishlist-uuid-001",
      "food_item": {
        "id": "880e8400-...",
        "name": "Gujarati Thali",
        "price": 250.00,
        "image_urls": ["https://..."],
        "rating": 4.75,
        "is_veg": true
      },
      "created_at": "2026-08-21T10:00:00.000Z"
    }
  ]
}
```

---

### 11.2 POST `/wishlist/:foodItemId`

**Response (201):**
```json
{
  "success": true,
  "data": { "message": "Added to wishlist" }
}
```

---

### 11.3 DELETE `/wishlist/:foodItemId`

**Response (200):**
```json
{
  "success": true,
  "data": { "message": "Removed from wishlist" }
}
```

---

## 12. Reviews Module (`/api/v1/reviews`)

### 12.1 GET `/foods/:foodItemId/reviews`

Public — lists approved reviews for a food item.

**Query Parameters:** `page`, `limit`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "review-uuid-001",
        "rating": 5,
        "comment": "Excellent thali! Authentic taste.",
        "images": [],
        "user": { "full_name": "Raj P." },
        "created_at": "2026-08-21T14:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 10, "total": 45, "totalPages": 5 }
  }
}
```

---

### 12.2 POST `/reviews` 🔒_customer

**Request:**
```json
{
  "food_item_id": "880e8400-...",
  "order_id": "order-uuid-001",
  "rating": 5,
  "comment": "Excellent thali!",
  "images": []
}
```

**Response (201):**
```json
{
  "success": true,
  "data": {
    "id": "review-uuid-001",
    "rating": 5,
    "comment": "Excellent thali!",
    "is_approved": false,
    "message": "Review submitted for moderation"
  }
}
```

---

## 13. Shorts Module (`/api/v1/shorts`)

### 13.1 GET `/shorts`

Public — paginated feed of food shorts.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "short-uuid-001",
        "video_url": "https://res.cloudinary.com/parabdi/video/...",
        "thumbnail_url": "https://res.cloudinary.com/parabdi/image/...",
        "caption": "Watch how we make our famous Thali!",
        "food_item_id": "880e8400-...",
        "category_id": "770e8400-...",
        "likes_count": 245,
        "views_count": 1820,
        "is_liked_by_user": false,
        "is_saved_by_user": false,
        "created_at": "2026-08-20T10:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 10, "total": 50, "totalPages": 5 }
  }
}
```

---

### 13.2 POST `/shorts/:id/like` 🔒_customer

Toggles like. Returns current state.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "is_liked": true,
    "likes_count": 246
  }
}
```

---

### 13.3 POST `/shorts/:id/save` 🔒_customer

Toggles save to favorites.

**Response (200):**
```json
{
  "success": true,
  "data": { "is_saved": true }
}
```

---

### 13.4 POST `/admin/shorts` 🔒_admin

Uploads a new food short. Accepts `multipart/form-data`.

**Fields:** `video` (file), `thumbnail` (file), `caption` (string), `food_item_id` (UUID, optional), `category_id` (UUID, optional)

---

## 14. Banners Module (`/api/v1/banners`)

### 14.1 GET `/banners`

Public — active banners for home feed.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "banner-uuid-001",
      "title": "Flat 20% Off on Thalis",
      "subtitle": "Use code HEALTH20",
      "image_url": "https://res.cloudinary.com/parabdi/image/...",
      "click_action": "food",
      "action_value": "880e8400-..."
    }
  ]
}
```

---

## 15. Coupons Module

### 15.1 GET `/admin/coupons` 🔒_admin

Lists all coupons with usage stats.

### 15.2 POST `/admin/coupons` 🔒_admin

**Request:**
```json
{
  "code": "HEALTH20",
  "description": "20% off on orders above ₹200",
  "discount_type": "percentage",
  "discount_value": 20.00,
  "min_order_value": 200.00,
  "max_discount_value": 100.00,
  "max_uses": 1000,
  "max_uses_per_user": 1,
  "is_first_order_only": false,
  "expires_at": "2026-12-31T23:59:59.000Z"
}
```

### 15.3 PATCH `/admin/coupons/:id` 🔒_admin
### 15.4 DELETE `/admin/coupons/:id` 🔒_admin

---

## 16. Notifications Module

### 16.1 GET `/notifications` 🔒_customer

**Query Parameters:** `page`, `limit`, `is_read` (boolean filter)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "notif-uuid-001",
        "title": "Order Confirmed!",
        "body": "Your order #ORD-001 has been confirmed.",
        "type": "order_update",
        "reference_id": "order-uuid-001",
        "is_read": false,
        "created_at": "2026-08-21T10:05:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 25, "totalPages": 2 },
    "unread_count": 5
  }
}
```

---

### 16.2 PATCH `/notifications/:id/read` 🔒_customer

Marks a single notification as read.

### 16.3 PATCH `/notifications/read-all` 🔒_customer

Marks all notifications as read.

---

## 17. Delivery Slots Module

### 17.1 GET `/delivery-slots`

Public — available delivery time slots.

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": "slot-uuid-001",
      "name": "12:00 PM - 12:30 PM",
      "start_time": "12:00",
      "end_time": "12:30",
      "max_orders": 10,
      "is_active": true
    }
  ]
}
```

---

## 18. Wallet Module

### 18.1 GET `/wallet/transactions` 🔒_customer

Returns wallet transaction history.

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "tx-uuid-001",
        "type": "credit",
        "amount": 100.00,
        "description": "Refund for order #ORD-001",
        "reference_order_id": "order-uuid-001",
        "created_at": "2026-08-21T14:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 8, "totalPages": 1 }
  }
}
```

---

## 19. Admin Settings Module

### 19.1 GET `/admin/settings` 🔒_admin

**Response (200):**
```json
{
  "success": true,
  "data": [
    { "key": "kitchen_latitude", "value": "23.0225", "value_type": "number", "description": "Kitchen GPS latitude" },
    { "key": "kitchen_longitude", "value": "72.5714", "value_type": "number", "description": "Kitchen GPS longitude" },
    { "key": "delivery_radius_km", "value": "5", "value_type": "number", "description": "Maximum delivery radius in km" },
    { "key": "minimum_order_value", "value": "100", "value_type": "number", "description": "Minimum order value" },
    { "key": "platform_fee", "value": "2", "value_type": "number", "description": "Platform fee per order" },
    { "key": "gst_rate", "value": "5", "value_type": "number", "description": "GST rate percentage" },
    { "key": "free_delivery_above", "value": "200", "value_type": "number", "description": "Free delivery threshold" },
    { "key": "maintenance_mode", "value": "false", "value_type": "boolean", "description": "Maintenance mode toggle" }
  ]
}
```

### 19.2 PATCH `/admin/settings` 🔒_admin

**Request:**
```json
{
  "settings": [
    { "key": "delivery_radius_km", "value": "7" },
    { "key": "maintenance_mode", "value": "true" }
  ]
}
```

---

## 20. Admin Upload Module

### 20.1 POST `/upload/presigned-url` 🔒_admin

Generates a Cloudinary presigned URL for direct upload.

**Request:**
```json
{
  "folder": "foods",
  "file_type": "image/jpeg"
}
```

**Response (200):**
```json
{
  "success": true,
  "data": {
    "upload_url": "https://api.cloudinary.com/v1_1/parabdi/image/upload?...",
    "asset_url": "https://res.cloudinary.com/parabdi/image/upload/v1/...",
    "expires_at": "2026-08-21T10:05:00.000Z"
  }
}
```

---

## 21. Admin Users & Staff Module

### 21.1 GET `/admin/users` 🔒_admin

Lists all users with filters.

**Query Parameters:** `role` (customer/chef/delivery/admin), `search` (name/phone), `is_blocked`, `page`, `limit`

### 21.2 PATCH `/admin/users/:id/block` 🔒_admin

**Request:**
```json
{
  "is_blocked": true,
  "reason": "Violation of terms"
}
```

### 21.3 PATCH `/admin/users/:id/wallet` 🔒_admin

Credits/debits wallet.

**Request:**
```json
{
  "type": "credit",
  "amount": 100.00,
  "description": "Goodwill credit"
}
```

---

## 22. Admin Reports Module

### 22.1 GET `/admin/reports/revenue` 🔒_admin

**Query Parameters:** `date_from`, `date_to`, `group_by` (day/week/month)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "summary": {
      "total_revenue": 125000.00,
      "total_orders": 450,
      "avg_order_value": 277.78,
      "total_customers": 180
    },
    "chart_data": [
      { "date": "2026-08-01", "revenue": 4200.00, "orders": 15 },
      { "date": "2026-08-02", "revenue": 3800.00, "orders": 12 }
    ]
  }
}
```

### 22.2 GET `/admin/reports/orders` 🔒_admin

Returns order analytics (by status, by category, by time).

### 22.3 GET `/admin/reports/export` 🔒_admin

**Query Parameters:** `type` (revenue/orders/customers), `format` (csv/xlsx), `date_from`, `date_to`

Returns file download.

---

## 23. Admin Audit Logs

### 23.1 GET `/admin/audit-logs` 🔒_admin

**Query Parameters:** `admin_id`, `action`, `entity`, `date_from`, `date_to`, `page`, `limit`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "audit-uuid-001",
        "admin_id": "admin-uuid-001",
        "admin_name": "Admin User",
        "action": "price_change",
        "entity": "food_items",
        "entity_id": "880e8400-...",
        "old_value": { "price": 250.00 },
        "new_value": { "price": 275.00 },
        "ip_address": "192.168.1.100",
        "created_at": "2026-08-21T10:00:00.000Z"
      }
    ],
    "meta": { "page": 1, "limit": 20, "total": 150, "totalPages": 8 }
  }
}
```

---

## 24. WebSocket (Socket.IO) Events

### 24.1 Connection

```typescript
// Client connects with JWT in handshake
const socket = io('https://api.parabdikitchen.com', {
  auth: { token: jwtAccessToken },
  transports: ['websocket'],
});
```

### 24.2 Client Events (→ Server)

| Event | Payload | Description |
|-------|---------|-------------|
| `join_order_room` | `{ "order_id": "uuid" }` | Subscribe to order updates |
| `leave_order_room` | `{ "order_id": "uuid" }` | Unsubscribe from order updates |

### 24.3 Server Events (→ Client)

| Event | Payload | Description |
|-------|---------|-------------|
| `order_status_update` | `{ "order_id": "uuid", "status": "preparing", "timestamp": "ISO8601" }` | Order status changed |
| `new_order_alert` | `{ "order_id": "uuid", "items_count": 2, "created_at": "ISO8601" }` | New order for chef |
| `rider_location_broadcast` | `{ "order_id": "uuid", "latitude": 23.02, "longitude": 72.57 }` | GPS update (future) |

### 24.4 Room Rules

- **Customer:** Can only join rooms for their own orders
- **Chef:** Can only join rooms for orders assigned to them
- **Admin:** Can join all order rooms
