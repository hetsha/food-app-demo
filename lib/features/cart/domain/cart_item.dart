import '../../../core/constants/app_constants.dart';

class CartItem {
  final String id;
  final Meal meal;
  final int quantity;
  final String spiceLevel;
  final String oilLevel;
  final String portionSize;
  final List<String> removedIngredients;
  final List<String> addedExtras;

  CartItem({
    required this.id,
    required this.meal,
    required this.quantity,
    this.spiceLevel = 'Medium',
    this.oilLevel = 'Normal',
    this.portionSize = 'Normal',
    this.removedIngredients = const [],
    this.addedExtras = const [],
  });

  double get unitPrice {
    double base = meal.price;
    // Calculate extra costs dynamically
    for (var extra in addedExtras) {
      if (extra.contains('Paneer')) base += 30.0;
      else if (extra.contains('Cheese')) base += 20.0;
      else if (extra.contains('Mushroom')) base += 20.0;
      else if (extra.contains('Sweet Corn')) base += 15.0;
      else base += 20.0; // fallback
    }
    return base;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    int? quantity,
    String? spiceLevel,
    String? oilLevel,
    String? portionSize,
    List<String>? removedIngredients,
    List<String>? addedExtras,
  }) {
    return CartItem(
      id: id,
      meal: meal,
      quantity: quantity ?? this.quantity,
      spiceLevel: spiceLevel ?? this.spiceLevel,
      oilLevel: oilLevel ?? this.oilLevel,
      portionSize: portionSize ?? this.portionSize,
      removedIngredients: removedIngredients ?? this.removedIngredients,
      addedExtras: addedExtras ?? this.addedExtras,
    );
  }
}
