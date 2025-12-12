import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// In-memory cart model used by the UI. This class is a ChangeNotifier so
/// it can be provided with `Provider` and consumed by widgets.
class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};

  /// Maximum allowed quantity per line (defensive cap).
  static const int maxQuantityPerItem = 1000;

  /// Read-only view of cart contents.
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  /// Adds [quantity] of [sandwich] to the cart. Ignores non-positive quantities.
  /// The resulting quantity is clamped to [maxQuantityPerItem].
  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final current = _items[sandwich] ?? 0;
    final updated = (current + quantity).clamp(0, maxQuantityPerItem);
    _items[sandwich] = updated;
    notifyListeners();
  }

  /// Removes up to [quantity] of [sandwich] from the cart. If the removal
  /// quantity is greater than or equal to the current quantity the item is removed.
  /// Ignores non-positive quantities.
  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    final current = _items[sandwich];
    if (current == null) return;
    if (quantity >= current) {
      _items.remove(sandwich);
    } else {
      _items[sandwich] = current - quantity;
    }
    notifyListeners();
  }

  /// Sets the quantity for a sandwich entry. If qty <= 0 the item is removed.
  /// The quantity is clamped to [maxQuantityPerItem].
  void setQuantity(Sandwich sandwich, int qty) {
    if (qty <= 0) {
      if (_items.remove(sandwich) != null) notifyListeners();
      return;
    }
    final updated = qty.clamp(0, maxQuantityPerItem);
    _items[sandwich] = updated;
    notifyListeners();
  }

  /// Returns the quantity for [sandwich], or zero if not present.
  int getQuantity(Sandwich sandwich) => _items[sandwich] ?? 0;

  /// Total number of units in the cart (sum of quantities).
  int get countOfItems => _items.values.fold(0, (a, b) => a + b);

  /// Whether the cart is empty.
  bool get isEmpty => _items.isEmpty;

  /// Clears the cart. Notifies listeners only if the cart was non-empty.
  void clear() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
    }
  }

  /// Total price computed using [PricingRepository]. Returns a value rounded
  /// to 2 decimal places to match UI formatting.
  double get totalPrice {
    final pricing = PricingRepository();
    double total = 0.0;
    _items.forEach((sandwich, qty) {
      try {
        total += pricing.calculatePrice(
            quantity: qty, isFootlong: sandwich.isFootlong);
      } catch (_) {
        // If pricing fails for any reason, fall back to a sensible default.
        total += qty * 4.5;
      }
    });
    return (total * 100).roundToDouble() / 100;
  }
}
