# MILitech Merchant — Project Handover & Technical Documentation

---

## Cover Page

| Field | Value |
|-------|-------|
| **Project Name** | MILitech Merchant (Merchent) |
| **Application Version** | 1.0.0+1 |
| **Flutter Version** | 3.35.6 |
| **Dart SDK** | >=3.9.0 <4.0.0 |
| **Prepared For** | Miltech (Client) |
| **Prepared By** | Development Team — MILitech Merchant Project |
| **Date** | June 30, 2026 |
| **Document Version** | 1.0.0 |

---

> **Confidentiality Notice:** This document contains proprietary technical information intended solely for authorized personnel involved in the development, deployment, maintenance, and support of the MILitech Merchant mobile application.

---

# Table of Contents

1. [Project Overview](#1-project-overview)
2. [Features](#2-features)
3. [Technology Stack](#3-technology-stack)
4. [Project Structure](#4-project-structure)
5. [Architecture](#5-architecture)
6. [State Management](#6-state-management)
7. [Routing](#7-routing)
8. [API Documentation](#8-api-documentation)
9. [Authentication](#9-authentication)
10. [Firebase](#10-firebase)
11. [Local Storage](#11-local-storage)
12. [Third Party Packages](#12-third-party-packages)
13. [Environment Configuration](#13-environment-configuration)
14. [Assets](#14-assets)
15. [Build Instructions](#15-build-instructions)
16. [Deployment Guide](#16-deployment-guide)
17. [Configuration Required Before Running](#17-configuration-required-before-running)
18. [Admin Panel Integration](#18-admin-panel-integration)
19. [Security](#19-security)
20. [Error Handling](#20-error-handling)
21. [Performance Optimizations](#21-performance-optimizations)
22. [Known Issues](#22-known-issues)
23. [Future Improvements](#23-future-improvements)
24. [Project Maintenance Guide](#24-project-maintenance-guide)
25. [Backup & Restore](#25-backup--restore)
26. [Delivery Checklist](#26-delivery-checklist)
27. [Changelog](#27-changelog)
28. [Contact Information](#28-contact-information)
29. [Appendix](#29-appendix)

---

# 1. Project Overview

## 1.1 Purpose of the Application

**MILitech Merchant** (package name: `merchent`) is a cross-platform Flutter mobile application designed for **store owners and merchants** on the MILitech loyalty platform. Merchants use the app to manage sales, scan customer QR codes, view dashboard analytics, process transactions, apply promotions, and manage their shop profile.

## 1.2 Business Goal

Digitize in-store loyalty operations by connecting merchants to the MILitech Node.js backend. Merchants can onboard stores, execute loyalty-linked sales, redeem points and gift cards, monitor performance, and stay informed via push and real-time notifications.

## 1.3 Target Users

| User Type | Description |
|-----------|-------------|
| **Merchant / Store Owner** | Primary user; registers shop, processes sales, views dashboard |
| **Merchant Staff** | Same app; backend role typically `MERCENT` |
| **Platform Administrators** | Manage platform via Node.js admin panel (separate system) |
| **End Customers** | Identified via QR/card during merchant sales flow (not app users) |

## 1.4 Main Workflow

```
Splash → Token Check → Profile Fetch → FCM Sync
   │
   ├─ No token → Onboarding (first time) OR Auth Screen
   │
   └─ Has token
         ├─ Location not set → LocationScreen
         ├─ Business not set → ShopInformationScreen
         └─ Complete → Bottom Navigation (Home / Sales / Customers / Profile)
```

**Sales transaction flow:**

```
Sales Management → New Transaction → Card Lookup (QR or manual)
    → Promotion / Gift Card Selection → Total Summary → Checkout API
```

## 1.5 High-Level Summary

| Attribute | Detail |
|-----------|--------|
| Platform | Android & iOS (Flutter 3.35.6) |
| Backend | Node.js REST API + Socket.IO |
| State Management | GetX |
| Auth | JWT Bearer + HTTP cookies + refresh token |
| Real-time | Socket.IO (`newNotification`) |
| Push | Firebase Cloud Messaging |
| Android App ID | `com.miltech.merchent` |
| iOS Bundle ID | `com.miltech.merchent` |
| Firebase Project | `miltech-c3007` |

---

# 2. Features

## 2.1 Authentication

| Feature | Description | Screen / Module |
|---------|-------------|-----------------|
| Sign In | Email/password login with cookie + token persistence | `sign_in_screen` |
| Sign Up | Registration with name, email, phone, role | `sign_up_screen` |
| Create Password | Password creation after sign-up form | `create_password_screen` |
| OTP Verification | Post-registration OTP verification | `verify_otp_screen` |
| Forgot Password | Request OTP via identifier (email/phone) | `forgot_password` |
| Forgot OTP Verify | Verify OTP for password reset | `forgot_verify_otp_screen` |
| Reset Password | Set new password after forgot flow | `reset_password_screen` |
| Change Password | Change password while logged in | `chnage_pass_screen` |
| Delete Account | Account deletion with password confirmation | `profile_screen` |
| Logout | Clears storage, cookies, redirects to auth | `profile_screen` |

## 2.2 Onboarding & Setup

| Feature | Description |
|---------|-------------|
| Onboarding Carousel | First-launch walkthrough with coin/store imagery |
| Auth Entry | Choose sign in or sign up |
| Location Setup | GPS + Google Places autocomplete + map preview |
| Shop Information | Business name, category, country/city, profile image |
| Subscription UI | Static subscription plan cards (no live payment API) |
| All Set / Thanks | Post-setup confirmation screens |

## 2.3 Home / Dashboard

| Feature | Description |
|---------|-------------|
| Weekly Sell Report | Pie chart — weekly sales breakdown |
| Merchant Dashboard Report | Stat cards with time-range filters |
| Customer Chart | Bar chart — customer revenue by date range |
| Socket Initialization | Real-time notification listener started from home |

## 2.4 Sales Management

| Feature | Description |
|---------|-------------|
| Sales Overview | Filtered merchant report for sales tab |
| QR Scanner | `mobile_scanner` — scan customer card codes |
| Sell Details | Paginated transaction list with search and period filter |
| New Transaction | Manual or QR card lookup |
| Promotion Lookup | Find promotions by card code |
| Gift Card / Points Redemption | Request approval before checkout |
| Total Summary | Review and confirm checkout |
| Checkout | Final sale API submission |

## 2.5 Customer Management

| Feature | Description |
|---------|-------------|
| Customer List | Paginated, searchable, period-filtered table |
| Customer Profile | Tier info + transaction history |
| Infinite Scroll | Load-more pagination on lists |

## 2.6 Notifications

| Feature | Description |
|---------|-------------|
| Notification List | Paginated in-app notifications |
| Mark All Read | PATCH to `/notifications/read` |
| FCM Foreground | Listen and display while app open |
| Socket Real-time | `newNotification` event updates list live |
| FCM Token Sync | Token sent to backend on splash and login |

## 2.7 Profile & Settings

| Feature | Description |
|---------|-------------|
| View Profile | Name, email, role, image |
| Edit Profile | Name, address, CSC picker, photo, coordinates |
| Change Password | Authenticated password change |
| Contact Us | Support message form |
| Terms & Conditions | HTML disclaimer loaded from API |
| Privacy Policy | Static in-app privacy text |
| Theme | Light/dark theme via `ThemeController` |

## 2.8 Navigation

| Tab | Screen | Index |
|-----|--------|-------|
| Home | Dashboard | 0 |
| Sales | Sales Management | 1 |
| Customers | Customer Details | 2 |
| Profile | Profile | 3 |

---

# 3. Technology Stack

## 3.1 Core Framework

| Component | Version / Detail |
|-----------|------------------|
| Flutter | 3.35.6 (FVM-managed) |
| Dart SDK | ^3.8.1 (resolved: >=3.9.0 <4.0.0) |
| App Version | 1.0.0+1 |

## 3.2 State Management

**GetX** (`get: ^4.7.3`) — controllers, reactive variables (`Rx`, `.obs`), `Obx`, `GetBuilder`, routing, and lightweight DI via `Get.put`.

## 3.3 Architecture

Layered architecture with repository pattern (not strict Clean Architecture):

- **Presentation:** `screen/` — UI + GetX controllers
- **Routing:** `routes/` — `GetPage` definitions
- **Data / Service:** `service/repository/`, `service/api_service/`
- **Core:** `constant/`, `widget/`, `utils/`

## 3.4 HTTP Client

| Library | Purpose |
|---------|---------|
| `dio` ^5.9.0 | Primary REST client (auth APIs) |
| `dio_cookie_manager` | Cookie persistence on Dio |
| `cookie_jar` | File-based cookie jar |
| `http` ^1.2.2 | Supplemental multipart uploads |

## 3.5 Database

No local SQLite/Hive database for business data. **SharedPreferences** and **GetStorage** only.

## 3.6 Firebase Services

| Service | Used | Notes |
|---------|------|-------|
| Firebase Core | Yes | `Firebase.initializeApp()` in `main.dart` |
| Firebase Messaging (FCM) | Yes | Push notifications + token sync |
| Firestore | No | Not Found |
| Realtime Database | No | Not Found |
| Analytics | No | Not Found |
| Crashlytics | No | Not Found |
| Storage | No | Not Found |
| Auth | No | Backend handles auth |
| Dynamic Links | No | Not Found |
| Remote Config | No | Not Found |

## 3.7 Push Notifications

Firebase Cloud Messaging with background handler in `main.dart`. Token synced via `PATCH /user` with `{fcmToken}`.

## 3.8 Maps & Location

| Library | Purpose |
|---------|---------|
| `geolocator` ^10.1.0 | Device GPS |
| Google Maps APIs | Geocoding, Places autocomplete, static map preview |
| Google Maps API Key | `AppConst.googleMapsApiKey` in `app_const.dart` |

## 3.9 Payments

Subscription screens are **UI-only** (static plan cards). No payment gateway integration found in codebase.

## 3.10 Storage

| Library | Purpose |
|---------|---------|
| `shared_preferences` | Tokens, user data, flags |
| `get_storage` | First-time user flag |
| `path_provider` | Cookie jar file path |
| `flutter_cache_manager` | Image cache |

## 3.11 Image Libraries

| Library | Purpose |
|---------|---------|
| `cached_network_image` | Network images with cache |
| `image_picker` | Gallery/camera for profile/shop photos |
| `skeletonizer` | Loading skeleton placeholders |
| `flutter_svg` | SVG assets (visibility icons) |

## 3.12 Charts & Visualization

| Library | Purpose |
|---------|---------|
| `fl_chart` ^1.2.0 | Bar and pie charts on dashboard |
| `syncfusion_flutter_datepicker` | Date range picker |
| `intl` | Date/number formatting |

## 3.13 Animations

No dedicated animation package. Standard Flutter animations + `smooth_page_indicator` for onboarding dots.

## 3.14 Localization

**Not Found** — no `flutter_localizations`, ARB files, or i18n setup. UI strings are hardcoded in English.

## 3.15 Real-time Communication

`socket_io_client` ^3.1.3 — connects to API domain root for `newNotification` events.

## 3.16 SDK Requirements

| Platform | Minimum | Target |
|----------|---------|--------|
| Android | Flutter `minSdkVersion` | Flutter `targetSdkVersion` |
| iOS | iOS 12+ (typical Flutter default) | Latest supported by Flutter 3.35.6 |
| Java (Android build) | JDK 11 | JDK 17 (CI) |
| Kotlin JVM | 11 | 11 |

## 3.17 Operating System Requirements

| OS | Development | Runtime |
|----|-------------|---------|
| macOS | Required for iOS builds | N/A |
| Windows/Linux | Android builds supported | N/A |
| Android | 5.0+ (API 21 typical) | Camera, GPS, storage permissions |
| iOS | 12+ | Camera, location, photo library permissions |

---

# 4. Project Structure

```
merchent/
├── android/                    # Android native project
├── ios/                        # iOS native project
├── assets/
│   ├── images/                 # PNG/WebP illustrations and nav icons
│   └── icon/                   # SVG visibility icons
├── lib/
│   ├── main.dart               # Entry: Firebase, cookies, GetStorage
│   ├── my_app.dart             # GetMaterialApp root
│   ├── firebase_options.dart   # Firebase iOS config (FlutterFire)
│   ├── constant/               # API endpoints, colors, theme, asset paths
│   ├── routes/                 # Route constants and GetPage list
│   ├── screen/                 # Feature screens + controllers + models
│   ├── service/                # API, repositories, storage, sockets
│   ├── widget/                 # Reusable UI components
│   └── utils/                  # Sizing, logging, translation keys
├── pubspec.yaml
├── README.md
├── API_BASE_URL_SETUP_INSTRUCTIONS.txt
└── .github/workflows/main.yml  # CI/CD pipeline
```

## 4.1 `lib/constant/`

| File / Folder | Responsibility |
|---------------|----------------|
| `app_api_end_point.dart` | Base URL, all REST endpoint path constants |
| `app_color/` | Theme colors, `AppTheme`, `ThemeController` |
| `app_image_path.dart` | Asset image path constants |
| `app_icons_path.dart` | Asset icon path constants |

## 4.2 `lib/routes/`

| File | Responsibility |
|------|----------------|
| `app_routes.dart` | Route name string constants |
| `app_routes_file.dart` | `List<GetPage>` binding routes to widgets |

## 4.3 `lib/screen/`

Feature-based organization. Each feature typically contains:
- Screen widget (UI)
- `controller/` — GetX controller
- `model/` — Data models (where applicable)
- `widget/` — Feature-specific widgets

## 4.4 `lib/service/api_service/`

| File | Responsibility |
|------|----------------|
| `api_services.dart` | Authenticated Dio client, interceptors, token refresh |
| `non_auth_api.dart` | Pre-login Dio client |
| `non_auth_api_service.dart` | Wrapper for non-auth API calls |
| `cookie_service.dart` | Persistent `PersistCookieJar` |
| `service_model/service_model.dart` | `ApiResponseModel` |

## 4.5 `lib/service/repository/`

Per-feature API wrappers calling `ApiService` or `NonAuthApiService`.

## 4.6 `lib/service/storage/`

| File | Responsibility |
|------|----------------|
| `storage_service.dart` | `LocalStorage` — SharedPreferences wrapper |
| `get_storage_services.dart` | First-time user flag |
| `storage_key.dart` | Key constants |

## 4.7 `lib/service/sockets/`

`app_socket_all_operation.dart` — Singleton Socket.IO client.

## 4.8 `lib/widget/`

Reusable components: buttons, text fields, app bars, snack bars, network images.

## 4.9 `lib/utils/`

| Folder / File | Responsibility |
|---------------|----------------|
| `app_size.dart` | Responsive sizing from `MediaQuery` |
| `app_log/` | Logging utilities |
| `app_translation/` | Static API error message keys |
| `local_database/prefs_helper.dart` | Preferences helper |

---

# 5. Architecture

## 5.1 Architectural Style

The application follows a **pragmatic layered architecture** with GetX, combining presentation and controller logic in feature folders, and isolating network access in repositories.

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  screen/*_screen.dart  +  controller/*_controller.dart       │
│  Reactive UI: Obx, GetBuilder, GetxController.update()       │
├─────────────────────────────────────────────────────────────┤
│                    ROUTING LAYER                             │
│  routes/app_routes.dart  +  app_routes_file.dart             │
│  GetMaterialApp → GetPage → Screen Widget                    │
├─────────────────────────────────────────────────────────────┤
│                    DOMAIN / BUSINESS LOGIC                   │
│  Controllers orchestrate validation, navigation, state         │
├─────────────────────────────────────────────────────────────┤
│                    DATA LAYER                                │
│  service/repository/*  →  ApiService / NonAuthApiService     │
│  Models in screen/*/model/                                   │
├─────────────────────────────────────────────────────────────┤
│                    INFRASTRUCTURE                            │
│  Dio + Cookies, SharedPreferences, GetStorage, Socket.IO, FCM│
└─────────────────────────────────────────────────────────────┘
```

## 5.2 Data Flow

```
UI (Screen Widget)
       │
       ▼
Controller (GetxController)
       │  user action / onInit
       ▼
Repository (API wrapper)
       │
       ▼
ApiService / NonAuthApiService
       │  Dio HTTP + interceptors
       ▼
Node.js Backend  (/api/v1/*)
       │
       ▼
ApiResponseModel → Controller → UI update (Obx / update())
```

## 5.3 Repository Pattern

Each feature repository encapsulates endpoint URLs and response parsing. Examples:

- `ProfileRepository` → `GET /user/profile`
- `CheckoutRepository` → `POST /sell/checkout`
- `SignInApiController` → `POST /auth/login`

## 5.4 Dependency Injection

GetX lightweight DI:
- `Get.put(Controller())` — register controller
- `Get.find<Controller>()` — retrieve instance
- No formal `Bindings` classes (commented out in routes)

## 5.5 Authentication Layer Integration

```
Request → ApiService Interceptor
              │
              ├─ Attach Bearer token from LocalStorage
              ├─ Attach cookies via CookieManager
              │
              ▼
         Backend Response
              │
              ├─ 200/201 → Success
              └─ 401 → RefreshTokenRepository.resetToken()
                        ├─ Success → Retry request once
                        └─ Failure → Logout (clear storage + cookies)
```

---

# 6. State Management

## 6.1 GetX Controllers

Controllers extend `GetxController` and are instantiated per screen (typically in screen `build` or `initState` via `Get.put`).

**Lifecycle hooks used:**
- `onInit()` — fetch data, setup listeners
- `onClose()` — dispose text controllers, cancel timers

## 6.2 Reactive Variables

| Pattern | Usage |
|---------|-------|
| `.obs` / `Rx<T>` | `NotificationController.notificationsList`, `unreadCount` |
| `Rxn<T>` | `SplashController.profile` |
| `update()` | Imperative rebuild for `GetBuilder` |

## 6.3 Obx vs GetBuilder

- **Obx** — used for reactive `.obs` variables (notifications, loading flags)
- **GetBuilder** — used with `update()` in repositories doubling as controllers

## 6.4 Navigation

| Method | Usage |
|--------|-------|
| `Get.toNamed(route)` | Push named route |
| `Get.offNamed(route)` | Replace current route |
| `Get.offAllNamed(route)` | Clear stack and navigate (logout, splash) |
| `Get.back()` | Pop route |

## 6.5 Dependency Injection

`Get.put()` at screen level. No global `InitialBinding`. `ThemeController` manages theme via SharedPreferences.

---

# 7. Routing

## 7.1 Initial Route

`AppRoutes.splashScreen` → `/splashScreen`

## 7.2 Registered Routes

| Route Constant | Path | Screen | Purpose |
|----------------|------|--------|---------|
| `splashScreen` | `/splashScreen` | `SplashScreen` | Entry, auth routing |
| `onBoardingScreen` | `/onboarding` | `OnboardingScreen` | First-launch carousel |
| `authenticationsScreen` | `/authenticationsScreen` | `AuthenticationsScreen` | Auth entry |
| `signInScreen` | `/signInScreen` | `SignInScreen` | Login |
| `signUpScreen` | `/SignUpScreen` | `SignUpScreen` | Registration |
| `createNewPasswordScreen` | `/createNewPasswordScreen` | `CreateNewPasswordScreen` | Set password |
| `verifyOtpScreen` | `/createPassVerifyOtpScreen` | `VerifyOtpScreen` | Sign-up OTP |
| `forgotPasswordScreen` | `/forgotPasswordScreen` | `ForgotPasswordScreen` | Forgot password |
| `forgotPassVerifyOtpScreen` | `/forgotPassVerifyOtpScreen` | `ForgotPassVerifyOtpScreen` | Forgot OTP |
| `resetPasswordScreen` | `/resetPasswordScreen` | `ResetPasswordScreen` | Reset password |
| `locationScreen` | `/locationScreen` | `LocationScreen` | GPS setup |
| `shopInformationScreen` | `/shopInformationScreen` | `ShopInformationScreen` | Business info |
| `subscriptionScreen` | `/subscriptionScreen` | `MySubScreen` | Subscription UI |
| `subscriptionThanksScreen` | `/subscriptionThanksScreen` | `SubscriptionThanksScreen` | Thanks screen |
| `allSetThanksScreen` | `/allSetThanksScreen` | `AllSetThanksScreen` | Setup complete |
| `userBottomNav` | `/bottomNav` | `NavigationScreen` | Main app shell |
| `profileScreen` | `/profile-screen` | `ProfileScreen` | Profile (standalone route) |
| `changeProfileScreen` | `/changeProfileScreen` | `ChnageProfileScreen` | Edit profile |
| `changePassScreen` | `/changePassScreen` | `ChangePassScreen` | Change password |
| `contactUsScreen` | `/contactUsScreen` | `ContactUsScreen` | Contact form |
| `termsAndConditionScreen` | `/termsAndConditionScreen` | `TermAndCondition` | Terms (API HTML) |
| `privacyPolicyScreen` | `/privacyPolicyScreen` | `PrivacyPolicyScreen` | Privacy policy |
| `customerProfilePage` | `/customerProfilePage` | `CustomerProfilePage` | Customer detail |
| `newTransaction` | `/customerCardLookupScreen` | `NewTransaction` | Card lookup |
| `totalSummaryScreen` | `/totalSummaryScreen` | `TotalSummaryScreen` | Checkout summary |
| `notificationScreen` | `/notificationScreen` | `NotificationScreen` | Notifications |
| `sellDetailsScreen` | `/sellDetailsScreen` | `SellDetailsScreen` | Sell list |

## 7.3 Unregistered Route Constants

Defined in `app_routes.dart` but **not** in `app_routes_file.dart`:

- `/` (`initial`)
- `/navigation-screen`
- `/homeScreen`
- `/signupVerifyOtpScreen`
- `/paymentScreen`
- `/warningScreen`

## 7.4 Protected Routes

No middleware-based route guard. Protection is handled in `SplashController.goToNextScreen()`:

1. Empty token → onboarding or auth
2. Valid token but incomplete profile → location or shop setup
3. Complete profile → main navigation

## 7.5 Authentication Flow Diagram

```
                    ┌──────────────┐
                    │    Splash    │
                    └──────┬───────┘
                           │
              ┌────────────┴────────────┐
              │ Token empty?          │
              └────────────┬────────────┘
                    yes    │    no
              ┌────────────┴────────────┐
              ▼                         ▼
     ┌────────────────┐      ┌─────────────────┐
     │ First time?    │      │ Fetch Profile   │
     │ Onboard / Auth │      │ Sync FCM Token  │
     └────────────────┘      └────────┬────────┘
                                      │
                         ┌────────────┼────────────┐
                         ▼            ▼            ▼
                   Location?    Business?     Bottom Nav
                   Screen       Screen        (Main App)
```

---

# 8. API Documentation

**Base URL Pattern:** `{{API_BASE_URL}}/api/v1`

**Default (dev fallback):** `http://10.10.26.208:5004/api/v1`

## 8.1 Endpoint Reference

| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `/auth/login` | POST | No | Merchant login |
| `/auth/verify-otp` | POST | No | Verify OTP (signup / forgot) |
| `/auth/forgot-password` | POST | No | Request password reset OTP |
| `/auth/reset-password` | POST | No | Reset password (forgot flow) |
| `/auth/change-password` | POST | Yes | Change password (logged in) |
| `/auth/refresh-token` | POST | Bearer + body | Refresh access token |
| `/auth/user-delete-account` | DELETE | Yes | Delete account |
| `/user` | POST | No | User registration (sign up) |
| `/user` | PATCH | Yes | Update profile, location, FCM token |
| `/user/profile` | GET | Yes | Get merchant profile |
| `/contact` | POST | Yes | Contact us message |
| `/merchant/merchant-dashboard-report` | GET | Yes | Dashboard stats (`?range=`) |
| `/merchant/weekly-sell-report` | GET | Yes | Weekly sell pie chart data |
| `/merchant/customer-chart-week` | GET | Yes | Customer chart (`startDate`, `endDate`) |
| `/sell/merchant` | GET | Yes | Merchant sell list (paginated) |
| `/sell/customer` | GET | Yes | Customer list (paginated) |
| `/sell/transactions/{id}` | GET | Yes | Customer transaction history |
| `/merchant-customer/customers/{id}/tier` | GET | Yes | Customer tier info |
| `/add-promotion/find?cardCode=` | GET | Yes | Find card + promotions |
| `/sell/promotion/request-approval` | POST | Yes | Gift card / promotion redemption |
| `/sell/checkout` | POST | Yes | Final checkout |
| `/notifications` | GET | Yes | Notification list (`page`, `limit`) |
| `/notifications/read` | PATCH | Yes | Mark all notifications read |
| `/disclaimers/merchant-{type}` | GET | Yes/No | Terms/disclaimer content |
| `/others/privacy-policy` | GET | — | **Defined but unused in app** |
| `/others/terms-and-conditions` | GET | — | **Defined but unused in app** |
| `/others/faq` | GET | — | **Defined but unused in app** |

## 8.2 Authentication Endpoints Detail

### POST `/auth/login`

| Field | Value |
|-------|-------|
| Auth Required | No |
| Client | `NonAuthApiService` |
| Request | `{ "email": "...", "password": "..." }` |
| Success (200) | `{ "data": { "accessToken", "refreshToken", "user": {...} } }` |
| OTP Required (407) | Redirect to OTP verification |
| Error (400) | Bad request / invalid credentials |

### POST `/auth/verify-otp`

| Field | Value |
|-------|-------|
| Auth Required | No |
| Request | `{ "oneTimeCode": "...", "identifier": "..." }` |
| Response | Tokens saved via `RefreshTokenRepository.saveAuthTokens()` |

### POST `/auth/refresh-token`

| Field | Value |
|-------|-------|
| Auth Required | Bearer (expired access token) + optional `{ "refreshToken": "..." }` |
| Response | New `accessToken` in `data` |

## 8.3 Profile Endpoints

### GET `/user/profile`

Sets `LocalStorage.isLocation` and `LocalStorage.isBusiness` based on profile data.

### PATCH `/user`

Used for: location update, business info (multipart), profile edit (multipart), FCM token sync.

## 8.4 Sales Endpoints

### GET `/sell/merchant`

Query: `page`, `limit`, `period`, `searchTerm`

### POST `/sell/checkout`

Body: `CheckoutRequestModel` — final transaction submission.

### GET `/add-promotion/find?cardCode={code}`

Returns digital card info and available promotions.

## 8.5 Error Handling

| Status | Handling |
|--------|----------|
| 200 / 201 | Success |
| 400 | Display `message` from API |
| 401 | Auto refresh token; retry once; logout on failure |
| 407 | OTP verification required (login) |
| 408 | Timeout message (`AppStaticKey.requestTimeOut`) |
| 502 | Bad gateway |
| 503 | No internet (`AppStaticKey.noInternetConnection`) |

## 8.6 Interceptors

**Authenticated (`ApiService`):**
- Attach `Authorization: Bearer {token}`
- Cookie manager
- Request/response logging (debug)
- 401 → refresh + retry

**Non-auth (`NonAuthApi`):**
- Cookie manager only
- JSON content type

## 8.7 Token Handling

| Token | Storage Key | Location |
|-------|-------------|----------|
| Access Token | `token` | SharedPreferences |
| Refresh Token | `refreshToken` | SharedPreferences |
| Reset Token | `resetToken` | SharedPreferences |
| HTTP Cookies | Cookie Jar | App documents directory |

## 8.8 Refresh Token Flow

```
API returns 401
    → Check _retriedAfterRefresh flag
    → RefreshTokenRepository.resetToken()
         POST /auth/refresh-token
         Headers: Bearer {expiredToken}
         Body: { refreshToken } (if stored)
    → Save new accessToken
    → Retry original request once
    → On second 401: LocalStorage.removeAllPrefData() + redirect to auth
```

## 8.9 Timeout Configuration

| Setting | Value |
|---------|-------|
| `connectTimeout` | 120 seconds |
| `sendTimeout` | 120 seconds |
| `receiveTimeout` | 120 seconds |

## 8.10 Retry Logic

- **Token refresh retry:** One automatic retry per request after successful refresh
- **General API retry:** Not implemented (no exponential backoff)

---

# 9. Authentication

## 9.1 Login Flow

1. User enters email/password on `SignInScreen`
2. `SignInApiController.signInApiCall()` → `POST /auth/login`
3. On 200: save tokens, role; sync FCM; navigate based on profile flags
4. On 407: navigate to OTP screen
5. On 400: show error message

## 9.2 Sign-Up Flow

1. `SignUpScreen` → collect user info
2. `CreateNewPasswordScreen` → `POST /user`
3. `VerifyOtpScreen` → `POST /auth/verify-otp`
4. Save tokens → location setup → shop info → main app

## 9.3 Token Storage

Tokens stored in **SharedPreferences** via `LocalStorage.setString()`. In-memory static fields mirror prefs for fast access.

## 9.4 Secure Storage

**Not Found** — `flutter_secure_storage` is not used. Tokens are in SharedPreferences (not encrypted at rest).

## 9.5 Session Handling

Session = JWT access token + refresh token + HTTP cookies. Validated on each API call via interceptor.

## 9.6 Logout

`LocalStorage.removeAllPrefData()`:
- Clears SharedPreferences
- Deletes all cookies
- Resets theme
- `Get.offAllNamed(AppRoutes.authenticationsScreen)`

## 9.7 Cookie Handling

`CookieService` uses `PersistCookieJar` with `FileStorage` in app documents directory. Shared between auth and authenticated Dio clients.

## 9.8 Authorization Flow

```
Client Request
  → Authorization: Bearer {accessToken}
  → Cookie jar (session cookies from login)
  → Backend validates
  → 401 triggers refresh or logout
```

---

# 10. Firebase

## 10.1 Project Configuration

| Field | Value |
|-------|-------|
| Project ID | `miltech-c3007` |
| Project Number | `593611426236` |
| Storage Bucket | `miltech-c3007.firebasestorage.app` |
| Android Package | `com.miltech.merchent` |
| iOS Bundle ID | `com.miltech.merchent` |

## 10.2 Configuration Files

| File | Platform |
|------|----------|
| `android/app/google-services.json` | Android |
| `ios/Runner/GoogleService-Info.plist` | iOS |
| `lib/firebase_options.dart` | iOS only (Android throws UnsupportedError) |

## 10.3 Initialization (`main.dart`)

```dart
await Firebase.initializeApp();
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
```

## 10.4 Firebase Cloud Messaging

- FCM token obtained via `FirebaseMessaging.instance.getToken()`
- Synced to backend: `PATCH /user` with `{ fcmToken }`
- Foreground listener in `NotificationController.listenFCM()`
- Background handler re-initializes Firebase

## 10.5 Services Not Used

Firestore, Realtime Database, Analytics, Crashlytics, Firebase Storage, Firebase Auth, Dynamic Links, Remote Config — **Not Found / Not Used**.

---

# 11. Local Storage

## 11.1 SharedPreferences (`LocalStorage`)

| Key | Type | Purpose |
|-----|------|---------|
| `token` | String | JWT access token |
| `refreshToken` | String | Refresh token |
| `resetToken` | String | Password reset token |
| `cookie` | String | Cookie reference |
| `isLogIn` | bool | Login flag |
| `isLocation` | bool | Location setup complete |
| `isBusiness` | bool | Business info complete |
| `userId` | String | User ID (socket room) |
| `myImage` | String | Profile image path |
| `myName` | String | User name |
| `myEmail` | String | User email |
| `myRole` | String | User role |
| `isDark` | bool | Theme preference (ThemeController) |

## 11.2 GetStorage

| Key | Purpose |
|-----|---------|
| `isUserFirstTime` | First-launch onboarding flag |

## 11.3 Cookie Jar (File Storage)

Path: `{appDocuments}/cookies` — persistent HTTP cookies.

## 11.4 SQLite / Hive

**Not Found** — not used.

## 11.5 Caching Strategy

- **Images:** `cached_network_image` + `flutter_cache_manager`
- **API data:** In-memory controller state only; no offline DB cache
- **Cookies:** Persistent file jar

## 11.6 Offline Support

**Limited** — app requires network for all business operations. Offline shows `noInternetConnection` error (503). No offline queue for transactions.

---

# 12. Third Party Packages

| Package | Version (lock) | Purpose | Why Used | Alternative |
|---------|----------------|---------|----------|-------------|
| get | 4.7.3 | State, routing, DI | Lightweight all-in-one | Riverpod, Bloc |
| dio | 5.9.0 | HTTP client | Interceptors, multipart | http, chopper |
| dio_cookie_manager | 3.4.0 | Cookie on Dio | Session cookies | Manual headers |
| cookie_jar | 4.0.9 | Cookie persistence | File-based jar | — |
| firebase_core | 4.6.0 | Firebase init | Required for FCM | — |
| firebase_messaging | 16.1.3 | Push notifications | FCM integration | OneSignal |
| shared_preferences | 2.5.4 | Key-value storage | Token/flags | get_storage |
| get_storage | 2.1.1 | Fast storage | First-time flag | shared_preferences |
| cached_network_image | 3.4.1 | Image caching | Performance | NetworkImage |
| flutter_cache_manager | 3.4.1 | Cache manager | Image cache | — |
| geolocator | 10.1.0 | GPS location | Shop location | location |
| mobile_scanner | 7.2.0 | QR scanning | Sales flow | qr_code_scanner |
| image_picker | 1.2.1 | Photo picker | Profile/shop images | file_picker |
| fl_chart | 1.2.0 | Charts | Dashboard | syncfusion charts |
| syncfusion_flutter_datepicker | 30.2.7 | Date picker | Date range filter | table_calendar |
| pin_code_fields | 8.0.1 | OTP input | OTP screens | flutter_otp_text_field |
| phone_form_field | 10.0.17 | Phone input | International phone | intl_phone_field |
| flutter_html | 3.0.0 | HTML render | Terms content | webview_flutter |
| socket_io_client | 3.1.3 | WebSocket | Real-time notifications | web_socket_channel |
| google_fonts | 6.3.3 | Typography | Outfit font family | Custom fonts |
| csc_picker_plus | 0.0.3 | Country/State/City | Profile edit | country_picker |
| skeletonizer | 2.1.0+1 | Loading skeleton | Image placeholders | shimmer |
| logger | 2.6.2 | Logging | API debug logs | dart:developer |
| intl | 0.20.2 | Formatting | Dates/numbers | — |
| path_provider | 2.1.5 | File paths | Cookie jar path | — |
| http | 1.2.2 | HTTP | Supplemental uploads | dio only |
| permission_handler | 11.3.1 | Permissions | Declared; geolocator handles location | — |
| device_preview | 1.3.1 | Dev preview | Non-release wrapper in main | — |
| dropdown_button2 | 2.3.9 | Dropdown | Sign-up form | Flutter DropdownButton |
| flutter_svg | 2.2.0 | SVG render | Visibility icons | — |
| smooth_page_indicator | 1.2.1 | Page dots | Onboarding | Custom |
| flutter_otp_text_field | 1.5.1+1 | OTP | Declared; pin_code_fields used | — |
| syncfusion_flutter_charts | 30.2.5 | Charts | Declared; fl_chart used | — |
| flutter_screenutil | 5.9.3 | Responsive | Declared; AppSize used | — |
| rename | 3.1.0 | CLI rename | Dev tool | — |
| change_app_package_name | 1.5.0 | CLI rename | Dev tool | — |

---

# 13. Environment Configuration

## 13.1 API Base URL

Configured via **compile-time** dart-define (not `.env` file):

```dart
String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.10.26.208:5004')
```

**File:** `lib/constant/app_api_end_point.dart`

## 13.2 Environment Examples

| Environment | API_BASE_URL |
|-------------|--------------|
| Development | `https://mlitech.thepigeonhub.com` |
| Staging | `http://31.97.117.41:5004` |
| Local default | `http://10.10.26.208:5004` |

## 13.3 Keys & Secrets (in source)

| Key | Location | Notes |
|-----|----------|-------|
| Google Maps API Key | `lib/constant/app_color/app_const.dart` | Hardcoded — rotate for production |
| Firebase API keys | `google-services.json`, `GoogleService-Info.plist` | Platform config files |

## 13.4 `.env` File

**Not Found** — project uses `--dart-define` instead of `flutter_dotenv`.

## 13.5 Build Variables

```bash
flutter run --dart-define=API_BASE_URL=https://your-api-url.com
flutter build apk --release --dart-define=API_BASE_URL=https://your-api-url.com
```

## 13.6 Configuration Process

1. Set `API_BASE_URL` for target environment
2. Ensure Firebase config files match Firebase project
3. Verify Google Maps API key has Geocoding, Places, Static Maps enabled
4. Run `flutter pub get`
5. Build with appropriate signing config

---

# 14. Assets

## 14.1 Asset Declaration (`pubspec.yaml`)

```yaml
assets:
  - assets/images/
  - assets/icon/
```

## 14.2 Images (`assets/images/`)

| File | Usage |
|------|-------|
| `background.webp` | Auth background |
| `coin_image.webp`, `coin_2_image.webp` | Onboarding |
| `store_image.png` | Onboarding store |
| `forgot_password_image.webp` | Forgot password |
| `otp_image.webp` | OTP screens |
| `reset_password.webp` | Reset password |
| `create_new_pass_image.webp` | Create password |
| `location_image.webp` | Location setup |
| `profile_image.webp` | Profile placeholder |
| `icGoldSub.webp` | Subscription |
| `subscription_thanks.webp` | Subscription thanks |
| `change_pass_img.webp` | Change password |
| `delete_box.png` | Delete account dialog |
| `Rewards.png`, `Sales.png`, `User.png`, `Points.png` | Dashboard stat icons |
| `logout.png` | Logout |
| `homeNavImage.webp`, `sellNavImage.png`, etc. | Bottom nav icons |
| `placeholder.png` | Image placeholder |
| `theme_dark.png`, `theme_light.png` | Theme preview |

## 14.3 Icons (`assets/icon/`)

| File | Usage |
|------|-------|
| `visibility_on.svg` | Password visibility |
| `visibility_off.svg` | Password hidden |

## 14.4 Fonts

**Google Fonts** — `Outfit` family via `google_fonts` package (no local font files).

## 14.5 Lottie / SVG / Video

| Type | Status |
|------|--------|
| Lottie | Not Found |
| SVG | 2 visibility icons |
| Video | Not Found |

## 14.6 Localization Files

**Not Found** — no ARB or JSON locale files.

---

# 15. Build Instructions

## 15.1 Prerequisites

- Flutter 3.35.6 (FVM: `.fvm/release`)
- Dart >=3.9.0
- Android Studio / Xcode
- JDK 11+ (CI uses JDK 17)

## 15.2 Common Steps

```bash
cd merchent
flutter clean
flutter pub get
```

## 15.3 Android — Debug

```bash
flutter run --dart-define=API_BASE_URL=https://mlitech.thepigeonhub.com
```

## 15.4 Android — Release APK

```bash
flutter build apk --release --dart-define=API_BASE_URL=<production-url>
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## 15.5 Android — Release AAB (Play Store)

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=<production-url>
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## 15.6 Android Signing

**Current state:** Release builds use **debug signing** (`android/app/build.gradle.kts`).

**Before Play Store:** Configure release keystore in `build.gradle.kts`:

```kotlin
signingConfigs {
    create("release") {
        storeFile = file("path/to/keystore.jks")
        storePassword = "..."
        keyAlias = "..."
        keyPassword = "..."
    }
}
buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

## 15.7 iOS — Setup

```bash
cd ios && pod install && cd ..
```

## 15.8 iOS — Debug / Release

```bash
flutter build ios --release --dart-define=API_BASE_URL=<production-url>
```

## 15.9 iOS — Archive / IPA

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select signing team and provisioning profile
3. Product → Archive
4. Distribute to App Store or export IPA

**CI workaround** (`.github/workflows/main.yml`):

```bash
flutter build ios --no-codesign
cd build/ios/iphoneos && mkdir Payload && ln -s ../Runner.app Payload/ && zip -r app.ipa Payload
```

## 15.10 Code Generation

**Not Found** — no `build_runner`, freezed, or json_serializable code generation.

---

# 16. Deployment Guide

## 16.1 Google Play Store

1. Configure release signing keystore
2. Build AAB: `flutter build appbundle --release --dart-define=API_BASE_URL=<prod>`
3. Upload to Google Play Console
4. Complete store listing, content rating, privacy policy URL
5. Submit for review

## 16.2 Apple App Store

1. Configure certificates and provisioning profiles in Apple Developer
2. Archive in Xcode with distribution certificate
3. Upload via Transporter or Xcode Organizer
4. Complete App Store Connect metadata
5. Submit for review

## 16.3 Firebase App Distribution

**Not configured** in project. Can be added via Firebase Console for internal testing.

## 16.4 Manual APK Distribution

Build APK and distribute directly:

```bash
flutter build apk --release --split-per-abi --dart-define=API_BASE_URL=<prod>
```

## 16.5 CI/CD (GitHub Actions)

**File:** `.github/workflows/main.yml`

| Trigger | Branches |
|---------|----------|
| push | main, master, develop |
| pull_request | main, master |

**Steps:**
1. Checkout on `macos-latest`
2. Setup Java 17 (Zulu)
3. Setup Flutter stable
4. `flutter build apk --release --split-per-abi`
5. `flutter build ios --no-codesign` + zip IPA
6. Release via `ncipollo/release-action` with tag `v1.0.{run_number}`

**Note:** CI does **not** pass `--dart-define=API_BASE_URL` — uses default fallback URL.

---

# 17. Configuration Required Before Running

| Item | Action Required |
|------|-----------------|
| **API_BASE_URL** | Pass via `--dart-define` for each environment |
| **Firebase** | Ensure `google-services.json` and `GoogleService-Info.plist` match project |
| **Google Maps API Key** | Update `AppConst.googleMapsApiKey`; enable Geocoding, Places, Static Maps APIs |
| **Android Signing** | Configure release keystore before Play Store |
| **iOS Signing** | Certificates + provisioning profiles in Xcode |
| **FCM** | Firebase project with Cloud Messaging enabled |
| **Backend Server** | Node.js MILitech API must be running and reachable |
| **Socket.IO** | Backend must expose Socket.IO on same domain as API |
| **App Transport Security (iOS)** | `NSAllowsArbitraryLoads` is `true` — restrict for production |

---

# 18. Admin Panel Integration

## 18.1 Overview

The merchant app is the **client-facing mobile front-end** for the MILitech loyalty platform. Platform administration is handled by a separate **Node.js admin panel** (not included in this repository).

## 18.2 Relationship

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│  Merchant App   │◄───────►│  Node.js Backend │◄───────►│   Admin Panel   │
│  (this project) │  REST   │  /api/v1/*       │  REST   │  (separate)     │
│                 │  Socket │  Socket.IO       │         │                 │
└─────────────────┘         └──────────────────┘         └─────────────────┘
```

## 18.3 Communication

| Channel | Usage |
|---------|-------|
| REST API | All CRUD, auth, sales, notifications |
| Socket.IO | Real-time notifications to merchant |
| FCM | Push notifications from backend via Firebase |

## 18.4 Admin-Controlled Data

- Promotions and gift cards (lookup via card code)
- Customer tiers and loyalty balances
- Disclaimer / terms content (`/disclaimers/merchant-{type}`)
- Notification broadcasts

## 18.5 Required Configuration

- Backend must register merchant users with role `MERCENT`
- FCM server key configured on backend for push
- Socket.IO must support `join_user_room` and `newNotification` events

---

# 19. Security

## 19.1 Authentication

JWT Bearer tokens with refresh token rotation. HTTP session cookies via persistent cookie jar.

## 19.2 Authorization

Role stored as `myRole` (e.g. `MERCENT`). Backend enforces authorization; app displays role-appropriate UI.

## 19.3 Data Encryption

- **In transit:** HTTPS expected for production API (ATS allows arbitrary loads on iOS — review for production)
- **At rest:** SharedPreferences not encrypted

## 19.4 Token Security

| Risk | Mitigation Recommendation |
|------|---------------------------|
| Tokens in SharedPreferences | Migrate to `flutter_secure_storage` |
| API keys in source | Move to dart-define or remote config |
| Debug logging of tokens | Disabled in release (`kDebugMode`) |

## 19.5 Storage Security

Cookie jar stored in app documents directory. Cleared on logout.

## 19.6 Input Validation

Client-side validation on forms (email, password rules, phone format). Server-side validation assumed on backend.

## 19.7 API Protection

- Bearer token on authenticated requests
- 401 auto-refresh with single retry
- No certificate pinning implemented

---

# 20. Error Handling

## 20.1 Exception Handling

`ApiService.handleError()` centralizes Dio, Socket, Timeout, and Format exceptions into `ApiResponseModel`.

## 20.2 API Errors

API `message` field displayed via snackbars and controller error state.

## 20.3 Internet Errors

`DioExceptionType.connectionError` → 503 with `noInternetConnection` message.

## 20.4 Timeout

120-second timeouts on connect/send/receive. Timeout → 408.

## 20.5 Fallback Strategy

- Token refresh on 401
- Logout on refresh failure
- No offline fallback for API calls

## 20.6 Logging

- `logger` package in `ApiService` (debug only)
- `appLog` / `errorLog` utilities throughout app

---

# 21. Performance Optimizations

| Area | Implementation |
|------|----------------|
| Image Optimization | WebP assets, `cached_network_image` |
| Lazy Loading | Infinite scroll pagination on lists |
| Pagination | `page` + `limit` query params (default limit: 10) |
| Caching | Image cache manager, cookie jar |
| Memory | Controller disposal in `onClose()` |
| Widget Optimization | `Obx` for targeted rebuilds |
| Build | `--split-per-abi` in CI for smaller APKs |

---

# 22. Known Issues

| Issue | Severity | Details |
|-------|----------|---------|
| Release signing uses debug keys | High | Must configure before Play Store |
| CI missing API_BASE_URL dart-define | Medium | Builds use default local URL |
| Tokens in SharedPreferences | Medium | Not encrypted at rest |
| Google Maps API key hardcoded | Medium | Security exposure risk |
| iOS ATS arbitrary loads enabled | Medium | Allows non-HTTPS connections |
| `firebase_options.dart` Android unsupported | Low | Android uses `google-services.json` instead |
| Unused route constants | Low | Dead routes in `app_routes.dart` |
| Privacy policy API endpoint unused | Low | Static text used instead |
| `device_preview` in non-release main | Low | Dev wrapper in production debug builds |
| Subscription screens have no payment API | Info | UI-only placeholder |
| Typo in folder names (`chnage_*`) | Low | Cosmetic naming inconsistency |

## 22.1 Technical Debt

- No formal Bindings for dependency injection
- Mixed controller/repository pattern (some repositories extend GetxController)
- No unit/widget integration tests found
- No localization support
- No certificate pinning

## 22.2 Workarounds

| Issue | Workaround |
|-------|------------|
| 401 session expired | User must re-login after refresh failure |
| QR scanner permission | Grant camera permission in device settings |
| Location stuck | Enable GPS and location permission |

---

# 23. Future Improvements

1. **Security:** Adopt `flutter_secure_storage` for tokens; remove hardcoded API keys
2. **Environment:** Add `flutter_dotenv` or CI dart-define for all secrets
3. **Testing:** Add unit tests for repositories and widget tests for critical flows
4. **Localization:** Implement i18n for multi-language support
5. **Offline:** Queue failed transactions for retry when connectivity returns
6. **Analytics:** Integrate Firebase Analytics and Crashlytics
7. **Certificate Pinning:** Pin API server certificate for production
8. **Clean Architecture:** Separate domain layer with use cases
9. **Payment Integration:** Connect subscription screens to payment gateway
10. **Code Generation:** Use `freezed` + `json_serializable` for models
11. **Route Guards:** Implement GetX middleware for auth-protected routes
12. **Remove dead code:** Unregistered routes, unused API endpoints, unused packages

---

# 24. Project Maintenance Guide

## 24.1 Update Dependencies

```bash
flutter pub outdated
flutter pub upgrade
flutter pub get
```

Review breaking changes for major version bumps (Firebase, Dio, GetX).

## 24.2 Upgrade Flutter

```bash
fvm install 3.x.x
fvm use 3.x.x
flutter doctor
flutter clean && flutter pub get
```

## 24.3 Change API URL

Update build/run commands with new `--dart-define=API_BASE_URL=...`. Do not hardcode in Dart files.

## 24.4 Add a New Screen

1. Create folder under `lib/screen/feature_name/`
2. Add controller, screen widget, models
3. Add route constant in `app_routes.dart`
4. Register `GetPage` in `app_routes_file.dart`
5. Create repository in `lib/service/repository/` if API needed
6. Add endpoint in `app_api_end_point.dart`

## 24.5 Add a New Feature / API

1. Define endpoint in `app_api_end_point.dart`
2. Create repository calling `ApiService`
3. Create controller with business logic
4. Build UI screen
5. Wire navigation

## 24.6 Release Updates

1. Bump version in `pubspec.yaml` (`version: x.y.z+build`)
2. Update changelog
3. Build with production `API_BASE_URL`
4. Test on physical devices
5. Upload to Play Store / App Store

---

# 25. Backup & Restore

| Asset | Backup Method |
|-------|---------------|
| Source Code | Git repository (remote: verify origin URL) |
| Assets | Included in repo under `assets/` |
| Firebase Config | `google-services.json`, `GoogleService-Info.plist`, Firebase Console export |
| API Keys | Secure vault (not in repo) — Google Cloud Console, Firebase Console |
| Signing Keys | Secure offline backup of Android keystore + iOS certificates |
| Environment Config | Document `API_BASE_URL` per environment |
| Database | N/A (no local DB) — backend database backup is server-side |
| CI Secrets | GitHub `TOKEN` secret for release action |

---

# 26. Delivery Checklist

- [x] Source Code (Flutter project)
- [ ] APK (build required)
- [ ] AAB (build required with release signing)
- [x] Documentation (this document)
- [x] Assets (`assets/images/`, `assets/icon/`)
- [ ] API Collection (Postman — not in repo; document endpoints in Section 8)
- [x] Firebase Config (`google-services.json`, `GoogleService-Info.plist`)
- [x] Environment Instructions (`API_BASE_URL_SETUP_INSTRUCTIONS.txt`)
- [ ] Release Notes (to be prepared per release)
- [x] Version (`1.0.0+1` in `pubspec.yaml`)
- [x] README.md

---

# 27. Changelog

Derived from Git commit history:

| Version / Date | Changes |
|----------------|---------|
| Latest | Google Maps API key moved to `AppConst`; location/profile controllers refactored |
| — | API base URL security fix; README enhanced; Info.plist network security |
| — | Dependency upgrades; `NonAuthApiService`; cookie management with `dio_cookie_manager` |
| — | API endpoint path corrections; theme reset on logout |
| — | CI/CD GitHub Actions workflow added |
| — | Home screen and profile screen refactored; production API URL |
| — | Location controller address resolution improvements |
| — | Profile screen CSC picker, street address, coordinates |
| — | Customer profile labels updated ("Points Redeemed", "Input Sales") |
| — | Pie chart fixes; iOS build readiness |
| — | Bar chart fixes; pagination implementation |
| — | Sign-up and OTP flow corrections |
| — | Transaction and location bug fixes |
| — | Onboarding fixes |

---

# 28. Contact Information

| Field | Value |
|-------|-------|
| **Client** | Miltech |
| **Project** | MILitech Merchant |
| **Developer / Company** | As per project contract *(update with actual vendor details)* |
| **Email** | *(To be provided by client/vendor)* |
| **Phone** | *(To be provided by client/vendor)* |
| **Support Hours** | *(To be defined in SLA)* |

---

# 29. Appendix

## 29.1 Useful Flutter Commands

```bash
# Environment check
flutter doctor -v

# Dependencies
flutter pub get
flutter pub outdated

# Clean build
flutter clean && flutter pub get

# Run with API URL
flutter run --dart-define=API_BASE_URL=https://mlitech.thepigeonhub.com

# Build APK
flutter build apk --release --dart-define=API_BASE_URL=<url>

# Build AAB
flutter build appbundle --release --dart-define=API_BASE_URL=<url>

# Build iOS
flutter build ios --release --dart-define=API_BASE_URL=<url>

# Firebase reconfigure
flutterfire configure

# FVM
fvm use 3.35.6
fvm flutter run
```

## 29.2 Git Commands

```bash
git clone <repository-url>
git checkout main
git pull origin main
git status
git log --oneline -20
```

## 29.3 Troubleshooting

| Problem | Solution |
|---------|----------|
| API calls fail | Verify `--dart-define=API_BASE_URL` |
| 401 / session expired | Check token refresh; re-login if needed |
| Push notifications not working | Verify Firebase config and FCM on backend |
| QR scanner fails | Grant camera permission |
| Location screen stuck | Enable GPS and location permission |
| Build fails after dependency change | `flutter clean && flutter pub get` |
| iOS pod errors | `cd ios && pod deintegrate && pod install` |
| Cookie/session issues | Clear app data or reinstall |

## 29.4 Useful Links

| Resource | URL |
|----------|-----|
| Flutter Documentation | https://docs.flutter.dev |
| GetX Documentation | https://pub.dev/packages/get |
| Dio Documentation | https://pub.dev/packages/dio |
| Firebase Flutter Setup | https://firebase.google.com/docs/flutter/setup |
| Google Play Console | https://play.google.com/console |
| Apple Developer | https://developer.apple.com |

## 29.5 Platform Permissions

### Android (`AndroidManifest.xml`)

- `INTERNET`
- `ACCESS_COARSE_LOCATION`, `ACCESS_FINE_LOCATION`
- `CAMERA`
- `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`

### iOS (`Info.plist`)

- `NSCameraUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `NSPhotoLibraryAddUsageDescription`

---

**End of Document**

*Document generated for MILitech Merchant project handover. For questions or updates, contact the development team.*
