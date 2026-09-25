// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemImpl _$$WishlistItemImplFromJson(Map<String, dynamic> json) =>
    _$WishlistItemImpl(
      id: json['id'] as String,
      foodItem: WishlistFoodItem.fromJson(
        json['food_item'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$WishlistItemImplToJson(_$WishlistItemImpl instance) =>
    <String, dynamic>{'id': instance.id, 'food_item': instance.foodItem};

_$WishlistFoodItemImpl _$$WishlistFoodItemImplFromJson(
  Map<String, dynamic> json,
) => _$WishlistFoodItemImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrls:
      (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  rating: (json['rating'] as num?)?.toDouble(),
  isVeg: json['is_veg'] as bool? ?? true,
);

Map<String, dynamic> _$$WishlistFoodItemImplToJson(
  _$WishlistFoodItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'image_urls': instance.imageUrls,
  'rating': instance.rating,
  'is_veg': instance.isVeg,
};
