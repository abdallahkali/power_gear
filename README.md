# PowerGear — Sports E-Commerce App

A bilingual Flutter shopping-app prototype for sports equipment, training wear, and accessories. PowerGear demonstrates a complete customer-facing shopping journey, from discovering products to reviewing an order.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.3%2B-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.3%2B-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/State%20Management-Provider-7B1FA2" alt="Provider">
  <img src="https://img.shields.io/badge/Storage-SharedPreferences-4CAF50" alt="SharedPreferences">
</p>

## Overview

PowerGear focuses on a polished sports-store experience with product discovery, cart management, favorites, localization, and theme preferences. The current version uses sample/local data and is intended as a front-end application prototype.

## Features

- **Discover products:** promotional banners, best sellers, and product categories
- **Explore the catalog:** search, filtering, and sorting
- **Product details:** product information, variants/sizes, and quantity selection
- **Shopping cart:** add/remove items and update quantities
- **Favorites:** save products for later
- **Checkout experience:** promo-code field, order summary, and checkout UI
- **Order history:** review locally stored orders
- **Personalization:** Arabic/English language and system/light/dark appearance
- **Local persistence:** retain supported shopping and preference data between launches

## Screenshots

The following captures show the running Android application. They are intended to be displayed directly in this README:

> Screenshot files are not yet committed to this repository. The gallery will render once the corresponding images are uploaded to `screenshots/`.

| Home — Dark theme | Home — Light theme |
|---|---|
| `screenshots/01-home-dark.jpg` | `screenshots/02-home-light.jpg` |

| Shopping cart | Profile & settings |
|---|---|
| `screenshots/03-cart.jpg` | `screenshots/04-profile.jpg` |

| Order history |
|---|
| `screenshots/05-orders.jpg` |

## Built With

- **Flutter & Dart** — cross-platform mobile UI
- **Provider** — application state management
- **SharedPreferences** — local persistence
- **Repository abstraction** — separates data access from presentation
- **Mock product data** — sample catalog for the current prototype

## Getting Started

### Prerequisites

- Flutter SDK and Dart (Dart 3.3 or later)
- Android Studio or another Flutter-supported IDE
- Android emulator or a physical device

### Run the application

```bash
git clone https://github.com/abdallahkali/power_gear.git
cd power_gear
flutter pub get
flutter devices
flutter run
```

To run on a specific device:

```bash
flutter run -d <device-id>
```

## Project Structure

```text
lib/
  core/        # App settings, theme, localization, and helpers
  models/      # Product, cart, and order models
  data/        # Repository abstraction and mock catalog
  providers/   # Catalog, cart, favorites, orders, and settings state
  screens/     # Home, shop, details, cart, checkout, and orders
  widgets/     # Reusable UI components
assets/
  images/      # Product and promotional assets
```

## Current Scope & Limitations

- The product catalog is based on mock/local data.
- Checkout is a demonstration flow; no real payment gateway is connected.
- Orders and shopping preferences are stored locally.
- No production backend, live inventory, or server-side authentication is connected.

## Author

**Abdallah Khalifa** · [GitHub](https://github.com/abdallahkali)

[⬆ Back to top](#powergear--sports-e-commerce-app)
