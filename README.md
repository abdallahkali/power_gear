# PowerGear — Sports E-Commerce App

A bilingual sports shopping application built with **Flutter and Dart**, designed around a sports-products catalog and a familiar e-commerce experience.

## Features
- Home screen with promotional content and product collections
- Browse product categories
- Search, filter, and sort products
- Product details with size/variant and quantity selection
- Shopping cart and favorites
- Promo-code support
- Checkout flow and order-success screen
- Order history
- Arabic / English localization
- Light / dark themes
- Local persistence for cart, favorites, orders, language, and theme

## Tech Stack
- Flutter / Dart
- Provider for state management
- SharedPreferences for local persistence
- Repository abstraction with mock product data

## Project Structure
```text
lib/
  core/       # Brand settings, theme, localization, formatting
  models/     # Product, cart, and order models
  data/       # Repository contract and mock product data
  providers/  # Catalog, cart, favorites, orders, settings
  screens/    # Home, shop, details, cart, checkout, orders
  widgets/    # Reusable product and UI components
assets/
  images/     # Product images
```

## Getting Started
Requires Flutter 3.27 or later.

```bash
flutter pub get
flutter run
```

## Important Notes
- Product catalog and checkout currently use mock/local data.
- Card payment is a UI flow only; no real payment gateway is connected.
- Orders are stored locally; no production backend or inventory service is connected.

## Repository
https://github.com/abdallahkali/power_gear
