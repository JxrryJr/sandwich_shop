/// Shared sandwich models used across the app.
enum BreadType { white, wheat, wholemeal, brown, multigrain }

/// Types of sandwiches available in the UI.
enum SandwichType { veggieDelight, chickenTeriyaki, tunaMelt, meatballMarinara }

/// Represents a sandwich configuration used by the UI and cart.
class Sandwich {
  final SandwichType type;
  final bool isFootlong;
  final BreadType breadType;
  final bool isToasted;
  final String note;

  const Sandwich({
    required this.type,
    required this.isFootlong,
    required this.breadType,
    this.isToasted = false,
    this.note = '',
  });

  String get name {
    switch (type) {
      case SandwichType.veggieDelight:
        return 'Veggie Delight';
      case SandwichType.chickenTeriyaki:
        return 'Chicken Teriyaki';
      case SandwichType.tunaMelt:
        return 'Tuna Melt';
      case SandwichType.meatballMarinara:
        return 'Meatball Marinara';
    }
  }

  String get image {
    final typeString = type.name;
    final sizeString = isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${typeString}_$sizeString.png';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Sandwich &&
            other.type == type &&
            other.isFootlong == isFootlong &&
            other.breadType == breadType &&
            other.isToasted == isToasted &&
            other.note == note);
  }

  @override
  int get hashCode => Object.hash(type, isFootlong, breadType, isToasted, note);

  @override
  String toString() {
    final sizeLabel = isFootlong ? 'footlong' : 'six-inch';
    final toastedLabel = isToasted ? 'toasted' : 'untoasted';
    return '${breadType.name} $sizeLabel ($toastedLabel)${note.isNotEmpty ? ': $note' : ''}';
  }
}
