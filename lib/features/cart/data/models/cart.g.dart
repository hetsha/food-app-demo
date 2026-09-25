// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartFoodItemImpl _$$CartFoodItemImplFromJson(Map<String, dynamic> json) =>
    _$CartFoodItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isVeg: json['isVeg'] as bool? ?? true,
      preparationTimeMinutes:
          (json['preparationTimeMinutes'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$$CartFoodItemImplToJson(_$CartFoodItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'imageUrls': instance.imageUrls,
      'isVeg': instance.isVeg,
      'preparationTimeMinutes': instance.preparationTimeMinutes,
    };

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      id: json['id'] as String,
      foodItemId: json['foodItemId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      customizationItems:
          (json['customizationItems'] as List<dynamic>?)
              ?.map(
                (e) =>
                    SelectedCustomization.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      specialInstructions: json['specialInstructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      foodItem: CartFoodItem.fromJson(json['foodItem'] as Map<String, dynamic>),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      itemTotal: (json['itemTotal'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foodItemId': instance.foodItemId,
      'quantity': instance.quantity,
      'customizationItems': instance.customizationItems,
      'specialInstructions': instance.specialInstructions,
      'createdAt': instance.createdAt.toIso8601String(),
      'foodItem': instance.foodItem,
      'unitPrice': instance.unitPrice,
      'itemTotal': instance.itemTotal,
      'isAvailable': instance.isAvailable,
    };

_$CartImpl _$$CartImplFromJson(Map<String, dynamic> json) => _$CartImpl(
  id: json['id'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  unavailableItems:
      (json['unavailableItems'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  itemTotal: (json['itemTotal'] as num?)?.toDouble() ?? 0.0,
  itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
  hasUnavailableItems: json['hasUnavailableItems'] as bool? ?? false,
);

Map<String, dynamic> _$$CartImplToJson(_$CartImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'unavailableItems': instance.unavailableItems,
      'itemTotal': instance.itemTotal,
      'itemCount': instance.itemCount,
      'hasUnavailableItems': instance.hasUnavailableItems,
    };
