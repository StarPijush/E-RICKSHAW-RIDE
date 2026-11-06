# E-GO — Engineering Hub

E-GO is a ride-hailing and local mobility platform for **Jhargram, West Bengal, India**.
Initial vehicle categories: **E-rickshaw / Toto** and **Bike taxi**.
Business model: independent drivers, commission-based platform, cash payments initially.

## Repository layout

```
E-go/            Customer Flutter application (Android + iOS)
E-go-rider/      Driver Flutter application (Android + iOS)
E-go-admin/      Admin Flutter application (Flutter Web)
backend/         Shared backend (REST API + workers + migrations)
packages/        Shared Dart packages
infrastructure/  Docker, database, CI/CD, monitoring, env templates
docs/            Architecture, decisions, API, database, development, security
```

## Applications

1. **E-go** — Customer-facing app: registration, phone OTP, pickup/destination,
   map integration, fare estimation, booking, live driver tracking, trip status,
   trip history, cash payment, ratings, notifications, customer support.
2. **E-go-rider** — Driver-facing app: registration, document upload, approval status,
   online/offline, location updates, booking requests, navigation, trip lifecycle,
   cash collection, earnings/commission, ratings, notifications.
3. **E-go-admin** — Administrative console (Flutter Web): RBAC, customer/driver/vehicle
   management, document verification, active trip monitoring, fare/commission config,
   service-area management, support tickets, reports/analytics, fraud monitoring, audit logs.

## Official Branding

The visual identity of E-GO is built around official yellow-and-black brand tokens:
- **Primary Brand Yellow:** `#F5C928`
- **Primary Brand Black:** `#171717`
- **Surface & Backgrounds:** White (`#FFFFFF`) with subtle warm neutrals (`#FAFAF7`)
- **Semantic Status Colors:** Retained standard green (`#1A7F5A`), amber (`#B45309`), and red (`#B91C1C`) for trip states and alerts.

## Development principles

- **Sound null safety**, effective Dart, strong typing, clear naming.
- **Feature-oriented architecture** in each app; predictable state management;
  separation of UI and business logic.
- **Server-authoritative state**: clients are thin. Every ride-state transition is
  validated server-side; clients hold optimistic `pending*` variants only.
- **Contract-first API**: the API is defined before it is implemented.
- **Cash = ledger**: `cash_ledger` is authoritative; completion ≠ collection.
- **English** for all code, comments, docs and reports; product strings are
  Bengali-first + English.
- **Tests are release gates**: no merge to main without unit tests passing.

## Customer App Verification

The customer application (`E-go`) is verified and test-ready:
```powershell
cd E-go
flutter analyze
flutter test
```
All unit and integration tests passing.
