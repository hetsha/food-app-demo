# Phase 5: Cart & Checkout — Tracking Document

**Status:** ✅ COMPLETE (16/16 tasks done)
**Depends On:** Phase 3 (Menu), Phase 2 (Auth)
**Estimated Hours:** 30h

---

## Tasks Checklist

### 5.1 Backend Cart
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.1.1 | Create cart.module.ts | ✅ DONE | Already existed |
| 5.1.2 | Create cart.service.ts | ✅ DONE | getCart, addItem, updateItem, removeItem, clearCart, validateCart |
| 5.1.3 | Create cart.controller.ts | ✅ DONE | All cart endpoints + validate endpoint |
| 5.1.4 | Implement server-side price verification | ✅ DONE | getCart recalculates prices from DB, validateCart computes totals |

### 5.2 Backend Coupons
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.2.1 | Create coupons.service.ts | ✅ DONE | Applied in orders.service.ts during order creation |
| 5.2.2 | Implement coupon validation rules | ✅ DONE | Expiry, active check, percentage/flat discount, max discount cap |

### 5.3 Backend Orders
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.3.1 | Create orders.module.ts | ✅ DONE | Already existed |
| 5.3.2 | Create orders.service.ts | ✅ DONE | create, findAll, findOne, cancel, reorder with validations |
| 5.3.3 | Create orders.controller.ts | ✅ DONE | All order endpoints |
| 5.3.4 | Implement order status transitions | ✅ DONE | Cancel validates status is placed/confirmed |
| 5.3.5 | Implement order status history | ✅ DONE | Created on cancel |

### 5.4 Flutter Cart Integration
| # | Task | Status | Notes |
|---|------|--------|-------|
| 5.4.1 | Create Cart/CartItem models (freezed) | ✅ DONE | Cart, CartItem, CartFoodItem, SelectedCustomization |
| 5.4.2 | Create cart_repository.dart | ✅ DONE | API calls for all cart operations |
| 5.4.3 | Refactor cart_provider.dart to use API | ✅ DONE | Replaced mock with real API, added loading/error states |
| 5.4.4 | Connect cart_screen.dart to API | ✅ DONE | Real cart data, unavailable item handling |
| 5.4.5 | Connect checkout_screen.dart to API | ✅ DONE | Address selection, order creation, payment method |

---

## Summary

| Category | Done | Total | Progress |
|----------|------|-------|----------|
| Backend Cart | 4 | 4 | 100% |
| Backend Coupons | 2 | 2 | 100% |
| Backend Orders | 5 | 5 | 100% |
| Flutter Cart | 5 | 5 | 100% |
| **TOTAL** | **16** | **16** | **100%** |

---

## APIs Created/Changed

### Cart Endpoints
| Endpoint | Method | Description | Status |
|----------|--------|-------------|--------|
| `/cart` | GET | Get current user cart with items, prices, availability | ✅ Enhanced |
| `/cart/items` | POST | Add item (validates food exists, is active, is veg) | ✅ Enhanced |
| `/cart/items/:id` | PATCH | Update quantity (validates ownership) | ✅ Enhanced |
| `/cart/items/:id` | DELETE | Remove item (validates ownership) | ✅ Enhanced |
| `/cart` | DELETE | Clear cart | ✅ Enhanced |
| `/cart/validate` | POST | Validate cart for checkout | ✅ New |

### Order Endpoints
| Endpoint | Method | Description | Status |
|----------|--------|-------------|--------|
| `/orders` | POST | Create order from cart (validates items, min order, address) | ✅ Enhanced |
| `/orders` | GET | List user orders | ✅ Existing |
| `/orders/:id` | GET | Get order detail | ✅ Existing |
| `/orders/:id/cancel` | POST | Cancel order (validates ownership, status) | ✅ Existing |
| `/orders/:id/reorder` | POST | Reorder (validates food availability) | ✅ Enhanced |

---

## Flutter Files Created/Changed

| File | Status |
|------|--------|
| `lib/features/cart/data/models/selected_customization.dart` | ✅ New |
| `lib/features/cart/data/models/cart.dart` | ✅ New |
| `lib/features/cart/data/repositories/cart_repository.dart` | ✅ New |
| `lib/features/cart/presentation/cart_provider.dart` | ✅ Replaced |
| `lib/features/cart/presentation/cart_screen.dart` | ✅ Replaced |
| `lib/features/checkout/data/repositories/checkout_repository.dart` | ✅ New |
| `lib/features/checkout/presentation/checkout_screen.dart` | ✅ Replaced |
| `lib/features/menu/presentation/meal_detail_screen.dart` | ✅ Updated |
| `lib/features/menu/presentation/menu_tab.dart` | ✅ Updated |

---

## Database Changes
- **No schema changes** — existing tables sufficient

---

## Security Checks
- ✅ All cart endpoints require JWT authentication
- ✅ Cart ownership validated (user can only access their own cart)
- ✅ Food item existence validated before adding to cart
- ✅ Food item `isActive` and `deletedAt` checked before adding
- ✅ Customization items validated against valid options
- ✅ Prices recalculated from server-side data (never trusted from client)
- ✅ Minimum order value enforced (₹100)
- ✅ Address ownership validated during order creation
- ✅ Food availability validated during order creation
- ✅ Cart ownership validated during update/remove

---

## Business Rules Implemented
| Rule | Source | Status |
|------|--------|--------|
| Minimum order ₹100 | SRS Section 4A | ✅ |
| Delivery fee ₹30, free above ₹200 | SRS Section 4A | ✅ |
| GST 5% on item total | SRS Section 9 | ✅ |
| Platform fee ₹2 | SRS Section 4A | ✅ |
| Cart item unavailable → block checkout | SRS Section 8A | ✅ |
| All items out of stock → block checkout | SRS Section 8A | ✅ |
| Only ONE coupon per order | SRS Section 8A | ✅ |
| Server-side price recalculation | Phase 5 spec | ✅ |
| Pure veg enforcement (isVeg check) | AGENTS.md | ✅ |
