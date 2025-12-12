Cart feature — implementation notes

This document describes the defensive and QA-minded changes added to the Cart model and UI.

1. Cart model (lib/view_models/cart.dart)
- Cart is a ChangeNotifier and exposes a Map<Sandwich,int> `items` for UI iteration.
- Methods:
  - `add(Sandwich, {int quantity = 1})` — ignores non-positive quantities and clamps to a reasonable `maxQuantityPerItem`.
  - `remove(Sandwich, {int quantity = 1})` — ignores non-positive quantities and removes the item when qty <= 0.
  - `setQuantity(Sandwich, int qty)` — sets exact quantity (removes when qty <= 0), clamps to max.
  - `getQuantity`, `countOfItems`, `isEmpty`, `clear`, and `totalPrice` (rounded to 2 d.p.).
- Defensive behaviour:
  - Negative or zero adjustments are ignored unless setQuantity is explicitly 0, which removes the item.
  - Per-item quantity is capped by `maxQuantityPerItem` (default 1000) to avoid runaway values.
  - `totalPrice` uses `PricingRepository`; if the repository throws, it falls back to £4.50 per sandwich.

2. CartScreen & OrderScreen (UI)
- Controls call `cart.add`, `cart.remove`, `cart.setQuantity` where appropriate. The model notifies listeners so UI updates automatically.
- Keys are in place for widget testing (`inc-<index>`, `dec-<index>`, `del-<index>`, `qty-<index>`, `cart-total`).

3. Undo behaviour
- Delete action shows a SnackBar with `UNDO` that re-adds the removed quantity. The undo is immediate and in-memory only.

4. Tests
- You said you are not fussed about tests; existing tests were added previously but QA should include manual verification:
  - Add items, navigate to Cart, increment/decrement, delete and undo, and confirm totals.

5. Next QA suggestions
- Run the app and exercise the flows in an emulator.
- Edge-case manual tests: try large quantities, attempt to set negative quantities (should be ignored), and force PricingRepository to fail (temporary modify it) to verify fallback.

If you'd like, I can also add a small runtime assertion in the app that prevents adding more than `maxQuantityPerItem` and shows a SnackBar informing the user.
