import 'package:freezed_annotation/freezed_annotation.dart';

part 'wishlist_item.freezed.dart';
part 'wishlist_item.g.dart';

@freezed
class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    @JsonKey(name: 'food_item') required WishlistFoodItem foodItem,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);
}

@freezed
class WishlistFoodItem with _$WishlistFoodItem {
  const factory WishlistFoodItem({
    required String id,
    required String name,
    required double price,
    @JsonKey(name: 'image_urls') @Default([]) List<String> imageUrls,
    double? rating,
    @JsonKey(name: 'is_veg') @Default(true) bool isVeg,
  }) = _WishlistFoodItem;

  factory WishlistFoodItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistFoodItemFromJson(json);
}
