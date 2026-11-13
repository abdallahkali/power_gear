# PowerGear — Sports E-Commerce App

A bilingual Flutter e-commerce app prototype for sports equipment, clothing, and accessories. The app demonstrates a local shopping experience with product discovery, cart management, favorites, checkout UI, and order history.

## Screenshots

The app screenshots are prepared in the `screenshots/` folder. Add the supplied screenshot files to this folder to display the gallery here.

## Features

- Home screen with promotional banners and product collections
- Browse sports-product categories
- Search, filter, and sort products
- Product details with variant/size and quantity selection
- Shopping cart, quantity updates, and favorites
- Promo-code support and order summary
- Checkout and order-success UI flow
- Local order history
- Arabic and English localization
- Light, dark, and system appearance options
- Local persistence for cart, favorites, orders, language, and theme

## Tech Stack

- **Flutter & Dart** — cross-platform UI
- **Provider** — state management
- **SharedPreferences** — local persistence
- **Repository abstraction** — separation of data access from UI
- **Mock product data** — sample catalog for the prototype

## Project Structure

```text
lib/
  core/       # Brand settings, theme, localization, and formatting
  models/     # Product, cart, and order models
  data/       # Repository contract and mock product data
  providers/  # Catalog, cart, favorites, orders, and settings
  screens/    # Home, shop, details, cart, checkout, and orders
  widgets/    # Reusable product and UI components
assets/
  images/     # Sports-product images used by the app
screenshots/  # App screenshots captured from the Android emulator
```

## Getting Started

### Requirements

- Flutter SDK with Dart **3.3 or later**
- Android Studio or another Flutter-supported IDE
- An Android emulator or a connected device

### Run locally

1. Clone the repository:
   ```bash
   git clone https://github.com/abdallahkali/power_gear.git
   cd power_gear
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Check available devices:
   ```bash
   flutter devices
   ```
4. Run the application:
   ```bash
   flutter run
   ```

To target a specific device, run `flutter run -d <device-id>`.

## Data & Current Limitations

- The product catalog uses mock/local data.
- Checkout is a demonstration UI; no real payment gateway is connected.
- Orders and shopping preferences are stored locally.
- No production backend, live inventory, or server-side authentication is connected in this version.

## Repository

[github.com/abdallahkali/power_gear](https://github.com/abdallahkali/power_gear)
