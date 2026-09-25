// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentOrder _$PaymentOrderFromJson(Map<String, dynamic> json) {
  return _PaymentOrder.fromJson(json);
}

/// @nodoc
mixin _$PaymentOrder {
  @JsonKey(name: 'order_id')
  String get orderId => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  @JsonKey(name: 'key_id')
  String get keyId => throw _privateConstructorUsedError;

  /// Serializes this PaymentOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentOrderCopyWith<PaymentOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentOrderCopyWith<$Res> {
  factory $PaymentOrderCopyWith(
    PaymentOrder value,
    $Res Function(PaymentOrder) then,
  ) = _$PaymentOrderCopyWithImpl<$Res, PaymentOrder>;
  @useResult
  $Res call({
    @JsonKey(name: 'order_id') String orderId,
    int amount,
    String currency,
    @JsonKey(name: 'key_id') String keyId,
  });
}

/// @nodoc
class _$PaymentOrderCopyWithImpl<$Res, $Val extends PaymentOrder>
    implements $PaymentOrderCopyWith<$Res> {
  _$PaymentOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? keyId = null,
  }) {
    return _then(
      _value.copyWith(
            orderId: null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            currency: null == currency
                ? _value.currency
                : currency // ignore: cast_nullable_to_non_nullable
                      as String,
            keyId: null == keyId
                ? _value.keyId
                : keyId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PaymentOrderImplCopyWith<$Res>
    implements $PaymentOrderCopyWith<$Res> {
  factory _$$PaymentOrderImplCopyWith(
    _$PaymentOrderImpl value,
    $Res Function(_$PaymentOrderImpl) then,
  ) = __$$PaymentOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'order_id') String orderId,
    int amount,
    String currency,
    @JsonKey(name: 'key_id') String keyId,
  });
}

/// @nodoc
class __$$PaymentOrderImplCopyWithImpl<$Res>
    extends _$PaymentOrderCopyWithImpl<$Res, _$PaymentOrderImpl>
    implements _$$PaymentOrderImplCopyWith<$Res> {
  __$$PaymentOrderImplCopyWithImpl(
    _$PaymentOrderImpl _value,
    $Res Function(_$PaymentOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? amount = null,
    Object? currency = null,
    Object? keyId = null,
  }) {
    return _then(
      _$PaymentOrderImpl(
        orderId: null == orderId
            ? _value.orderId
            : orderId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _value.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        keyId: null == keyId
            ? _value.keyId
            : keyId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentOrderImpl implements _PaymentOrder {
  const _$PaymentOrderImpl({
    @JsonKey(name: 'order_id') required this.orderId,
    required this.amount,
    required this.currency,
    @JsonKey(name: 'key_id') required this.keyId,
  });

  factory _$PaymentOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentOrderImplFromJson(json);

  @override
  @JsonKey(name: 'order_id')
  final String orderId;
  @override
  final int amount;
  @override
  final String currency;
  @override
  @JsonKey(name: 'key_id')
  final String keyId;

  @override
  String toString() {
    return 'PaymentOrder(orderId: $orderId, amount: $amount, currency: $currency, keyId: $keyId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentOrderImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.keyId, keyId) || other.keyId == keyId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, orderId, amount, currency, keyId);

  /// Create a copy of PaymentOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentOrderImplCopyWith<_$PaymentOrderImpl> get copyWith =>
      __$$PaymentOrderImplCopyWithImpl<_$PaymentOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentOrderImplToJson(this);
  }
}

abstract class _PaymentOrder implements PaymentOrder {
  const factory _PaymentOrder({
    @JsonKey(name: 'order_id') required final String orderId,
    required final int amount,
    required final String currency,
    @JsonKey(name: 'key_id') required final String keyId,
  }) = _$PaymentOrderImpl;

  factory _PaymentOrder.fromJson(Map<String, dynamic> json) =
      _$PaymentOrderImpl.fromJson;

  @override
  @JsonKey(name: 'order_id')
  String get orderId;
  @override
  int get amount;
  @override
  String get currency;
  @override
  @JsonKey(name: 'key_id')
  String get keyId;

  /// Create a copy of PaymentOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentOrderImplCopyWith<_$PaymentOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
