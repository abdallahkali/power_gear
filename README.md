# PowerGear — Sports E-Commerce App

A bilingual Flutter shopping-app prototype for browsing sports equipment, clothing, and accessories through a local e-commerce flow.

## Features

- Home screen with promotional content and product collections
- Browse sports-product categories
- Search, filter, and sort products
- Product details with size/variant and quantity selection
- Shopping cart and favorites
- Promo-code support
- Checkout and order-success flow
- Local order history
- Arabic and English localization
- Light and dark themes
- Local persistence for cart, favorites, orders, language, and theme

## Tech Stack

- Flutter and Dart
- Provider for state management
- SharedPreferences for local persistence
- Repository abstraction with mock product data

## Screenshots

Real in-app screenshots have not been added to this repository yet. Capture the running application and add the images under `screenshots/`. Suggested filenames:

- `screenshots/01-home.png`
- `screenshots/02-product-details.png`
- `screenshots/03-shopping-cart.png`
- `screenshots/04-checkout.png`

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
   ```
2. Open the project directory:
   ```bash
   cd power_gear
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Check available devices:
   ```bash
   flutter devices
   ```
5. Run the app:
   ```bash
   flutter run
   ```

To target a particular device, use `flutter run -d <device-id>`.

## Data and Limitations

- Product catalog and checkout currently use mock/local data.
- Card payment is a UI flow only; no real payment gateway is connected.
- Orders are stored locally; there is no production backend or inventory service in this version.

## Repository

https://github.com/abdallahkali/power_gear
