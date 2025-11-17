# My Sandwich Shop

A small Flutter app that demonstrates a simple sandwich counter UI. Users can toggle sandwich size (six-inch or footlong), pick a bread type, add an optional note, and increment/decrement the current order quantity. The app uses a tiny `OrderRepository` to manage quantity with an upper bound.

## Key features

- Toggle between six-inch and footlong sandwiches.
- Choose from multiple bread types (white, wheat, wholemeal, brown, multigrain).
- Add a free-text note (e.g., "no onions").
- Add and remove sandwiches with the quantity constrained by a configurable `maxQuantity`.
- Simple, focused single-screen UI useful for demos, tests, and learning Flutter state handling.

## Project structure (important files)

- `lib/main.dart` — app entrypoint and UI. Contains `OrderScreen`, `OrderItemDisplay`, and UI controls.
- `lib/repositories/order_repository.dart` — small repository class that stores and updates the order quantity with `increment`/`decrement` and exposes `canIncrement` / `canDecrement`.
- `lib/views/` and `lib/view_models/` — additional UI and view-model code (if present).
- `test/` — unit/widget tests (run with `flutter test`).

## Prerequisites

Before running the project ensure you have the following installed:

- Flutter SDK (tested with Flutter 3.x or later). Install from https://flutter.dev
- For Android: Android SDK and an emulator or a connected device (Android Studio recommended).
- For iOS (macOS only): Xcode and a simulator or device.
- For web: Chrome for `flutter run -d chrome`.

Make sure `flutter` is on your PATH and you have run `flutter doctor` to resolve any missing dependencies.

## Clone the repository

Use HTTPS to clone the repository:

```bash
git clone https://github.com/JxrryJr/sandwich_shop.git
cd sandwich_shop
```

## Installation and setup

1. Ensure Flutter is installed and available in your shell. On macOS with zsh, you might add Flutter to your PATH in `~/.zshrc`:

```bash
# example, adjust to your flutter install path
export PATH="$PATH:/path/to/flutter/bin"
```

2. From the project root, fetch dependencies:

```bash
flutter pub get
```

3. (Optional) Run `flutter pub upgrade` to refresh packages, or `flutter pub outdated` to inspect upgrades.

## Run the app

- Run on the default connected device or emulator:

```bash
flutter run
```

- Run on a specific device (example: iOS simulator on macOS):

```bash
flutter run -d <device-id>
```

- Run on Chrome (web):

```bash
flutter run -d chrome
```

If you get platform-specific build errors, run `flutter doctor` and follow the recommended fixes.

## Usage (what the app does)

Open the app and you'll see the Sandwich Counter screen. Primary user flows:

- Toggle sandwich size: Use the switch between "six-inch" and "footlong". The displayed item text updates.
- Select bread: Open the dropdown and pick a bread. The app enumerates bread types from the `BreadType` enum in `main.dart`.
- Add a note: Type a note in the text field (e.g., "no onions"). The note is displayed under the order summary.
- Add / Remove: Use the green Add and Remove buttons to change the current order quantity. Buttons are disabled when the repo's min/max are reached.

Notes:

- The default maximum quantity is set when creating `OrderRepository`. The `OrderScreen` defaults `maxQuantity` to `10`. To change it, edit the `OrderScreen` construction in `lib/main.dart`:

```dart
// example: set maxQuantity to 20
OrderScreen(maxQuantity: 20)
```

## Configuration options

- `OrderScreen(maxQuantity: <int>)` — set the maximum allowed sandwiches.
- `BreadType` enum in `lib/main.dart` — add/remove bread types there to expand choices.

## Tests

Run unit and widget tests with the Flutter test runner:

```bash
flutter test
```

There are test folders under `test/` that exercise repository and UI code. Add tests to cover new behaviors as you extend the app.

## Screenshots / GIFs

Include visual assets to show the UI. I didn't add screenshots automatically; you can add them to `assets/screenshots/` and then reference them here.

How to capture:

- iOS Simulator: Cmd+S (or use `File > Save Screen Shot`), or press Cmd+Shift+4 on macOS to capture a region.
- Android Emulator: Extended controls > Take screenshot.
- Chrome (web): use DevTools or OS-level screenshot.

To embed a screenshot in this README, add the image file into the repo (e.g., `assets/screenshots/screen1.png`) and reference it like:

```md
![Sandwich Counter](assets/screenshots/screen1.png)
```

GIF tip: record a short screencast (e.g., using QuickTime on macOS), convert or trim it as needed, then add as `assets/gifs/demo.gif` and reference it similarly.

## Implementation notes (for contributors)

- UI and state are simple and located in `lib/main.dart`. Consider splitting into smaller files (widgets and viewmodels) as the app grows.
- Business logic (quantity bounds) is implemented in `lib/repositories/order_repository.dart` and is intentionally small to make unit testing straightforward.

## Troubleshooting

- If the app won't start: run `flutter clean`, `flutter pub get`, and then `flutter run`.
- If you see build errors for iOS, open `ios/Runner.xcworkspace` in Xcode and ensure signing/provisioning are set.

## Contributing

Contributions are welcome. Typical workflow:

1. Fork the repo.
2. Create a branch for your change.
3. Add tests that cover your change.
4. Submit a pull request with a clear description.

## License

Add a license file (e.g., `LICENSE`) if you wish to publish this project with an open-source license.

---

If you'd like, I can also:

- Add example screenshots/GIFs into `assets/screenshots/` and reference them in the README.
- Split the main UI into smaller widget files and add unit/widget tests for them.

Tell me which follow-up you'd prefer and I will implement it.

## What's improved in this README

- Clear Table of Contents for quick navigation.
- Quick-start commands up front for developers who want to run the app fast.
- A concise developer contract describing inputs/outputs and success criteria.
- A short list of likely edge cases and how the app handles them.
- Guidance for adding screenshots/GIFs and an optional next step (CI) to run tests automatically.

---

## Table of contents

1. Overview
2. Quick start
3. Prerequisites
4. Installation
5. Running the app
6. Usage
7. Developer contract & edge cases
8. Tests
9. Screenshots / GIFs
10. Troubleshooting
11. Contributing
12. Next steps

## Quick start

Clone, fetch dependencies, and run on the default device:

```bash
git clone https://github.com/JxrryJr/sandwich_shop.git
cd sandwich_shop
flutter pub get
flutter run
```

Run tests:

```bash
flutter test
```

## Developer contract (tiny)

Inputs:
- User interactions: toggle sandwich size, select bread, enter note, press Add/Remove.
- `OrderScreen(maxQuantity: int)` — configuration input for upper bound.

Outputs:
- UI updates showing quantity, selected bread type, size label, and note text.
- `OrderRepository.quantity` — single source of truth for quantity.

Success criteria:
- Quantity never goes below 0 or above `maxQuantity`.
- Buttons disable when the corresponding action is not allowed.

Failure modes / errors:
- No persistence — app state resets on restart (intended for demo/simple app).

## Edge cases to be aware of

- Rapid tapping: UI uses simple synchronous updates; the `OrderRepository` prevents quantity from going out of bounds.
- Empty notes: displayed as `No notes added.` in the UI.
- Bread enum changes: adding/removing values in `BreadType` will change dropdown items immediately; consider migration if persisted data is added.

## Running on specific platforms

- Android (emulator or device): Ensure Android SDK is installed and an AVD is available. Then:

```bash
flutter emulators --launch <emulator-id>
flutter run
```

- iOS (macOS only): Ensure Xcode and command-line tools are installed. Use an iOS simulator or device:

```bash
open -a Simulator
flutter run
```

- Web (Chrome):

```bash
flutter run -d chrome
```

## Tests (details)

- Run all tests:

```bash
flutter test
```

- Recommended tests to add when extending the app:
	- Unit tests for `OrderRepository` (increment/decrement, bounds).
	- Widget tests for `OrderScreen` to validate button enable/disable states, bread selection, and note display.

## Screenshots / GIFs (practical)

Place visual assets in `assets/screenshots/` (create that folder) and reference them in this README. Example:

```md
![Sandwich Counter - main screen](assets/screenshots/sandwich_counter.png)
```

Tips:
- macOS QuickTime can record simulator screencasts. Trim, convert to GIF, and add to `assets/gifs/`.
- Keep images small (optimized) so the repo stays fast.

## Troubleshooting

- Common fix: `flutter clean && flutter pub get` then `flutter run`.
- If iOS build fails: open `ios/Runner.xcworkspace` in Xcode and resolve signing errors.
- If device not found: run `flutter devices` to list available targets.

## Contributing (short)

1. Fork the repo.
2. Branch: `git checkout -b feat/your-feature`.
3. Add tests for behavior you change.
4. Commit and open a PR with a descriptive title and summary.

## Next steps I can implement for you

- Add example screenshots and include them in the README.
- Add a GitHub Actions workflow that runs `flutter test` on push/PR (I can scaffold `.github/workflows/flutter.yml`).
- Split `lib/main.dart` into smaller widget files and add unit/widget tests.