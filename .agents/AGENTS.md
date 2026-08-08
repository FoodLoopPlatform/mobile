# Foodloop – Agent Context File

> **Purpose**: This file persists all project-specific instructions across chat sessions so the agent does not need to be re-briefed every time.

---

## Project Overview
**App Name**: Foodloop  
**Platform**: Flutter (Android + iOS)  
**Description**: A food surplus marketplace connecting businesses with excess food to consumers looking for affordable, fresh options in Egypt. The goal is to reduce food waste and make fresh food more affordable.  

---

## Design System

### Color Palette (`AppColors`)
All colors must be referenced from `lib/core/utils/app_colors.dart` — **never use hardcoded Color() values in widgets**.
- **Primary**: `#005129` (Deep Forest Green)
- **Secondary**: `#006D38` (Medium Green)
- **Tertiary**: `#643E00` (Warm Brown)
- **Neutral**: `#747873` (Muted Gray-Green)
- **Background**: `#F5F5EC` (Off-White / Cream)
- **Surface**: `#FFFFFF`
- **Error**: `#B00020`

### Typography
- Headline font: **Playfair Display** (serif, for large titles)
- Body font: **DM Sans** (sans-serif, for all body text and labels)
- Label/Mono font: **JetBrains Mono** (monospace, for codes, timers, tags)
- Font files are placed in `assets/fonts/` — configuration in `pubspec.yaml` is done by the user.

### Strings (`AppStrings`)
All UI text must be referenced from `lib/core/utils/app_strings.dart` — **never hardcode strings directly in widget files**.
- The `AppStrings` class uses dynamic getters to fetch the string for the active language.
- The actual translated strings are maintained as Maps in `lib/core/utils/lang/ar.dart` and `en.dart`.

---

## Architecture

### Folder Structure (mirrors mini_InstaPay pattern)
```
lib/
├── core/
│   ├── app_theme/
│   │   └── app_theme_manager.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   └── business_details_model.dart
│   ├── routes_manager/
│   │   ├── route_generator.dart
│   │   └── routes_names.dart
│   ├── utils/
│   │   ├── app_colors.dart          ← All color tokens
│   │   ├── app_strings.dart         ← All localized strings
│   │   ├── app_assets.dart          ← All images and icons paths
│   │   ├── constants.dart           ← General app constants (padding, durations)
│   │   ├── api_constants.dart       ← API URLs and endpoint constants
│   │   └── validation.dart          ← Form validation helpers
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_outlined_button.dart
│       ├── custom_text_field.dart
│       └── custom_dropdown_field.dart
└── features/
    ├── navigation/
    │   └── presentation/
    │       └── views/
    │           ├── main_navigation_view.dart
    │           └── widgets/
    │               └── custom_bottom_nav_bar.dart
    ├── market/
    │   └── presentation/
    │       └── views/
    │           └── market_view.dart
    ├── orders/
    │   └── presentation/
    │       └── views/
    │           └── orders_view.dart
    ├── cart/
    │   └── presentation/
    │       └── views/
    │           └── cart_view.dart
    ├── onboarding/
    │   └── presentation/
    │       └── views/
    │           └── welcome_view.dart
    └── auth/
        ├── data/
        │   ├── data_sources/
        │   │   └── auth_remote_data_source.dart
        │   ├── models/
        │   │   └── auth_model.dart
        │   └── repositories/
        │       └── auth_repository.dart
        └── presentation/
            ├── manager/
            │   └── auth_cubit/
            │       ├── auth_cubit.dart
            │       └── auth_state.dart
            └── views/
                ├── create_account_view.dart
                ├── business_details_view.dart
                ├── email_verification_view.dart
                └── widgets/
                    └── (screen-specific sub-widgets)
```

### State Management & API Integration
- **flutter_bloc (Cubit)** for state management — same pattern as mini_InstaPay.
- `AuthCubit` manages: account type selection, form validation, navigation triggers.
- The `CreateAccountView` uses a **StatefulWidget** body (via a `_CreateAccountBodyState`) so the account type dropdown can reactively show/hide the business details flow.
- Navigation to `BusinessDetailsView` is triggered when the user selects "Seller" or "Charity" as the account type and taps Continue. This is handled inside the Cubit or locally in the view using `setState` for the dropdown, and Navigator push for the screen transition.
- **Dio Interceptors**: We use an `AuthInterceptor` to inject the Bearer token into headers. It intercepts `401 Unauthorized` responses and automatically calls the `/auth/refresh` endpoint with the stored `refreshToken`. If successful, it updates the stored tokens and retries the failed request.

---

## Screens to Build (Auth Flow)
1. **WelcomeView** (`onboarding`) – Landing screen with Create Account / Log In.
2. **CreateAccountView** (`auth`) – Registration form. Account Type dropdown: `User` | `Seller` | `Charity`.
   - If **Seller** or **Charity** → navigate to `BusinessDetailsView` after Continue.
   - If **User** → navigate to `EmailVerificationView` after Continue.
3. **BusinessDetailsView** (`auth`) – Location + Legal Documents upload. Only for Sellers and Charities.
4. **EmailVerificationView** (`auth`) – Verification pending screen with countdown and back to login option.

---

## Screens to Build (Main App Flow)
1. **MainNavigationView** (`navigation`) – The shell screen managing the bottom navigation bar and tabs.
2. **MarketView** (`market`) – Main market feed (placeholder).
3. **OrdersView** (`orders`) – User/Seller orders list (placeholder).
4. **CartView** (`cart`) – User shopping cart (placeholder).
5. **ProfileView** (`profile`) – User profile and settings.

---

## Coding Rules
1. **Always use `AppColors`** for colors. Never write `Color(0xFF...)` in widget files.
2. **Always use `AppStrings`** for UI text. Never hardcode strings in widget files.
3. **Always use `AppConstants`** for padding/spacing values.
4. **API URLs** go in `ApiConstants`, **not** in `constants.dart` or `AppConstants`.
5. Follow **abstract class** pattern for utility classes (same as mini_InstaPay `Constants`).
6. Use **flutter_screenutil** (`sp`, `h`, `w`, `r`) for all sizing.
7. Widgets inside a view's `views/widgets/` folder are screen-specific. Shared widgets go in `core/widgets/`.
8. **Extract Bodies**: Every view file must be a thin shell (just the `Scaffold` wrapper, `AppBar`, and any providers) that delegates its `body` to a dedicated body widget located in the `views/widgets/` folder. Do not keep the body widget classes in the same file as the view. This keeps the screen files small and readable.
9. Use `Navigator.pushNamed` and `RoutesNames` constants for all navigation.
10. Dispose all `TextEditingController` and `FocusNode` objects in `dispose()`.

---

## Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter_bloc: ^9.1.1
  flutter_screenutil: ^5.9.3
  equatable: ^2.1.0
  dio: ^5.11.0
  flutter_secure_storage: ^10.3.1
  flutter_localizations:
    sdk: flutter
```
> Note: The user handles font asset declarations in `pubspec.yaml` manually.

---

## Key Design Decisions
- **Welcome screen** is under `features/onboarding/` (not `auth/`).
- **Business Details** is only shown when account type is `Merchant` or `Charity`.
- **`AppColors`** is a separate class from `Constants` — constants.dart holds only non-color, non-string general values.
- **`ApiConstants`** is separate from `constants.dart` and holds all backend URLs.
- **Remember Me Logic**: The application checks `SecureStorageHelper` for a stored `refreshToken` on startup (in `main.dart`). If found, it validates it via the `/auth/refresh` API endpoint and automatically navigates the user to `MainNavigationView` if valid, bypassing the welcome/login flow.
- **Localization & RTL**: The application uses a `LocalizationCubit` (in `lib/features/localization/...`) wrapped around `MaterialApp` to manage language state (`ar` or `en`). The `locale` property of `MaterialApp` listens to this cubit, which automatically handles Right-to-Left (RTL) vs Left-to-Right (LTR) transitions dynamically because `flutter_localizations` is configured. The user's language preference is saved in `SecureStorageHelper`.
