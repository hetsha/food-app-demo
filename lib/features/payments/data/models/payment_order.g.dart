// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentOrderImpl _$$PaymentOrderImplFromJson(Map<String, dynamic> json) =>
    _$PaymentOrderImpl(
      orderId: json['order_id'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      keyId: json['key_id'] as String,
    );

Map<String, dynamic> _$$PaymentOrderImplToJson(_$PaymentOrderImpl instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'amount': instance.amount,
      'currency': instance.currency,
      'key_id': instance.keyId,
    };
