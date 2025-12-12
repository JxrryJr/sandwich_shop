import 'package:sandwich_shop/models/sandwich.dart';
import 'package:flutter/foundation.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};

  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
    notifyListeners();
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        _items.remove(sandwich);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (int quantity in _items.values) {
      total += quantity;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }
}

/// Holds a sandwich plus quantity for use in the cart.
class CartItem {
  final Sandwich sandwich;
  int quantity;

  CartItem({required this.sandwich, required this.quantity});

  @override
  String toString() => '${sandwich.toString()} x $quantity';
}

/// Manages a collection of sandwiches and calculates totals using
/// `PricingRepository`.
class ShoppingCart {
  final PricingRepository _pricingRepository;
  final List<CartItem> _items = [];

  ShoppingCart({PricingRepository? pricingRepository})
      : _pricingRepository = pricingRepository ?? PricingRepository();

  /// Returns an unmodifiable view of items in the cart.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of sandwich units in the cart.
  int get totalQuantity => _items.fold(0, (s, i) => s + i.quantity);

  /// Adds [quantity] of [sandwich] to the cart. If the same sandwich
  /// configuration exists, the quantity is increased.
  void add(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final idx = _items.indexWhere((it) => it.sandwich == sandwich);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Removes up to [quantity] of [sandwich] from the cart. If the
  /// remaining quantity is zero or below, the item is removed.
  void remove(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final idx = _items.indexWhere((it) => it.sandwich == sandwich);
    if (idx < 0) return;
    final existing = _items[idx];
    existing.quantity -= quantity;
    if (existing.quantity <= 0) {
      _items.removeAt(idx);
    }
  }

  /// Sets the quantity for a sandwich entry. If quantity <= 0 the
  /// item is removed.
  void setQuantity(Sandwich sandwich, int quantity) {
    final idx = _items.indexWhere((it) => it.sandwich == sandwich);
    if (quantity <= 0) {
      if (idx >= 0) _items.removeAt(idx);
      return;
    }
    if (idx >= 0) {
      _items[idx].quantity = quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Clears the cart.
  void clear() => _items.clear();

  /// Calculates the total price for all items in the cart using
  /// [PricingRepository.calculatePrice]. Returns a rounded double.
  double totalPrice() {
    double total = 0.0;
    for (final item in _items) {
      // total += _pricingRepository.calculatePrice(
          // item.quantity: quantity,
          // sandwich.isFootlong);
    }
    // Keep the same rounding behaviour as the repository (2 d.p.)
    return (total * 100).roundToDouble() / 100;
  }
}
