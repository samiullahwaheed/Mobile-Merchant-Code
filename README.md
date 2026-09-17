# MILitech Merchant

A Flutter mobile application for **store owners / merchants** on the MILitech loyalty platform. Merchants can manage sales, scan customer QR codes, view dashboard analytics, handle transactions, and manage their shop profile.

| Item | Value |
|------|-------|
| **Package name** | `merchent` |
| **Android application ID** | `com.miltech.merchent` |
| **iOS display name** | Merchent |
| **Flutter SDK** | `^3.8.1` |
| **State management** | GetX |
| **Networking** | Dio + cookie-based auth |

---

## Table of Contents

1. [Features](#features)
2. [Prerequisites](#prerequisites)
3. [Getting Started](#getting-started)
4. [API Base URL Configuration](#api-base-url-configuration)
5. [Build & Release](#build--release)
6. [Firebase Setup](#firebase-setup)
7. [Project Architecture](#project-architecture)
8. [Folder & File Structure](#folder--file-structure)
9. [Navigation & Auth Flow](#navigation--auth-flow)
10. [Dependencies (Packages)](#dependencies-packages)
11. [Removed Packages](#removed-packages)
12. [Platform Permissions](#platform-permissions)
13. [Troubleshooting](#troubleshooting)

---

## Features

- **Authentication** — Sign up, sign in, OTP verification, forgot/reset password
- **Onboarding** — First-time user walkthrough
- **Shop setup** — Location (GPS), shop/business information
- **Dashboard** — Sales stats, bar chart (weekly sales), pie chart (customer distribution)
- **Sales management** — QR code scanner to identify customers, sell/checkout flow
- **Customer management** — Customer list, profile, transaction history, tier info
- **New transaction** — Gift card / promotion lookup and checkout
- **Notifications** — Push notifications (Firebase) + real-time updates (Socket.IO)
- **Profile** — View/edit profile, change password, contact us, terms & privacy policy
- **Account** — Delete account support

---

## Prerequisites

Install the following before running the project:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (compatible with Dart `^3.8.1`)
- Android Studio / Xcode (for mobile builds)
- A running MILitech backend API server
- Firebase project configured for push notifications (see [Firebase Setup](#firebase-setup))

Verify your environment:

```bash
flutter doctor
```

---

## Getting Started

### 1. Clone and install dependencies

```bash
cd merchent
flutter pub get
```

### 2. Run the app (development)

```bash
flutter run --dart-define=API_BASE_URL=https://mlitech.thepigeonhub.com
```

Replace the URL with your target backend environment.

### 3. Run on a specific device

```bash
flutter devices
flutter run -d <device_id> --dart-define=API_BASE_URL=<your-api-url>
```

---

## API Base URL Configuration

The API base URL is **not hardcoded** in source code. It is injected at compile time via `--dart-define`.

**Configuration file:** `lib/constant/app_api_end_point.dart`

```dart
String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.10.26.208:5004')
```

All API calls use: `{API_BASE_URL}/api/v1/...`

### Environment examples

| Environment | Command |
|-------------|---------|
| Development | `flutter run --dart-define=API_BASE_URL=https://mlitech.thepigeonhub.com` |
| Staging | `flutter run --release --dart-define=API_BASE_URL=http://31.97.117.41:5004` |
| Production APK | `flutter build apk --release --dart-define=API_BASE_URL=http://31.97.117.41:5004` |
| Production App Bundle | `flutter build appbundle --release --dart-define=API_BASE_URL=https://mlitech.thepigeonhub.com` |

> **CI/CD tip:** Store `API_BASE_URL` as a pipeline environment variable and pass it with `--dart-define=API_BASE_URL=$API_BASE_URL` at build time. Never commit production URLs into Dart source files.

See also: `API_BASE_URL_SETUP_INSTRUCTIONS.txt`

---

## Build & Release

### Android APK

```bash
flutter build apk --release --dart-define=API_BASE_URL=<your-production-url>
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (Play Store)

```bash
flutter build appbundle --release --dart-define=API_BASE_URL=<your-production-url>
```

### iOS

```bash
flutter build ios --release --dart-define=API_BASE_URL=<your-production-url>
```

> **Note:** Release signing for Android currently uses debug keys (`android/app/build.gradle.kts`). Configure a proper release signing config before publishing to the Play Store.

---

## Firebase Setup

The app uses Firebase Cloud Messaging (FCM) for push notifications.

| File | Purpose |
|------|---------|
| `lib/firebase_options.dart` | Auto-generated Firebase config |
| `android/app/google-services.json` | Android Firebase config |
| `ios/Runner/GoogleService-Info.plist` | iOS Firebase config |

**Initialization** happens in `lib/main.dart`:
- `Firebase.initializeApp()`
- `FirebaseMessaging.onBackgroundMessage(...)`
- FCM token is synced to the backend on splash via `SplashController.getFCMToken()`

To regenerate Firebase options after changing the Firebase project:

```bash
flutterfire configure
```

---

## Project Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      UI Layer                           │
│  screen/  →  Screens, widgets, GetX controllers         │
├─────────────────────────────────────────────────────────┤
│                   Routing Layer                         │
│  routes/  →  AppRoutes (paths) + app_routes_file (pages)│
├─────────────────────────────────────────────────────────┤
│                   Service Layer                         │
│  service/repository/  →  API call wrappers per feature  │
│  service/api_service/   →  Dio client, cookies, models    │
│  service/storage/     →  SharedPreferences, GetStorage  │
│  service/sockets/     →  Socket.IO real-time events     │
├─────────────────────────────────────────────────────────┤
│                   Core / Shared                         │
│  constant/  widget/  utils/                             │
└─────────────────────────────────────────────────────────┘
```

### Key patterns

- **GetX** — State management (`GetxController`), reactive UI (`Obx`), navigation (`Get.toNamed`)
- **Repository pattern** — Each feature has a repository in `service/repository/` that calls `ApiService` or `NonAuthApiService`
- **Cookie-based auth** — `CookieService` + `dio_cookie_manager` persist session cookies; tokens also stored in `SharedPreferences` via `LocalStorage`
- **Auto token refresh** — `ApiService` intercepts 401 responses and calls `RefreshTokenRepository`

---

## Folder & File Structure

```
merchent/
├── android/                  # Android native project (Gradle, manifest, google-services)
├── ios/                      # iOS native project (Xcode, Info.plist, Firebase plist)
├── assets/
│   ├── images/               # App images (onboarding, nav icons, placeholders)
│   └── icon/                 # SVG icons (visibility toggle)
├── lib/
│   ├── main.dart             # App entry — Firebase, cookies, GetStorage init
│   ├── my_app.dart           # GetMaterialApp root widget, theme, routes
│   ├── firebase_options.dart # Firebase platform configuration
│   │
│   ├── constant/
│   │   ├── app_api_end_point.dart   # All REST API endpoint paths + base URL
│   │   ├── app_color/               # Theme colors, AppTheme, ThemeController
│   │   ├── app_image_path.dart      # Asset image path constants
│   │   └── app_icons_path.dart      # Asset icon path constants
│   │
│   ├── routes/
│   │   ├── app_routes.dart          # Route name constants
│   │   └── app_routes_file.dart     # GetPage route definitions
│   │
│   ├── screen/                      # Feature screens (UI + controllers + models)
│   │   ├── splash_screen/           # Splash + auth routing logic
│   │   ├── onboarding_screen/       # First-time onboarding carousel
│   │   ├── app_navigation_screen/   # Bottom navigation shell (4 tabs)
│   │   ├── home_screen/             # Dashboard, charts, stats
│   │   ├── sales_management_screen/ # Sales list, QR scanner
│   │   ├── customer_details_screen/ # Customer table/list
│   │   ├── customer_profile_screen/ # Individual customer profile
│   │   ├── new_transaction_screen/  # Gift card lookup + checkout
│   │   ├── sell_details_screen/     # Sale detail view
│   │   ├── total_summary_screen/     # Transaction summary
│   │   ├── notification_screen/     # Push + socket notifications
│   │   ├── contact_us_screen/       # Contact form
│   │   ├── terms_condition_screen/  # Terms (HTML rendered)
│   │   ├── privacy_policy_screen/   # Privacy policy
│   │   ├── datetime_picker_screen.dart # Shared date picker
│   │   ├── common_widget/           # Shared screen-level widgets
│   │   ├── auth/                    # Full auth & onboarding flow
│   │   │   ├── sign_in_screen/
│   │   │   ├── sign_up_screen/
│   │   │   ├── verify_otp_screen/
│   │   │   ├── forgot_password/
│   │   │   ├── forgot_verify_otp_screen/
│   │   │   ├── reset_password_screen/
│   │   │   ├── create_password_screen/
│   │   │   ├── location_screen/
│   │   │   ├── shop_information_screen/
│   │   │   ├── subscription/
│   │   │   ├── authentications_screen.dart
│   │   │   └── all_set_screen.dart
│   │   └── profile_section/
│   │       ├── profile_screen/
│   │       ├── chnage_profile_info/
│   │       └── chnage_pass_screen/
│   │
│   ├── service/
│   │   ├── api_service/
│   │   │   ├── api_services.dart        # Main Dio HTTP client (auth APIs)
│   │   │   ├── non_auth_api.dart        # Dio client for pre-login APIs
│   │   │   ├── non_auth_api_service.dart
│   │   │   ├── cookie_service.dart      # Persistent cookie jar
│   │   │   └── service_model/           # ApiResponseModel
│   │   ├── repository/                  # Per-feature API repositories
│   │   │   ├── auth_repository/         # Login, signup, OTP, password, location
│   │   │   ├── home_screen_repository/  # Dashboard data
│   │   │   ├── promotion_repository/
│   │   │   └── ...                      # checkout, notifications, profile, etc.
│   │   ├── storage/
│   │   │   ├── storage_service.dart     # SharedPreferences (LocalStorage)
│   │   │   ├── get_storage_services.dart# GetStorage (first-time flag)
│   │   │   └── storage_key.dart         # Storage key constants
│   │   └── sockets/
│   │       └── app_socket_all_operation.dart  # Socket.IO client
│   │
│   ├── widget/                          # Reusable UI components
│   │   ├── app_image/                   # Network image + cache + skeleton
│   │   ├── text_field_widget/           # Custom inputs, phone field
│   │   ├── appbar_widget/
│   │   ├── app_snack_bar/
│   │   ├── app_button/
│   │   └── ...
│   │
│   └── utils/
│       ├── app_size.dart                # Responsive sizing helpers
│       ├── app_log/                     # Logging utilities
│       ├── local_database/prefs_helper.dart
│       └── app_translation/             # Static API response keys
│
├── pubspec.yaml           # Dependencies and assets
├── API_BASE_URL_SETUP_INSTRUCTIONS.txt
└── README.md
```

---

## Navigation & Auth Flow

### Bottom navigation (main app)

After login and setup, users land on `NavigationScreen` with 4 tabs:

| Tab | Screen | Purpose |
|-----|--------|---------|
| 0 | `HomeScreen` | Dashboard, charts, weekly stats |
| 1 | `SalesManagementScreen` | Sales list, QR scanner |
| 2 | `CustomerTableScreen` | Customer list |
| 3 | `ProfileScreen` | Profile, settings, logout |

### Splash routing logic (`SplashController`)

```
Splash
  ├─ No token → First time? → Onboarding / Auth screen
  ├─ Has token → Fetch profile
  │     ├─ Location not set → LocationScreen
  │     ├─ Business info not set → ShopInformationScreen
  │     └─ All complete → Bottom navigation (Home)
```

### Auth screens route map

| Route constant | Screen |
|----------------|--------|
| `/onboarding` | Onboarding carousel |
| `/authenticationsScreen` | Auth entry (sign in / sign up) |
| `/signInScreen` | Sign in |
| `/SignUpScreen` | Sign up |
| `/createPassVerifyOtpScreen` | OTP after signup |
| `/forgotPasswordScreen` | Forgot password |
| `/forgotPassVerifyOtpScreen` | OTP for password reset |
| `/resetPasswordScreen` | Reset password |
| `/locationScreen` | GPS location setup |
| `/shopInformationScreen` | Business/shop details |
| `/bottomNav` | Main app (bottom nav) |

---

## Dependencies (Packages)

### Core & UI

| Package | Why it is used |
|---------|----------------|
| `get` | State management (`GetxController`), routing (`GetMaterialApp`, `GetPage`), dependency injection (`Get.put`) |
| `cupertino_icons` | iOS-style icon set (Flutter default) |
| `google_fonts` | Custom typography across the app |
| `dropdown_button2` | Styled dropdown in sign-up form (`sign_up_screen/widget/dropdown_widget.dart`) |
| `pin_code_fields` | OTP input UI on verify OTP screens |
| `phone_form_field` | International phone number input with country picker |
| `flutter_html` | Renders HTML content on Terms & Conditions screen |
| `skeletonizer` | Loading skeleton placeholders for network images |

### Charts & Data Visualization

| Package | Why it is used |
|---------|----------------|
| `fl_chart` | Bar chart (weekly sales) and pie chart (customer stats) on home dashboard |
| `intl` | Date/number formatting in charts and screens |

### Networking & API

| Package | Why it is used |
|---------|----------------|
| `dio` | Primary HTTP client for all REST API calls |
| `dio_cookie_manager` | Attaches cookie jar to Dio for session management |
| `cookie_jar` | Stores auth cookies persistently |
| `path_provider` | File path for cookie jar storage on device |
| `http` | Multipart/form-data uploads (profile image, shop info) |
| `logger` | Structured API request/response logging in `ApiService` |
| `socket_io_client` | Real-time Socket.IO connection for live notifications |

### Images & Media

| Package | Why it is used |
|---------|----------------|
| `cached_network_image` | Efficient network image loading with cache |
| `flutter_cache_manager` | Custom cache manager for image assets |
| `image_picker` | Pick profile/shop images from gallery or camera |

### Location & Scanner

| Package | Why it is used |
|---------|----------------|
| `geolocator` | GPS location for shop location setup |
| `csc_picker_plus` | Country / State / City picker on profile edit screen |
| `mobile_scanner` | QR code scanner in sales management flow |

### Date Picker

| Package | Why it is used |
|---------|----------------|
| `syncfusion_flutter_datepicker` | Date range picker (`datetime_picker_screen.dart`) |

### Local Storage

| Package | Why it is used |
|---------|----------------|
| `shared_preferences` | Token, user ID, flags (`LocalStorage` in `storage_service.dart`) |
| `get_storage` | Lightweight storage for first-time user flag (`GetStorageServices`) |

### Firebase

| Package | Why it is used |
|---------|----------------|
| `firebase_core` | Firebase SDK initialization |
| `firebase_messaging` | Push notifications + FCM token sync to backend |

---

## Removed Packages

The following packages were removed because they were **not used** anywhere in the codebase:

| Package | Reason removed |
|---------|----------------|
| `flutter_svg` | No SVG rendering in code (visibility icons use Material `Icons`) |
| `smooth_page_indicator` | Onboarding uses custom page dots, not this package |
| `flutter_otp_text_field` | OTP uses `pin_code_fields` instead |
| `syncfusion_flutter_charts` | Charts use `fl_chart`, not Syncfusion charts |
| `flutter_screenutil` | Responsive sizing handled by custom `AppSize` utility |
| `permission_handler` | Not imported; `geolocator` handles location permission internally |
| `device_preview` | Dev-only preview wrapper; removed from `main.dart` |
| `rename` | CLI tool for renaming app — not a runtime dependency |
| `change_app_package_name` | CLI tool for changing package ID — not a runtime dependency |

After pulling these changes, run:

```bash
flutter pub get
```

---

## Platform Permissions

### iOS (`ios/Runner/Info.plist`)

- **Camera** — QR code scanning
- **Location (When In Use)** — Shop location setup
- **Photo Library** — Image upload for profile/shop

### Android

Permissions are declared in `android/app/src/main/AndroidManifest.xml` for camera, location, and storage as required by `mobile_scanner`, `geolocator`, and `image_picker`.

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| API calls fail / wrong server | Verify `--dart-define=API_BASE_URL=...` matches your backend |
| 401 / session expired | Check cookie persistence; token refresh runs via `RefreshTokenRepository` |
| Push notifications not working | Verify `google-services.json` / `GoogleService-Info.plist` and FCM setup |
| QR scanner not working | Ensure camera permission is granted on device |
| Location screen stuck | Check GPS is enabled and location permission is granted |
| Build fails after dependency change | Run `flutter clean && flutter pub get` |

---

## API Endpoints Reference

All endpoints are defined in `lib/constant/app_api_end_point.dart`. Base pattern: `{API_BASE_URL}/api/v1/{endpoint}`

Key endpoint groups:
- **Auth** — `/auth/login`, `/auth/verify-otp`, `/auth/forgot-password`, `/auth/refresh-token`
- **User** — `/user`, `/user/profile`
- **Merchant** — `/merchant/merchant-dashboard-report`, `/merchant/weekly-sell-report`
- **Sales** — `/sell/checkout`, `/sell/transactions/{id}`, `/sell/merchant`
- **Promotions** — `/add-promotion/find?cardCode=XXX`, `/sell/promotion/request-approval`
- **Notifications** — `/notifications`, `/notifications/read`
- **Others** — `/others/privacy-policy`, `/others/terms-and-conditions`, `/contact`

---

## Contact & Handover Notes

- **Backend dependency:** This app requires the MILitech merchant API server to be running and reachable.
- **Environment injection:** Always pass `API_BASE_URL` at build/run time — do not hardcode production URLs in Dart files.
- **Signing:** Configure proper Android release signing before Play Store deployment.
- **Real-time:** Socket.IO connects using the same base domain; token is sent in socket auth headers.
- **State flags:** `LocalStorage.isLocation` and `LocalStorage.isBusiness` control post-login onboarding redirects.

---

*Last updated: June 2026*
