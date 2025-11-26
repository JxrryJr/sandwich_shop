class PricingRepository {
  static const double footlongPrice = 11.0;
  static const double sixInchPrice = 7.0;

  /// Calculates the total price for [quantity] sandwiches.
  ///
  /// - Negative quantities are treated as zero.
  /// - Returns the value rounded to two decimal places.
  double calculatePrice(int quantity, bool isFootlong) {
    final int qty = quantity < 0 ? 0 : quantity;
    final double unitPrice = isFootlong ? footlongPrice : sixInchPrice;
    final double total = qty * unitPrice;
    // Round to 2 decimal places to keep results deterministic for tests.
    return (total * 100).roundToDouble() / 100;
  }
}
