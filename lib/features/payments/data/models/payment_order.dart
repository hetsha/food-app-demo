import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_order.freezed.dart';
part 'payment_order.g.dart';

@freezed
class PaymentOrder with _$PaymentOrder {
  const factory PaymentOrder({
    @JsonKey(name: 'order_id') required String orderId,
    required int amount,
    required String currency,
    @JsonKey(name: 'key_id') required String keyId,
  }) = _PaymentOrder;

  factory PaymentOrder.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderFromJson(json);
}
