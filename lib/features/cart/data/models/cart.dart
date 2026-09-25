import 'package:freezed_annotation/freezed_annotation.dart';
import 'selected_customization.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@freezed
class CartFoodItem with _$CartFoodItem {
  const factory CartFoodItem({
    required String id,
    required String name,
    required double price,
    @JsonKey(name: 'imageUrls') @Default([]) List<String> imageUrls,
    @JsonKey(name: 'isVeg') @Default(true) bool isVeg,
    @JsonKey(name: 'preparationTimeMinutes') @Default(20) int preparationTimeMinutes,
  }) = _CartFoodItem;

  factory CartFoodItem.fromJson(Map<String, dynamic> json) =>
      _$CartFoodItemFromJson(json);
}

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    @JsonKey(name: 'foodItemId') required String foodItemId,
    required int quantity,
    @JsonKey(name: 'customizationItems') @Default([]) List<SelectedCustomization> customizationItems,
    @JsonKey(name: 'specialInstructions') String? specialInstructions,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'foodItem') required CartFoodItem foodItem,
    @JsonKey(name: 'unitPrice') required double unitPrice,
    @JsonKey(name: 'itemTotal') required double itemTotal,
    @JsonKey(name: 'isAvailable') @Default(true) bool isAvailable,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    @Default([]) List<CartItem> items,
    @JsonKey(name: 'unavailableItems') @Default([]) List<CartItem> unavailableItems,
    @JsonKey(name: 'itemTotal') @Default(0.0) double itemTotal,
    @JsonKey(name: 'itemCount') @Default(0) int itemCount,
    @JsonKey(name: 'hasUnavailableItems') @Default(false) bool hasUnavailableItems,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}
