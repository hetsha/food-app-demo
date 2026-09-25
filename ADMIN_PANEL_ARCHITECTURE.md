# ADMIN_PANEL_ARCHITECTURE.md — Admin Panel Technical Architecture

This document defines the complete technical architecture for the **Parabdi Admin Panel** built with Next.js.

---

## 1. Tech Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | Next.js (App Router) | 14.x |
| Language | TypeScript | 5.x |
| UI Components | shadcn/ui | Latest |
| Styling | Tailwind CSS | 3.x |
| State/Data Fetching | TanStack Query (React Query) | 5.x |
| Forms | React Hook Form + Zod | Latest |
| Charts | Recharts | Latest |
| Tables | TanStack Table | Latest |
| Auth | NextAuth.js | 5.x |
| Icons | Lucide React | Latest |
| Date/Time | date-fns | Latest |
| Notifications | Sonner | Latest |

---

## 2. Directory Structure

```
admin/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   │   └── page.tsx
│   │   │   └── layout.tsx
│   │   ├── (dashboard)/
│   │   │   ├── layout.tsx          # Sidebar + Topbar wrapper
│   │   │   ├── page.tsx            # Dashboard home
│   │   │   ├── orders/
│   │   │   │   └── page.tsx
│   │   │   ├── foods/
│   │   │   │   ├── page.tsx        # Food list
│   │   │   │   └── [id]/
│   │   │   │       └── page.tsx    # Food edit
│   │   │   ├── categories/
│   │   │   │   └── page.tsx
│   │   │   ├── customizations/
│   │   │   │   └── page.tsx
│   │   │   ├── shorts/
│   │   │   │   └── page.tsx
│   │   │   ├── banners/
│   │   │   │   └── page.tsx
│   │   │   ├── customers/
│   │   │   │   └── page.tsx
│   │   │   ├── chefs/
│   │   │   │   └── page.tsx
│   │   │   ├── subscriptions/
│   │   │   │   └── page.tsx
│   │   │   ├── coupons/
│   │   │   │   └── page.tsx
│   │   │   ├── reviews/
│   │   │   │   └── page.tsx
│   │   │   ├── payments/
│   │   │   │   └── page.tsx
│   │   │   ├── reports/
│   │   │   │   └── page.tsx
│   │   │   ├── notifications/
│   │   │   │   └── page.tsx
│   │   │   ├── settings/
│   │   │   │   └── page.tsx
│   │   │   └── audit-logs/
│   │   │       └── page.tsx
│   │   ├── api/
│   │   │   └── auth/
│   │   │       └── [...nextauth]/
│   │   │           └── route.ts
│   │   ├── layout.tsx
│   │   └── globals.css
│   ├── components/
│   │   ├── ui/                     # shadcn/ui primitives
│   │   ├── layout/
│   │   │   ├── sidebar.tsx
│   │   │   ├── topbar.tsx
│   │   │   └── breadcrumb.tsx
│   │   ├── dashboard/
│   │   │   ├── revenue-chart.tsx
│   │   │   ├── order-stats.tsx
│   │   │   └── recent-orders.tsx
│   │   ├── food/
│   │   │   ├── food-table.tsx
│   │   │   ├── food-form.tsx
│   │   │   └── food-filters.tsx
│   │   └── shared/
│   │       ├── data-table.tsx
│   │       ├── confirm-dialog.tsx
│   │       ├── loading-spinner.tsx
│   │       └── empty-state.tsx
│   ├── lib/
│   │   ├── api-client.ts           # Axios instance
│   │   ├── auth.ts                 # NextAuth config
│   │   └── utils.ts                # Helpers
│   ├── hooks/
│   │   ├── use-foods.ts            # TanStack Query hooks
│   │   ├── use-orders.ts
│   │   ├── use-categories.ts
│   │   └── use-auth.ts
│   ├── types/
│   │   └── index.ts                # Shared TypeScript types
│   └── providers/
│       ├── query-provider.tsx      # TanStack Query provider
│       └── auth-provider.tsx       # NextAuth session provider
├── public/
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

---

## 3. Authentication Flow

### 3.1 Admin Login

```
1. Admin navigates to admin.parabdikitchen.com/login
2. Enters email + password (or Google OAuth)
3. NextAuth validates credentials against backend API
4. Backend returns JWT token + admin user profile
5. NextAuth stores session in encrypted cookie
6. Admin redirected to /dashboard
```

### 3.2 Session Management

```typescript
// src/lib/auth.ts
import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';

export const { handlers, signIn, signOut, auth } = NextAuth({
  providers: [
    CredentialsProvider({
      credentials: {
        email: {},
        password: {},
      },
      async authorize(credentials) {
        const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/auth/admin/login`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({
            email: credentials.email,
            password: credentials.password,
          }),
        });

        const data = await res.json();
        if (data.success) {
          return { id: data.data.user.id, ...data.data.user, token: data.data.access_token };
        }
        return null;
      },
    }),
  ],
  session: { strategy: 'jwt' },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.accessToken = user.token;
        token.role = user.role;
      }
      return token;
    },
    async session({ session, token }) {
      session.user.accessToken = token.accessToken;
      session.user.role = token.role;
      return session;
    },
  },
  pages: {
    signIn: '/login',
  },
});
```

---

## 4. API Client Setup

```typescript
// src/lib/api-client.ts
import axios from 'axios';
import { getSession } from 'next-auth/react';

const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor — attach JWT
apiClient.interceptors.request.use(async (config) => {
  const session = await getSession();
  if (session?.user?.accessToken) {
    config.headers.Authorization = `Bearer ${session.user.accessToken}`;
  }
  return config;
});

// Response interceptor — handle 401
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Redirect to login
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default apiClient;
```

---

## 5. Data Fetching (TanStack Query)

```typescript
// src/hooks/use-foods.ts
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import apiClient from '@/lib/api-client';

export function useFoods(params?: { category_id?: string; search?: string }) {
  return useQuery({
    queryKey: ['foods', params],
    queryFn: async () => {
      const { data } = await apiClient.get('/admin/foods', { params });
      return data;
    },
  });
}

export function useCreateFood() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (foodData: FormData) => {
      const { data } = await apiClient.post('/admin/foods', foodData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['foods'] });
    },
  });
}

export function useUpdateFood() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async ({ id, ...foodData }: { id: string } & Partial<FoodItem>) => {
      const { data } = await apiClient.patch(`/admin/foods/${id}`, foodData);
      return data;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['foods'] });
    },
  });
}

export function useDeleteFood() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (id: string) => {
      await apiClient.delete(`/admin/foods/${id}`);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['foods'] });
    },
  });
}
```

---

## 6. Page Specifications

### 6.1 Login Page

**Layout:** Centered card with logo
**Components:** Email input, Password input, Login button, Google OAuth button
**Validation:** Email format, password min 8 chars

### 6.2 Dashboard Page

**Layout:** 4 stat cards on top, revenue chart (line), recent orders (table), order status breakdown (pie chart)

**Stat Cards:**
| Card | Value | Trend |
|------|-------|-------|
| Today's Revenue | ₹X,XXX | ↑ 12% vs yesterday |
| Active Orders | XX | In preparation |
| Completed Today | XX | ↑ 8% vs yesterday |
| Active Subscribers | XXX | Total active |

**Revenue Chart:** Line chart showing daily revenue for last 30 days
**Recent Orders:** Table with 10 most recent orders (ID, customer, items, total, status, time)

### 6.3 Orders Page

**Layout:** Filter bar + Data table

**Filters:** Status (All, Placed, Confirmed, Preparing, Ready, Delivered, Cancelled), Date range, Search by order ID/customer name

**Table Columns:** Order ID, Customer, Items count, Total, Payment status, Order status, Time, Actions (View, Cancel)

### 6.4 Foods Page

**Layout:** Filter bar + Data table + Add button

**Filters:** Category dropdown, Search by name, Veg/Non-veg toggle, Active/Inactive toggle

**Table Columns:** Image (thumbnail), Name, Category, Price, Rating, Status (active/inactive), Actions (Edit, Toggle status, Delete)

**Add/Edit Form:** Name, Description, Category (select), Price, Original price, Images (upload), Video URL, Calories, Prep time, Veg toggle, Jain available, Fasting friendly, Bestseller toggle, Healthy pick toggle, Customizations (dynamic form)

### 6.5 Categories Page

**Layout:** Data table + Add button

**Table Columns:** Icon, Name, Display order, Active status, Food count, Actions (Edit, Toggle status, Delete)

**Add/Edit Form:** Name, Icon (emoji picker), Display order, Active toggle

### 6.6 Banners Page

**Layout:** Data table + Add button

**Table Columns:** Image preview, Title, Subtitle, Click action, Active status, Date range, Actions (Edit, Toggle, Delete)

**Add/Edit Form:** Title, Subtitle, Image upload, Click action (food/category/url), Action value, Start date, End date, Display order, Active toggle

### 6.7 Shorts Page

**Layout:** Data table + Add button

**Table Columns:** Thumbnail preview, Caption, Linked food, Likes, Views, Active status, Actions (Edit, Delete)

**Add/Edit Form:** Video upload, Thumbnail upload, Caption, Linked food item (searchable select), Linked category (select)

### 6.8 Customers Page

**Layout:** Data table + Search

**Table Columns:** Avatar, Name, Phone, Email, Orders count, Wallet balance, Joined date, Status (active/blocked), Actions (View, Block/Unblock, Wallet credit)

### 6.9 Chefs Page

**Layout:** Data table + Add button

**Table Columns:** Avatar, Name, Phone, Active orders, Avg cooking time, Status, Actions (Edit, Toggle status, Delete)

**Add/Edit Form:** Name, Phone, Email, PIN (for chef login), Active toggle

### 6.10 Subscriptions Page

**Layout:** Plan cards + User subscriptions table

**Plan Management:** Create/edit/delete subscription tiers
**User Subscriptions:** Table showing user, plan, status, start/end date, meals remaining, skip dates

### 6.11 Coupons Page

**Layout:** Data table + Add button

**Table Columns:** Code, Discount type, Discount value, Min order, Uses/Max uses, Expiry, Active status, Actions (Edit, Toggle, Delete)

**Add/Edit Form:** Code, Description, Discount type (% / flat / free delivery), Discount value, Min order value, Max discount, Max total uses, Max uses per user, First-order only toggle, Expiry date

### 6.12 Reviews Page

**Layout:** Data table + Filters

**Filters:** Approval status (Pending, Approved, Rejected), Rating (1-5), Food item search

**Table Columns:** User, Food item, Rating (stars), Comment, Images, Status, Date, Actions (Approve, Reject, Delete)

### 6.13 Payments Page

**Layout:** Data table + Filters

**Filters:** Payment status (Pending, Paid, Failed, Refunded), Date range

**Table Columns:** Order ID, Customer, Amount, Payment method, Payment status, Razorpay ID, Date, Actions (View details, Initiate refund)

### 6.14 Reports Page

**Layout:** Date range selector + Export buttons + Charts

**Available Reports:**
- Revenue report (daily/weekly/monthly)
- Order count report
- Popular food items
- Category performance
- Subscription analytics
- Customer growth

**Export:** CSV, Excel (using xlsx library)

### 6.15 Notifications Page

**Layout:** Compose form + History table

**Compose:** Title, Body, Target (All customers / Specific users / Subscription holders), Send button
**History:** Table showing title, body, target, sent date, status

### 6.16 Settings Page

**Layout:** Form sections

**Sections:**
- Kitchen location (lat/lng, map picker)
- Business hours (opening/closing time)
- Delivery radius (km)
- Minimum order value (₹)
- Platform fee (₹)
- GST rate (%)
- Free delivery threshold (₹)
- Maintenance mode toggle
- Cutoff time for subscription skip

### 6.17 Audit Logs Page

**Layout:** Data table + Filters

**Filters:** Admin (select), Action type, Entity type, Date range

**Table Columns:** Admin name, Action, Entity, Entity ID, Old value (JSON diff), New value (JSON diff), IP address, Timestamp

---

## 7. Real-Time Updates

```typescript
// src/hooks/use-order-updates.ts
import { useEffect } from 'react';
import { io } from 'socket.io-client';
import { useQueryClient } from '@tanstack/react-query';

export function useOrderUpdates() {
  const queryClient = useQueryClient();

  useEffect(() => {
    const socket = io(process.env.NEXT_PUBLIC_API_URL!, {
      auth: { token: getSessionToken() },
    });

    socket.on('order_status_update', (data) => {
      queryClient.invalidateQueries({ queryKey: ['orders'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard-stats'] });
      toast(`Order ${data.order_id} status: ${data.status}`);
    });

    return () => { socket.disconnect(); };
  }, [queryClient]);
}
```

---

## 8. Responsive Design

| Breakpoint | Layout |
|------------|--------|
| < 768px (Mobile) | Collapsible sidebar, stacked cards |
| 768px - 1024px (Tablet) | Collapsible sidebar, 2-column grid |
| > 1024px (Desktop) | Fixed sidebar, full layout |

**Sidebar behavior:**
- Desktop: Fixed left sidebar (240px width)
- Tablet: Collapsible sidebar (icons only, 64px width)
- Mobile: Overlay sidebar with backdrop
