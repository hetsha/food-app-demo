# FEATURES.md - Feature Catalog & Verification Checklist

This document details the functional and non-functional features of **Parabdi**, complete with user stories, acceptance criteria, priority tags, API endpoint mappings, and verification checklists.

---

## Priority Levels

| Priority | Label | Description |
|----------|-------|-------------|
| **P0** | MVP Critical | Must be implemented for first launch |
| **P1** | Important | Should be in MVP, can be deferred if needed |
| **P2** | Nice to Have | Post-MVP feature, low urgency |

---

## 1. Core Customer Features

### 1.1 Authentication & Login — P0
* **User Story:** As a customer, I want to sign in securely using my mobile number and OTP or Google Login so that my profile details, saved addresses, and active orders are stored securely.
* **API Endpoints:** `POST /auth/send-otp`, `POST /auth/verify-otp`, `POST /auth/google`, `POST /auth/refresh`, `GET /auth/me`
* **Acceptance Criteria:**
  * System validates 10-digit Indian phone numbers (+91 prefix).
  * OTP code is exactly 6 digits with 5-minute expiry.
  * JWT tokens are generated upon successful login (15min access, 7d refresh).
  * Guest users can browse menu items but cannot access checkout, cart, subscription, or profile endpoints.
  * Refresh token rotation: old token invalidated on use.
* **Verification Checklist:**
  * [ ] Verify that invalid phone inputs (e.g., less than 10 digits) throw validation errors.
  * [ ] Verify that entering incorrect OTP displays a visible error message.
  * [ ] Verify that expired OTP returns `OTP_EXPIRED` error.
  * [ ] Verify that guest actions are blocked from Cart, Checkout, Orders, Subscriptions APIs.
  * [ ] Verify that refresh token rotation invalidates old token.
  * [ ] Verify rate limiting: max 3 OTP requests per phone per 10 minutes.

### 1.2 Geofenced Address Management & Serviceability — P0
* **User Story:** As a customer, I want to select my coordinates on a map and check serviceability so that I know if the kitchen can deliver to my location.
* **API Endpoints:** `GET /addresses`, `POST /addresses`, `PATCH /addresses/:id`, `DELETE /addresses/:id`, `POST /places/search` (backend Google Places)
* **Acceptance Criteria:**
  * GPS auto-detection using `geolocator` package.
  * Address search calls backend `POST /places/search` (Google Places API server-side).
  * Geofence checks latitude/longitude against kitchen coordinates + delivery radius (Haversine formula).
  * Non-serviceable addresses display: "Parabdi is currently unavailable in your area."
  * Max 10 addresses per user.
  * Each address stores: label, address lines, city, state, pincode, lat/lng, phone, is_default.
* **Verification Checklist:**
  * [ ] Verify GPS auto-detection retrieves latitude and longitude.
  * [ ] Verify address search returns autocomplete suggestions from backend.
  * [ ] Verify that addresses outside the geofence block checkout with "Out of Delivery Radius".
  * [ ] Verify max 10 addresses enforced.
  * [ ] Verify default address toggle works correctly.

### 1.3 Customer Home & Menu Exploration — P0
* **User Story:** As a vegetarian diner, I want to browse banners, search dishes, and filter by category or dietary requirements (Veg, Jain, Fasting) to find meals matching my taste.
* **API Endpoints:** `GET /categories`, `GET /foods`, `GET /foods/:id`, `GET /banners`, `GET /delivery-slots`
* **Acceptance Criteria:**
  * Homepage shows location, search bar, banner slides, categories, and today's specials.
  * Default interface is Pure Veg. Jain/Fasting controls filter menu database queries.
  * Menu displays name, description, category, price, discount, serving size, preparation time, and rating.
  * Search works across food names and descriptions.
  * Filters: category, veg/jain/fasting, price range, rating, sort (popularity/price/rating).
  * Pagination on food list (20 items per page).
* **Verification Checklist:**
  * [ ] Verify that clicking "Jain Only" filter removes all non-Jain items.
  * [ ] Verify search bar finds matching food titles and descriptions.
  * [ ] Verify pagination loads more items on scroll.
  * [ ] Verify banners display correctly and click actions navigate properly.

### 1.4 Interactive Food Customization & Sizing — P0
* **User Story:** As a customer, I want to select spice levels, sizing (Half/Full), and add-ons dynamically before adding items to the cart.
* **API Endpoints:** `GET /foods/:id` (includes customization groups)
* **Acceptance Criteria:**
  * Customizations are fetched dynamically from backend customization groups (not hard-coded).
  * Price adjustments add to item total in real-time.
  * Custom instructions (text notes) saved alongside selection snapshots.
  * Min/max selection rules enforced (e.g., exactly 1 portion size, max 5 add-ons).
* **Verification Checklist:**
  * [ ] Verify selecting "Extra Roti" (+₹15) updates product subtotal instantly.
  * [ ] Verify that customizations are stored as JSONB in cart_items.
  * [ ] Verify min/max selection constraints are enforced.

### 1.5 Food Shorts (Video Feed) — P1
* **User Story:** As a customer, I want to watch vertical short videos of food preparations so that I can directly order dishes featured in the video.
* **API Endpoints:** `GET /shorts`, `POST /shorts/:id/like`, `POST /shorts/:id/save`
* **Acceptance Criteria:**
  * Vertical scrollable feed of compressed food videos.
  * Auto-play on viewport entry, pause on exit.
  * Like (heart toggle), save (bookmark toggle), share.
  * "Order Now" button navigates to associated food item detail.
  * Paginated feed (10 items per page).
* **Verification Checklist:**
  * [ ] Verify scrolling plays next video and pauses previous.
  * [ ] Verify "Order Now" loads correct dish with customization options.
  * [ ] Verify like toggle updates count correctly.
  * [ ] Verify duplicate likes are prevented (unique constraint).

### 1.6 Cart & Checkout Calculations — P0
* **User Story:** As a customer, I want to review item quantities, input delivery timeslots, apply coupons, and see a transparent fee breakdown.
* **API Endpoints:** `GET /cart`, `POST /cart/items`, `PATCH /cart/items/:id`, `DELETE /cart/items/:id`, `DELETE /cart`, `POST /cart/apply-coupon`, `DELETE /cart/coupon`
* **Acceptance Criteria:**
  * Quantity can be incremented or decremented.
  * Cart prices, delivery charges, taxes (5% GST), platform fee (₹2), and discounts calculated and verified by backend.
  * **IMPORTANT: Cart totals calculated server-side. Never trust client-sent amounts.**
  * Only ONE coupon per order.
  * Coupon validation: expiry, min order, max uses, first-order-only.
  * Delivery slot selection required before checkout.
* **Verification Checklist:**
  * [ ] Verify changing quantities recalculates totals correctly.
  * [ ] Verify modifying cart payload on client does not bypass backend verification.
  * [ ] Verify expired coupon returns error.
  * [ ] Verify coupon discount capped at order total (cannot go below ₹0).

### 1.7 Cashless Payments (Razorpay) — P0
* **User Story:** As a customer, I want to make payments using UPI, Card, or Net Banking and receive instant verification.
* **API Endpoints:** `POST /payments/create`, `POST /payments/verify`, `POST /payments/webhook`
* **Acceptance Criteria:**
  * Razorpay SDK generates payment sheet on Flutter.
  * Backend creates Razorpay order and returns order_id + amount + currency.
  * Backend verifies payment signature server-side (HMAC SHA256).
  * **NEVER mark order as paid based on frontend response alone.**
  * Webhook handles `payment.captured` and `payment.failed` events.
  * Wallet balance can be used as payment method (split payment).
* **Verification Checklist:**
  * [ ] Verify mock/failed Razorpay responses reject order placement on server.
  * [ ] Verify successful webhook updates database payment_status to `paid`.
  * [ ] Verify payment signature verification rejects tampered payloads.

### 1.8 Order Creation & Status Transitions — P0
* **User Story:** As a customer, I want to see my order transition from Placed to Delivered in real-time.
* **API Endpoints:** `POST /orders`, `GET /orders`, `GET /orders/:id`, `POST /orders/:id/cancel`, `POST /orders/:id/reorder`
* **Acceptance Criteria:**
  * Order creates pricing and customization snapshots (price changes later don't corrupt history).
  * MVP Status Sequence: `placed → confirmed → preparing → ready → delivered`
  * Transitions strictly controlled by backend checks.
  * Order status history recorded in `order_status_history` table.
  * Reorder loads historical items back into cart, re-validating availability and pricing.
* **Verification Checklist:**
  * [ ] Verify database order item snapshots store actual price at checkout time.
  * [ ] Verify invalid status updates (e.g., `placed` → `delivered`) are rejected.
  * [ ] Verify reorder filters out unavailable items with notification.
  * [ ] Verify cancellation blocked after chef confirms.

### 1.9 Meal Subscription Plans — P1
* **User Story:** As a customer, I want to subscribe to daily/weekly meal packages and manage daily delivery skips.
* **API Endpoints:** `GET /subscriptions/plans`, `POST /subscriptions/subscribe`, `GET /subscriptions/my`, `POST /subscriptions/:id/pause`, `POST /subscriptions/:id/resume`, `POST /subscriptions/:id/skip`, `POST /subscriptions/:id/cancel`
* **Acceptance Criteria:**
  * Users select weekly (7-day) or monthly (30-day) meal plans.
  * Pause, resume, or skip tomorrow's meal before 9:00 AM cutoff.
  * Calendar view shows delivery days and skip dates.
  * Remaining meals counter displayed.
  * Only 1 active subscription per meal type per user.
  * Cancellation triggers pro-rated wallet refund.
* **Verification Checklist:**
  * [ ] Verify pausing prevents order creation for subsequent dates.
  * [ ] Verify skipping increments remaining count and moves delivery date.
  * [ ] Verify skip after 9 AM cutoff is blocked.
  * [ ] Verify duplicate subscription same meal type is blocked.

### 1.10 Coupons & Offers — P1
* **User Story:** As a user, I want to apply promotional coupon codes to get discounts on my checkout total.
* **API Endpoints:** `POST /cart/apply-coupon`, `DELETE /cart/coupon`
* **Acceptance Criteria:**
  * Coupons validate expiry, min order, max discount, first-order-only, category rules.
  * Validation and recalculation performed on backend.
  * One coupon per order.
  * Coupon usage tracked in `coupon_usage` table.
* **Verification Checklist:**
  * [ ] Verify expired coupon throws validation error.
  * [ ] Verify first-time-only coupons rejected for returning customers.
  * [ ] Verify usage limit enforcement.

### 1.11 Wishlist & Reordering — P1
* **User Story:** As a customer, I want to save favorite items and quickly reorder past checkout baskets.
* **API Endpoints:** `GET /wishlist`, `POST /wishlist/:foodItemId`, `DELETE /wishlist/:foodItemId`, `POST /orders/:id/reorder`
* **Acceptance Criteria:**
  * Wishlist add/remove toggle.
  * Reorder replicates order basket, re-validating item availability and pricing.
  * Unavailable items filtered out with notification.
* **Verification Checklist:**
  * [ ] Verify reorder filters out out-of-stock items with notification.
  * [ ] Verify wishlist toggle works correctly (add/remove).

### 1.12 Reviews & Ratings — P1
* **User Story:** As a customer, I want to rate my delivered dishes and write reviews to share my experience.
* **API Endpoints:** `POST /reviews`, `GET /foods/:foodItemId/reviews`
* **Acceptance Criteria:**
  * Rating scale 1-5 stars with optional comments and images (max 5 images, 3MB each).
  * Reviews undergo admin moderation before appearing publicly.
  * One review per food item per order.
  * Review images stored on Cloudinary.
* **Verification Checklist:**
  * [ ] Verify rating submissions recalculate average dish score after admin approval.
  * [ ] Verify duplicate review for same food+order is blocked.
  * [ ] Verify review images are uploaded to Cloudinary.

### 1.13 Address CRUD — P0
* **User Story:** As a customer, I want to create, edit, and delete my saved addresses.
* **API Endpoints:** `GET /addresses`, `POST /addresses`, `PATCH /addresses/:id`, `DELETE /addresses/:id`
* **Acceptance Criteria:**
  * Full CRUD operations on addresses.
  * Set default address (unsets previous default).
  * Max 10 addresses per user.
  * Address used in active order retains snapshot (delete doesn't affect order).

### 1.14 Push Notifications — P1
* **User Story:** As a user, I want to receive push notifications for order updates, promotions, and subscriptions.
* **API Endpoints:** `GET /notifications`, `PATCH /notifications/:id/read`, `PATCH /notifications/read-all`, `POST /admin/notifications/send`
* **Acceptance Criteria:**
  * FCM token registered on login.
  * Notifications triggered by backend events.
  * Handles: OTP, order confirmations, status updates, subscription warnings, promotions.
  * In-app notification history with read/unread status.
  * Deep linking from notification to relevant screen.

### 1.15 Guest Mode — P0
* **User Story:** As a guest, I want to browse the menu without logging in.
* **Acceptance Criteria:**
  * Guest can: view home feed, browse menu, view food details, watch shorts.
  * Guest cannot: add to cart, checkout, view orders, manage profile, use subscriptions.
  * Guest sees login prompt when attempting restricted actions.

### 1.16 Offline/Cache Behavior — P2
* **User Story:** As a customer, I want the app to handle network loss gracefully.
* **Acceptance Criteria:**
  * Menu data cached locally (Hive).
  * Stale data displayed with "Offline — showing cached data" banner.
  * Auto-retry on network restoration.
  * Cart data persisted locally.
  * Auth tokens persisted in secure storage.

---

## 2. Logistics & Live Tracking

### 2.1 Live Courier Tracking — P2 (Post-MVP)
* **Status:** TEMPORARILY REMOVED from scope.
* **Future API Endpoints:** `GET /delivery/:id/tracking`, `POST /delivery/:id/location` (Socket.IO)

### 2.2 Notifications & Alerts — P1
* Covered in Feature 1.14 above.

---

## 3. Admin Management Capabilities — P0

### 3.1 Dashboard & Settings Management
* **API Endpoints:** `GET /admin/reports/revenue`, `GET /admin/reports/orders`, `GET /admin/settings`, `PATCH /admin/settings`

### 3.2 Food & Category Management
* **API Endpoints:** `POST /admin/categories`, `PATCH /admin/categories/:id`, `DELETE /admin/categories/:id`, `POST /admin/foods`, `PATCH /admin/foods/:id`, `DELETE /admin/foods/:id`

### 3.3 Staff Management
* **API Endpoints:** `POST /admin/chefs`, `PATCH /admin/chefs/:id`, `DELETE /admin/chefs/:id`, `GET /admin/users`, `PATCH /admin/users/:id/block`

### 3.4 Media & Promotions
* **API Endpoints:** `POST /admin/shorts`, `PATCH /admin/shorts/:id`, `DELETE /admin/shorts/:id`, `POST /admin/banners`, `PATCH /admin/banners/:id`, `DELETE /admin/banners/:id`, `POST /admin/coupons`, `PATCH /admin/coupons/:id`, `DELETE /admin/coupons/:id`

### 3.5 Orders & Payments
* **API Endpoints:** `GET /admin/orders`, `GET /payments/refund`, `GET /admin/payments`

### 3.6 Reports & Audit
* **API Endpoints:** `GET /admin/reports/export`, `GET /admin/audit-logs`

---

## 4. Non-Functional Features

### 4.1 Image & Video Optimization
* CDN delivery via Cloudinary.
* Lazy loading for list images.
* Prefetching for shorts videos.

### 4.2 Performance Requirements
* Target: Under 2 seconds initial app launch.
* Pagination on all list endpoints (20 items per page).
* Database indexes on foreign keys and status columns.

---

## 5. Testing & Verification

### 5.1 Critical E2E Order Flow Test
```
Customer Login → Select Location → Customize & Add to Cart → Razorpay Payment
→ Chef Accepts → Chef Marks Ready → Delivered → Customer Review
```

### 5.2 Admin Verification Test
```
Admin Login → Create Category & Food → Bind Customizations
→ Add Banner & Coupon → Assign Chef Profile → Run Reports
```

### 1.3 Customer Home & Menu Exploration
* **User Story:** As a vegetarian diner, I want to browse banners, search dishes, and filter by category or dietary requirements (Veg, Jain, Fasting) to find meals matching my taste.
* **Acceptance Criteria:**
  * Homepage shows location, search bar, banner slides, categories, and today's specials.
  * Default interface is Pure Veg. Jain/Fasting controls filter menu database queries.
  * Menu displays name, description, category, price, discount, serving size, preparation time, and rating.
* **Verification Checklist:**
  * [ ] Verify that clicking the "Jain Only" filter removes all standard items that don't have Jain preparation options.
  * [ ] Verify that search bar query finds matching food titles and category matches.

### 1.4 Interactive Food Customization & Sizing
* **User Story:** As a customer, I want to select spice levels, sizing (Half/Full), and add-ons dynamically before adding items to the cart.
* **Acceptance Criteria:**
  * Customizations are not hard-coded in the app; they are fetched dynamically from database customization groups.
  * Price adjustments add to the item total in real-time.
  * Custom instructions (text notes) are saved alongside selection snapshots.
* **Verification Checklist:**
  * [ ] Verify selecting "Extra Roti" (+₹15) updates the product subtotal instantly.
  * [ ] Verify that customizations are successfully stored as a JSON object on backend order records.

### 1.5 Food Shorts (Video Feed)
* **User Story:** As a customer, I want to watch vertical short videos of food preparations so that I can directly order dishes featured in the video.
* **Acceptance Criteria:**
  * Vertical scrollable feed of compressed food videos.
  * Features auto-play, likes, saves, and shares.
  * "Order Now" button navigates directly to the associated food item detail screen.
* **Verification Checklist:**
  * [ ] Verify that scrolling plays the next video and pauses the previous video.
  * [ ] Verify "Order Now" loads the correct dish with customization options.

### 1.6 Cart & Checkout Calculations
* **User Story:** As a customer, I want to review item quantities, input delivery timeslots, apply coupons, and see a transparent fee breakdown.
* **Acceptance Criteria:**
  * Quantity can be incremented or decremented.
  * Cart prices, delivery charges, taxes (5% GST), platform fee (₹2), and discounts are calculated and verified by the backend.
  * *Important: Cart totals must be calculated and verified server-side. Never trust the amount sent by the mobile app.*
* **Verification Checklist:**
  * [ ] Verify changing quantities recalculates totals correctly.
  * [ ] Verify that modifying cart payload values on the client does not bypass backend verification.

### 1.7 Cashless Payments (Razorpay)
* **User Story:** As a customer, I want to make payments using UPI, Card, or Net Banking and receive instant verification.
* **Acceptance Criteria:**
  * Payment gateways (e.g. Razorpay) generate transaction tokens.
  * Backend verifies the payment signature via webhook or callback.
  * *Never mark an order as paid based solely on frontend success responses.*
* **Verification Checklist:**
  * [ ] Verify that mock/failed Razorpay responses reject order placement on the server.
  * [ ] Verify that successful webhooks update the database payment status to `paid`.

### 1.8 Order Creation & Status Transitions
* **User Story:** As a customer, I want to see my order transition from Placed to Delivered in real-time.
* **Acceptance Criteria:**
  * Order creates pricing and customization snapshots (so price changes later don't corrupt history logs).
  * Status sequence: `pending_payment` → `placed` → `confirmed` → `preparing` → `ready` → `rider_assigned` → `picked_up` → `out_for_delivery` → `delivered`.
  * Transitions are strictly controlled by backend checks.
* **Verification Checklist:**
  * [ ] Verify database order item snapshots store the actual price at the moment of checkout.
  * [ ] Verify invalid status updates (e.g. going directly from `placed` to `out_for_delivery`) are rejected.

### 1.9 Meal Subscription Plans
* **User Story:** As a customer, I want to subscribe to daily/weekly meal packages and manage daily delivery skips.
* **Acceptance Criteria:**
  * Users select weekly (7-day) or monthly (30-day) meal plans.
  * Users can pause, resume, or skip tomorrow's meal prior to the kitchen cutoff time (e.g. 9:00 AM).
  * Panel displays remaining meals count, calendar days, and status.
* **Verification Checklist:**
  * [ ] Verify that pausing subscription prevents order creation for subsequent dates.
  * [ ] Verify that skipping a meal increments the remaining count and moves the delivery date forward.

### 1.10 Coupons & Offers
* **User Story:** As a user, I want to apply promotional coupon codes to get discounts on my checkout total.
* **Acceptance Criteria:**
  * Coupons validate expiry dates, minimum order values, maximum discount values, first-order conditions, and category rules.
  * Coupon validation and recalculation are performed on the backend.
* **Verification Checklist:**
  * [ ] Verify applying an expired coupon code throws a validation error.
  * [ ] Verify that first-time-only coupons are rejected for returning customers.

### 1.11 Wishlist & Reordering
* **User Story:** As a customer, I want to save favorite items and quickly reorder past checkout baskets.
* **Acceptance Criteria:**
  * Wishlist lets users add/remove favorite flags.
  * Reorder button replicates the order item basket, re-validating item availability, pricing updates, and kitchen open status before adding items to the active cart.
* **Verification Checklist:**
  * [ ] Verify that trying to reorder an out-of-stock menu item filters it out of the cart with a notification.

### 1.12 Reviews & Ratings
* **User Story:** As a customer, I want to rate my delivered dishes and write reviews to share my experience.
* **Acceptance Criteria:**
  * Rating scale is 1 to 5 stars, with optional comments and images.
  * Reviews must undergo admin moderation before appearing publicly.
* **Verification Checklist:**
  * [ ] Verify rating submissions recalculate the average dish score after admin approval.

---

## 2. Logistics & Live Tracking

<!-- TEMPORARILY COMMENTED OUT / REMOVED: Delivery Boy & Live Rider Tracking
### 2.1 Live Courier Tracking (WebSocket)
* **User Story:** As a customer, I want to track my courier's live movement on a map while my order is out for delivery.
* **Acceptance Criteria:**
  * GPS tracking coordinates are broadcasted via WebSockets (Socket.IO) only during active deliveries.
  * Tracker turns off GPS sharing when delivery boy is offline or not on active delivery.
  * Displays customer destination, courier marker, and ETA.

### 2.2 Delivery Provider Architecture
* **User Story:** As an operator, I want to route orders automatically to own riders or external delivery fleets so that deliveries are always covered.
-->
*(Note: Rider live tracking & delivery boy modules are temporarily removed from active scope.)*

### 2.3 Notifications & Alerts
* **User Story:** As a user, I want to receive push notifications for order updates, promotions, and subscriptions.
* **Acceptance Criteria:**
  * Notifications are triggered by backend events and sent using Firebase Cloud Messaging (FCM).
  * Handles OTP messages, order confirmations, dispatch alerts, and subscription warnings.
* **Verification Checklist:**
  * [ ] Verify that order status changes on the backend emit push notifications to the correct device token.

---

## 3. Admin Management Capabilities

### 3.1 Dashboard & Settings Management
* Real-time analytical graphs showing sales charts, popular food items, active users, and operational statistics.
* Global configurations: kitchen coordinates, service radius, GST parameters, minimum checkout values, and maintenance mode toggle.

### 3.2 Food & Category Management
* CRUD controls for categories (names, icons, active status).
* CRUD controls for food items (descriptions, prices, active status, Jain/Fasting tags, customizations, and add-ons).

### 3.3 Staff Management (Chefs & Riders)
* Adding/editing Chefs, managing permissions, and tracking kitchen cooking times.
* Managing delivery boys, processing manual assignments, and viewing earnings.

### 3.4 Media & Promotions Management
* Upload and publish food shorts (videos and thumbnails).
* Upload and link banners to categories or items.
* Configuration of coupons (discount rates, usage limits, codes).
* Subscription plan creators (weekly, monthly, meal quantities).

### 3.5 Operational Order & Payment Controls
* Real-time tracking grid of all orders with manual dispatch overrides.
* Gateway transaction details, payment status, and refund triggers.

### 3.6 Reports & Audit Logs
* CSV/Excel exports for daily revenue summaries and delivery rider payouts.
* **Admin Audit Log:** Track crucial actions (price updates, item deletions, manual refunds, blocking users) showing Admin ID, Action, Entity, Old Value, New Value, and Timestamp.

---

## 4. Non-Functional Features

### 4.1 Image & Video Optimization
* Menu images and short videos must be compressed and delivered via CDN or object storage (e.g. AWS S3, Cloudinary).
* The customer mobile app must implement lazy loading for list images and pre-fetching for shorts videos.

### 4.2 Performance Requirements
* Target: Under 2 seconds initial application launch time.
* High-volume endpoints (food lists, order history, shorts) must enforce pagination.
* Database indexes are placed on foreign keys (`user_id`, `category_id`) and status columns (`status`, `is_active`) to maintain fast database queries.

---

## 5. Testing & Verification Specifications

### 5.1 System Unit & Feature Tests
Developers must run integration tests to verify the authentication flow (correct, expired, and rate-limited OTP inputs), food list sorting, cart discount rules, and webhook validations.

### 5.2 Critical End-to-End Order Workflow Test
Before production release, the complete order lifecycle must succeed:
```
Customer Login 
  └── Select Location 
        └── Customize & Add Food to Cart 
              └── Complete Razorpay Payment 
                    └── Chef Accepts Order 
                          └── Chef Marks Preparing & Ready 
                                └── Rider Receives & Accepts Delivery 
                                      └── GPS Tracking Starts (WebSocket) 
                                            └── Courier OTP Handshake 
                                                  └── Delivered & Customer Review
```

### 5.3 Admin Verification Test
Verify the administrative flow:
```
Admin Login
  └── Create Category & Menu Dish
        └── Bind Customizations
              └── Add Promotion Banner & Coupon
                    └── Assign Chef & Rider Profiles
                          └── Run Reports & Review Audit Logs
```
