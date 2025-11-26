import 'package:collection/collection.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

/// A simple size enum for sandwiches stored in the cart.
enum SandwichSize { sixInch, footlong }

/// Represents a sandwich configuration (size, bread, toasted, note).
///
/// This class is immutable and implements value equality so it can be
/// used as a key when grouping items in the cart.
class Sandwich {
  final SandwichSize size;
  final String breadType;
  final bool toasted;
  final String note;

  const Sandwich({
    required this.size,
    required this.breadType,
    this.toasted = false,
    this.note = '',
  });

  bool get isFootlong => size == SandwichSize.footlong;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Sandwich &&
            other.size == size &&
            other.breadType == breadType &&
            other.toasted == toasted &&
            other.note == note);
  }

  @override
  int get hashCode => Object.hash(size, breadType, toasted, note);

  @override
  String toString() {
    final sizeLabel = isFootlong ? 'footlong' : 'six-inch';
    final toastedLabel = toasted ? 'toasted' : 'untoasted';
    return '$breadType $sizeLabel ($toastedLabel)${note.isNotEmpty ? ': $note' : ''}';
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
class Cart {
  final PricingRepository _pricingRepository;
  final List<CartItem> _items = [];

  Cart({PricingRepository? pricingRepository})
      : _pricingRepository = pricingRepository ?? PricingRepository();

  /// Returns an unmodifiable view of items in the cart.
  List<CartItem> get items => List.unmodifiable(_items);

  /// Total number of sandwich units in the cart.
  int get totalQuantity => _items.fold(0, (s, i) => s + i.quantity);

  /// Adds [quantity] of [sandwich] to the cart. If the same sandwich
  /// configuration exists, the quantity is increased.
  void add(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final existing = _items.firstWhereOrNull((it) => it.sandwich == sandwich);
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items.add(CartItem(sandwich: sandwich, quantity: quantity));
    }
  }

  /// Removes up to [quantity] of [sandwich] from the cart. If the
  /// remaining quantity is zero or below, the item is removed.
  void remove(Sandwich sandwich, [int quantity = 1]) {
    if (quantity <= 0) return;
    final existing = _items.firstWhereOrNull((it) => it.sandwich == sandwich);
    if (existing == null) return;
    existing.quantity -= quantity;
    if (existing.quantity <= 0) {
      _items.remove(existing);
    }
  }

  /// Sets the quantity for a sandwich entry. If quantity <= 0 the
  /// item is removed.
  void setQuantity(Sandwich sandwich, int quantity) {
    final existing = _items.firstWhereOrNull((it) => it.sandwich == sandwich);
    if (quantity <= 0) {
      if (existing != null) _items.remove(existing);
      return;
    }
    if (existing != null) {
      existing.quantity = quantity;
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
      total += _pricingRepository.calculatePrice(
          item.quantity, item.sandwich.isFootlong);
    }
    // Keep the same rounding behaviour as the repository (2 d.p.)
    return (total * 100).roundToDouble() / 100;
  }
}
