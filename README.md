# Parabdi – Pure Veg Gujarati Cloud Kitchen Food Ordering Platform

Welcome to the **Parabdi** repository! 

Parabdi is a pure vegetarian Gujarati Cloud Kitchen platform. It enables customers to order traditional Gujarati meals, customize preparations (e.g., Jain options, custom spice levels), view food shorts, and purchase daily/weekly subscriptions (Lunch, Dinner, or Breakfast). The ecosystem includes management interfaces for Kitchen Managers (Admin) and Chefs *(Note: Delivery Boy / Rider module is temporarily removed from scope)*.

---

## 1. Document Architecture

Below are the detailed specifications, schema maps, and developer guidelines for the Parabdi ecosystem. Please read them before contributing:

* 📋 **[SRS.md](file:///d:/food-app-demo/SRS.md):** Software Requirements Specification (Scope, User Roles, Business Rules, Client Decisions, Definition of Done).
* 🤖 **[AGENTS.md](file:///d:/food-app-demo/AGENTS.md):** AI agent instructions, coding conventions, folder layout, and tech stack details.
* 🗄️ **[DATABASE.md](file:///d:/food-app-demo/DATABASE.md):** Relational PostgreSQL database schema, data types, indexes, and constraints.
* 🔌 **[API_DOCUMENTATION.md](file:///d:/food-app-demo/API_DOCUMENTATION.md):** Backend NestJS REST endpoints list and Socket.IO real-time event signatures.
* 🗺️ **[UI_FLOW.md](file:///d:/food-app-demo/UI_FLOW.md):** Visual navigation layouts, required UI states, and transition paths for all four application roles.
* 🎯 **[FEATURES.md](file:///d:/food-app-demo/FEATURES.md):** Complete catalog of user stories, acceptance criteria, admin boards, and verification steps.
* 📝 **[TASKS.md](file:///d:/food-app-demo/TASKS.md):** Development roadmap milestones and backlog item checklist.
* 📈 **[CHANGELOG.md](file:///d:/food-app-demo/CHANGELOG.md):** Chronological registry of versions, edits, and updates.
* 📊 **[DATA_MODELS.md](file:///d:/food-app-demo/DATA_MODELS.md):** Shared entity specifications — Database ↔ JSON API ↔ Dart model mappings with serialization code.
* 🔒 **[SECURITY.md](file:///d:/food-app-demo/SECURITY.md):** Authentication, CORS, rate limiting, input validation, payment security, Socket.IO security.
* 🧪 **[TESTING.md](file:///d:/food-app-demo/TESTING.md):** Test strategy, structure, coverage targets, and CI configuration for all codebases.
* 🚀 **[DEPLOYMENT.md](file:///d:/food-app-demo/DEPLOYMENT.md):** Docker configuration, VPS setup, CI/CD pipeline, monitoring, and backup strategy.
* 🖥️ **[ADMIN_PANEL_ARCHITECTURE.md](file:///d:/food-app-demo/ADMIN_PANEL_ARCHITECTURE.md):** Admin panel technical architecture — Next.js, shadcn/ui, TanStack Query, page specifications.
* ⚙️ **[ENVIRONMENT_SETUP.md](file:///d:/food-app-demo/ENVIRONMENT_SETUP.md):** Step-by-step development environment setup for Backend, Flutter, and Admin panel.

---

## 2. Directory Layout

The repository is structured as a multi-package workspace:

```
parabdi-app/
├── backend/                # Node.js + TypeScript + NestJS (WebSocket & REST API Server)
├── admin/                  # React / Next.js Admin web portal
├── lib/                    # Flutter customer mobile app (Android / iOS)
├── android/                # Android compilation configuration
└── ios/                    # iOS compilation configuration
```

---

## 3. Local Development Quickstart

### 3.1 Mobile App (Flutter)
1. Ensure Flutter SDK is installed.
2. Get packages:
   ```bash
   flutter pub get
   ```
3. Run the application in debug mode:
   ```bash
   flutter run
   ```
4. Verify analysis standards are met:
   ```bash
   flutter analyze
   ```

### 3.2 Backend Server (Node.js)
1. Go to `/backend`.
2. Install npm dependencies:
   ```bash
   npm install
   ```
3. Configure environment parameters (`.env`) for PostgreSQL credentials.
4. Launch development server:
   ```bash
   npm run dev
   ```
