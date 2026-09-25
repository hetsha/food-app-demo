import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String status,
    required double itemTotal,
    @Default(30.0) double deliveryFee,
    @Default(2.0) double platformFee,
    @Default(0.0) double taxAmount,
    @Default(0.0) double discountAmount,
    required double grandTotal,
    DeliveryAddress? deliveryAddress,
    String? paymentMethod,
    @Default('pending') String paymentStatus,
    String? specialInstructions,
    String? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? otpCode,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required OrderFoodItem foodItem,
    @Default(1) int quantity,
    @Default(0.0) double unitPrice,
    @Default(0.0) double total,
    @Default([]) List<OrderCustomization> customizations,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

@freezed
class OrderFoodItem with _$OrderFoodItem {
  const factory OrderFoodItem({
    required String id,
    required String name,
    @Default([]) List<String> imageUrls,
    @Default(true) bool isVeg,
  }) = _OrderFoodItem;

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) =>
      _$OrderFoodItemFromJson(json);
}

@freezed
class OrderCustomization with _$OrderCustomization {
  const factory OrderCustomization({
    required String id,
    required String name,
    @Default(0.0) double additionalPrice,
  }) = _OrderCustomization;

  factory OrderCustomization.fromJson(Map<String, dynamic> json) =>
      _$OrderCustomizationFromJson(json);
}

@freezed
class DeliveryAddress with _$DeliveryAddress {
  const DeliveryAddress._();
  const factory DeliveryAddress({
    required String id,
    required String label,
    required String addressLine1,
    String? addressLine2,
    required String city,
    required String state,
    required String postalCode,
    @Default(0.0) double latitude,
    @Default(0.0) double longitude,
    required String phone,
  }) = _DeliveryAddress;

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json['id'] as String,
        label: json['label'] as String,
        addressLine1: json['addressLine1'] as String,
        addressLine2: json['addressLine2'] as String?,
        city: json['city'] as String,
        state: json['state'] as String,
        postalCode: json['postalCode'] as String,
        latitude: _toDouble(json['latitude']),
        longitude: _toDouble(json['longitude']),
        phone: json['phone'] as String,
      );
}
