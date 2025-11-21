class PricingRepository {
  static const double footlongPrice = 11.0;
  static const double sixInchPrice = 7.0;

  double calculatePrice(int quantity, bool isFootlong) {
    double unitPrice = isFootlong ? footlongPrice : sixInchPrice;
    return quantity * unitPrice;
  }
}