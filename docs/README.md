# Sandwich Counter

A Flutter app that lets users create and manage sandwich orders. Users can toggle sandwich size (six-inch or footlong), select bread type, add notes, and adjust order quantity. Built with Flutter and demonstrating state management with a simple repository pattern.

## Key features

- **Size toggle**: Switch between six-inch and footlong sandwiches
- **Bread selection**: Choose from 5 bread types (white, wheat, wholemeal, brown, multigrain) via dropdown
- **Custom notes**: Add free-text notes (e.g., "no onions")
- **Quantity management**: Add/remove sandwiches with configurable max quantity (default: 10)
- **Visual feedback**: Displays sandwich emoji count (🥪) and current order summary
- **Disabled state handling**: Add/Remove buttons disable when bounds are reached

## Project structure

### Key files

- **`lib/main.dart`** — Application entrypoint and main UI
  - `MyApp` — root widget with MaterialApp configuration
  - `OrderScreen` — stateful widget managing sandwich order state (size, bread, notes, quantity)
  - `OrderItemDisplay` — displays current order with sandwich emoji visualization
  - `StyledButton` — reusable green button component with icon and label
  - `BreadType` enum — defines available bread options
  
- **`lib/repositories/order_repository.dart`** — Simple repository for quantity management
  - `increment()` / `decrement()` — modify quantity with bounds checking
  - `canIncrement` / `canDecrement` — boolean getters to check if action is allowed
  - Enforces min: 0, max: configurable (default 10)

- **`lib/views/app_styles.dart`** — Shared text styles and UI constants

- **`test/`** — Unit and widget tests

## Prerequisites

Before running the project ensure you have the following installed:

- Flutter SDK (tested with Flutter 3.x or later). Install from https://flutter.dev
- For Android: Android SDK and an emulator or a connected device (Android Studio recommended).
- For iOS (macOS only): Xcode and a simulator or device.
- For web: Chrome for `flutter run -d chrome`.

Make sure `flutter` is on your PATH and you have run `flutter doctor` to resolve any missing dependencies.

## Quick start

Clone and run the app in seconds:

```bash
git clone https://github.com/JxrryJr/sandwich_shop.git
cd sandwich_shop
flutter pub get
flutter run
```

## Setup

1. **Install Flutter** (3.x or later): https://flutter.dev

2. **Install platform dependencies**:
   - **Android**: Android SDK (via Android Studio)
   - **iOS** (macOS): Xcode and command-line tools
   - **Web**: Chrome browser

3. **Verify setup**:
   ```bash
   flutter doctor
   ```

## Running the app

```bash
# Default device
flutter run

# Specific device
flutter run -d <device-id>

# Web (Chrome)
flutter run -d chrome

# iOS simulator (macOS)
open -a Simulator
flutter run

# Android emulator
flutter emulators --launch <emulator-id>
flutter run
```

## Usage

Once you launch the app, you'll see the **Sandwich Counter** screen:

### Order controls

- **Size toggle**: Use the switch to toggle between "six-inch" and "footlong"
- **Bread selector**: Open the dropdown menu to select your bread type (white, wheat, wholemeal, brown, multigrain)
- **Add note**: Type in the text field to add special instructions
- **Quantity buttons**: 
  - **Add** (green button with +): Increases order quantity (disabled at max)
  - **Remove** (green button with −): Decreases order quantity (disabled at min)

### Order display

The order shows:
- Quantity and breadtype with sandwich emoji count (e.g., "2 white footlong sandwich(es): 🥪🥪")
- Your custom note if provided

### Configuration

To change the maximum order quantity, modify `OrderScreen` in `lib/main.dart`:

```dart
// Default is 10
OrderScreen(maxQuantity: 20)
```

To add more bread types, edit the `BreadType` enum in `lib/main.dart`:

```dart
enum BreadType { white, wheat, wholemeal, brown, multigrain, italian, sourdough }
```

## Tests

Run tests with:

```bash
flutter test
```

The `test/` directory contains unit and widget tests. When extending the app, add tests for:
- `OrderRepository` quantity bounds and increment/decrement logic
- `OrderScreen` button enable/disable states
- Bread selection and note display

### Cart editing feature

- The app now includes an editable Cart screen where users can modify items in their cart.
- State management: `Cart` is provided application-wide using `provider` (`ChangeNotifier`).
- File locations:
  - `lib/view_models/cart.dart` — `Cart` ChangeNotifier model (API: `add`, `remove`, `setQuantity`, `getQuantity`, `countOfItems`, `totalPrice`).
  - `lib/views/cart_screen.dart` — editable cart UI with increment/decrement/delete controls and undo SnackBar.
  - `lib/main.dart` — App wired with `ChangeNotifierProvider` and an AppBar cart icon to open the cart.
- UI & keys for testing:
  - Per-row controls use stable keys: `inc-<index>`, `dec-<index>`, `del-<index>`, `qty-<index>`.
  - Cart total uses `Key('cart-total')`.
- Pricing: `PricingRepository` calculates line totals (fallback to £4.50 per sandwich if pricing fails).

See `docs/CART_FEATURE.md` for implementation notes, defensive behaviors (quantity clamping, fallback pricing), and manual QA steps.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| App won't start | Run `flutter clean`, then `flutter pub get`, then `flutter run` |
| Build errors on iOS | Open `ios/Runner.xcworkspace` in Xcode and check code signing |
| Device not found | Run `flutter devices` to list available targets |
| Build cache issues | Run `flutter clean` to clear build artifacts |