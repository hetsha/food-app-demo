// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  String get id => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get itemTotal => throw _privateConstructorUsedError;
  double get deliveryFee => throw _privateConstructorUsedError;
  double get platformFee => throw _privateConstructorUsedError;
  double get taxAmount => throw _privateConstructorUsedError;
  double get discountAmount => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;
  DeliveryAddress? get deliveryAddress => throw _privateConstructorUsedError;
  String? get paymentMethod => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get specialInstructions => throw _privateConstructorUsedError;
  String? get estimatedDeliveryTime => throw _privateConstructorUsedError;
  DateTime? get actualDeliveryTime => throw _privateConstructorUsedError;
  String? get otpCode => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<OrderItem> get items => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call({
    String id,
    String status,
    double itemTotal,
    double deliveryFee,
    double platformFee,
    double taxAmount,
    double discountAmount,
    double grandTotal,
    DeliveryAddress? deliveryAddress,
    String? paymentMethod,
    String paymentStatus,
    String? specialInstructions,
    String? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? otpCode,
    DateTime createdAt,
    DateTime updatedAt,
    List<OrderItem> items,
  });

  $DeliveryAddressCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? itemTotal = null,
    Object? deliveryFee = null,
    Object? platformFee = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? grandTotal = null,
    Object? deliveryAddress = freezed,
    Object? paymentMethod = freezed,
    Object? paymentStatus = null,
    Object? specialInstructions = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? otpCode = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            itemTotal: null == itemTotal
                ? _value.itemTotal
                : itemTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryFee: null == deliveryFee
                ? _value.deliveryFee
                : deliveryFee // ignore: cast_nullable_to_non_nullable
                      as double,
            platformFee: null == platformFee
                ? _value.platformFee
                : platformFee // ignore: cast_nullable_to_non_nullable
                      as double,
            taxAmount: null == taxAmount
                ? _value.taxAmount
                : taxAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            discountAmount: null == discountAmount
                ? _value.discountAmount
                : discountAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            grandTotal: null == grandTotal
                ? _value.grandTotal
                : grandTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            deliveryAddress: freezed == deliveryAddress
                ? _value.deliveryAddress
                : deliveryAddress // ignore: cast_nullable_to_non_nullable
                      as DeliveryAddress?,
            paymentMethod: freezed == paymentMethod
                ? _value.paymentMethod
                : paymentMethod // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            specialInstructions: freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            estimatedDeliveryTime: freezed == estimatedDeliveryTime
                ? _value.estimatedDeliveryTime
                : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            actualDeliveryTime: freezed == actualDeliveryTime
                ? _value.actualDeliveryTime
                : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            otpCode: freezed == otpCode
                ? _value.otpCode
                : otpCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderItem>,
          )
          as $Val,
    );
  }

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress {
    if (_value.deliveryAddress == null) {
      return null;
    }

    return $DeliveryAddressCopyWith<$Res>(_value.deliveryAddress!, (value) {
      return _then(_value.copyWith(deliveryAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
    _$OrderImpl value,
    $Res Function(_$OrderImpl) then,
  ) = __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String status,
    double itemTotal,
    double deliveryFee,
    double platformFee,
    double taxAmount,
    double discountAmount,
    double grandTotal,
    DeliveryAddress? deliveryAddress,
    String? paymentMethod,
    String paymentStatus,
    String? specialInstructions,
    String? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? otpCode,
    DateTime createdAt,
    DateTime updatedAt,
    List<OrderItem> items,
  });

  @override
  $DeliveryAddressCopyWith<$Res>? get deliveryAddress;
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
    _$OrderImpl _value,
    $Res Function(_$OrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? status = null,
    Object? itemTotal = null,
    Object? deliveryFee = null,
    Object? platformFee = null,
    Object? taxAmount = null,
    Object? discountAmount = null,
    Object? grandTotal = null,
    Object? deliveryAddress = freezed,
    Object? paymentMethod = freezed,
    Object? paymentStatus = null,
    Object? specialInstructions = freezed,
    Object? estimatedDeliveryTime = freezed,
    Object? actualDeliveryTime = freezed,
    Object? otpCode = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? items = null,
  }) {
    return _then(
      _$OrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        itemTotal: null == itemTotal
            ? _value.itemTotal
            : itemTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryFee: null == deliveryFee
            ? _value.deliveryFee
            : deliveryFee // ignore: cast_nullable_to_non_nullable
                  as double,
        platformFee: null == platformFee
            ? _value.platformFee
            : platformFee // ignore: cast_nullable_to_non_nullable
                  as double,
        taxAmount: null == taxAmount
            ? _value.taxAmount
            : taxAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        discountAmount: null == discountAmount
            ? _value.discountAmount
            : discountAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        grandTotal: null == grandTotal
            ? _value.grandTotal
            : grandTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        deliveryAddress: freezed == deliveryAddress
            ? _value.deliveryAddress
            : deliveryAddress // ignore: cast_nullable_to_non_nullable
                  as DeliveryAddress?,
        paymentMethod: freezed == paymentMethod
            ? _value.paymentMethod
            : paymentMethod // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        specialInstructions: freezed == specialInstructions
            ? _value.specialInstructions
            : specialInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        estimatedDeliveryTime: freezed == estimatedDeliveryTime
            ? _value.estimatedDeliveryTime
            : estimatedDeliveryTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        actualDeliveryTime: freezed == actualDeliveryTime
            ? _value.actualDeliveryTime
            : actualDeliveryTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        otpCode: freezed == otpCode
            ? _value.otpCode
            : otpCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderItem>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl({
    required this.id,
    required this.status,
    required this.itemTotal,
    this.deliveryFee = 30.0,
    this.platformFee = 2.0,
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
    required this.grandTotal,
    this.deliveryAddress,
    this.paymentMethod,
    this.paymentStatus = 'pending',
    this.specialInstructions,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.otpCode,
    required this.createdAt,
    required this.updatedAt,
    final List<OrderItem> items = const [],
  }) : _items = items;

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  @override
  final String id;
  @override
  final String status;
  @override
  final double itemTotal;
  @override
  @JsonKey()
  final double deliveryFee;
  @override
  @JsonKey()
  final double platformFee;
  @override
  @JsonKey()
  final double taxAmount;
  @override
  @JsonKey()
  final double discountAmount;
  @override
  final double grandTotal;
  @override
  final DeliveryAddress? deliveryAddress;
  @override
  final String? paymentMethod;
  @override
  @JsonKey()
  final String paymentStatus;
  @override
  final String? specialInstructions;
  @override
  final String? estimatedDeliveryTime;
  @override
  final DateTime? actualDeliveryTime;
  @override
  final String? otpCode;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final List<OrderItem> _items;
  @override
  @JsonKey()
  List<OrderItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'Order(id: $id, status: $status, itemTotal: $itemTotal, deliveryFee: $deliveryFee, platformFee: $platformFee, taxAmount: $taxAmount, discountAmount: $discountAmount, grandTotal: $grandTotal, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, specialInstructions: $specialInstructions, estimatedDeliveryTime: $estimatedDeliveryTime, actualDeliveryTime: $actualDeliveryTime, otpCode: $otpCode, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.itemTotal, itemTotal) ||
                other.itemTotal == itemTotal) &&
            (identical(other.deliveryFee, deliveryFee) ||
                other.deliveryFee == deliveryFee) &&
            (identical(other.platformFee, platformFee) ||
                other.platformFee == platformFee) &&
            (identical(other.taxAmount, taxAmount) ||
                other.taxAmount == taxAmount) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.deliveryAddress, deliveryAddress) ||
                other.deliveryAddress == deliveryAddress) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.estimatedDeliveryTime, estimatedDeliveryTime) ||
                other.estimatedDeliveryTime == estimatedDeliveryTime) &&
            (identical(other.actualDeliveryTime, actualDeliveryTime) ||
                other.actualDeliveryTime == actualDeliveryTime) &&
            (identical(other.otpCode, otpCode) || other.otpCode == otpCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    status,
    itemTotal,
    deliveryFee,
    platformFee,
    taxAmount,
    discountAmount,
    grandTotal,
    deliveryAddress,
    paymentMethod,
    paymentStatus,
    specialInstructions,
    estimatedDeliveryTime,
    actualDeliveryTime,
    otpCode,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(this);
  }
}

abstract class _Order implements Order {
  const factory _Order({
    required final String id,
    required final String status,
    required final double itemTotal,
    final double deliveryFee,
    final double platformFee,
    final double taxAmount,
    final double discountAmount,
    required final double grandTotal,
    final DeliveryAddress? deliveryAddress,
    final String? paymentMethod,
    final String paymentStatus,
    final String? specialInstructions,
    final String? estimatedDeliveryTime,
    final DateTime? actualDeliveryTime,
    final String? otpCode,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final List<OrderItem> items,
  }) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  @override
  String get id;
  @override
  String get status;
  @override
  double get itemTotal;
  @override
  double get deliveryFee;
  @override
  double get platformFee;
  @override
  double get taxAmount;
  @override
  double get discountAmount;
  @override
  double get grandTotal;
  @override
  DeliveryAddress? get deliveryAddress;
  @override
  String? get paymentMethod;
  @override
  String get paymentStatus;
  @override
  String? get specialInstructions;
  @override
  String? get estimatedDeliveryTime;
  @override
  DateTime? get actualDeliveryTime;
  @override
  String? get otpCode;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<OrderItem> get items;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) {
  return _OrderItem.fromJson(json);
}

/// @nodoc
mixin _$OrderItem {
  String get id => throw _privateConstructorUsedError;
  OrderFoodItem get foodItem => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPrice => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  List<OrderCustomization> get customizations =>
      throw _privateConstructorUsedError;

  /// Serializes this OrderItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemCopyWith<OrderItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemCopyWith<$Res> {
  factory $OrderItemCopyWith(OrderItem value, $Res Function(OrderItem) then) =
      _$OrderItemCopyWithImpl<$Res, OrderItem>;
  @useResult
  $Res call({
    String id,
    OrderFoodItem foodItem,
    int quantity,
    double unitPrice,
    double total,
    List<OrderCustomization> customizations,
  });

  $OrderFoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class _$OrderItemCopyWithImpl<$Res, $Val extends OrderItem>
    implements $OrderItemCopyWith<$Res> {
  _$OrderItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? total = null,
    Object? customizations = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as OrderFoodItem,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            customizations: null == customizations
                ? _value.customizations
                : customizations // ignore: cast_nullable_to_non_nullable
                      as List<OrderCustomization>,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderFoodItemCopyWith<$Res> get foodItem {
    return $OrderFoodItemCopyWith<$Res>(_value.foodItem, (value) {
      return _then(_value.copyWith(foodItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderItemImplCopyWith<$Res>
    implements $OrderItemCopyWith<$Res> {
  factory _$$OrderItemImplCopyWith(
    _$OrderItemImpl value,
    $Res Function(_$OrderItemImpl) then,
  ) = __$$OrderItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    OrderFoodItem foodItem,
    int quantity,
    double unitPrice,
    double total,
    List<OrderCustomization> customizations,
  });

  @override
  $OrderFoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class __$$OrderItemImplCopyWithImpl<$Res>
    extends _$OrderItemCopyWithImpl<$Res, _$OrderItemImpl>
    implements _$$OrderItemImplCopyWith<$Res> {
  __$$OrderItemImplCopyWithImpl(
    _$OrderItemImpl _value,
    $Res Function(_$OrderItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItem = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? total = null,
    Object? customizations = null,
  }) {
    return _then(
      _$OrderItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as OrderFoodItem,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        customizations: null == customizations
            ? _value._customizations
            : customizations // ignore: cast_nullable_to_non_nullable
                  as List<OrderCustomization>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderItemImpl implements _OrderItem {
  const _$OrderItemImpl({
    required this.id,
    required this.foodItem,
    this.quantity = 1,
    this.unitPrice = 0.0,
    this.total = 0.0,
    final List<OrderCustomization> customizations = const [],
  }) : _customizations = customizations;

  factory _$OrderItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemImplFromJson(json);

  @override
  final String id;
  @override
  final OrderFoodItem foodItem;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final double unitPrice;
  @override
  @JsonKey()
  final double total;
  final List<OrderCustomization> _customizations;
  @override
  @JsonKey()
  List<OrderCustomization> get customizations {
    if (_customizations is EqualUnmodifiableListView) return _customizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customizations);
  }

  @override
  String toString() {
    return 'OrderItem(id: $id, foodItem: $foodItem, quantity: $quantity, unitPrice: $unitPrice, total: $total, customizations: $customizations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.total, total) || other.total == total) &&
            const DeepCollectionEquality().equals(
              other._customizations,
              _customizations,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    foodItem,
    quantity,
    unitPrice,
    total,
    const DeepCollectionEquality().hash(_customizations),
  );

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      __$$OrderItemImplCopyWithImpl<_$OrderItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemImplToJson(this);
  }
}

abstract class _OrderItem implements OrderItem {
  const factory _OrderItem({
    required final String id,
    required final OrderFoodItem foodItem,
    final int quantity,
    final double unitPrice,
    final double total,
    final List<OrderCustomization> customizations,
  }) = _$OrderItemImpl;

  factory _OrderItem.fromJson(Map<String, dynamic> json) =
      _$OrderItemImpl.fromJson;

  @override
  String get id;
  @override
  OrderFoodItem get foodItem;
  @override
  int get quantity;
  @override
  double get unitPrice;
  @override
  double get total;
  @override
  List<OrderCustomization> get customizations;

  /// Create a copy of OrderItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemImplCopyWith<_$OrderItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderFoodItem _$OrderFoodItemFromJson(Map<String, dynamic> json) {
  return _OrderFoodItem.fromJson(json);
}

/// @nodoc
mixin _$OrderFoodItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  bool get isVeg => throw _privateConstructorUsedError;

  /// Serializes this OrderFoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderFoodItemCopyWith<OrderFoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderFoodItemCopyWith<$Res> {
  factory $OrderFoodItemCopyWith(
    OrderFoodItem value,
    $Res Function(OrderFoodItem) then,
  ) = _$OrderFoodItemCopyWithImpl<$Res, OrderFoodItem>;
  @useResult
  $Res call({String id, String name, List<String> imageUrls, bool isVeg});
}

/// @nodoc
class _$OrderFoodItemCopyWithImpl<$Res, $Val extends OrderFoodItem>
    implements $OrderFoodItemCopyWith<$Res> {
  _$OrderFoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrls = null,
    Object? isVeg = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isVeg: null == isVeg
                ? _value.isVeg
                : isVeg // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderFoodItemImplCopyWith<$Res>
    implements $OrderFoodItemCopyWith<$Res> {
  factory _$$OrderFoodItemImplCopyWith(
    _$OrderFoodItemImpl value,
    $Res Function(_$OrderFoodItemImpl) then,
  ) = __$$OrderFoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, List<String> imageUrls, bool isVeg});
}

/// @nodoc
class __$$OrderFoodItemImplCopyWithImpl<$Res>
    extends _$OrderFoodItemCopyWithImpl<$Res, _$OrderFoodItemImpl>
    implements _$$OrderFoodItemImplCopyWith<$Res> {
  __$$OrderFoodItemImplCopyWithImpl(
    _$OrderFoodItemImpl _value,
    $Res Function(_$OrderFoodItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? imageUrls = null,
    Object? isVeg = null,
  }) {
    return _then(
      _$OrderFoodItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isVeg: null == isVeg
            ? _value.isVeg
            : isVeg // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderFoodItemImpl implements _OrderFoodItem {
  const _$OrderFoodItemImpl({
    required this.id,
    required this.name,
    final List<String> imageUrls = const [],
    this.isVeg = true,
  }) : _imageUrls = imageUrls;

  factory _$OrderFoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderFoodItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  final bool isVeg;

  @override
  String toString() {
    return 'OrderFoodItem(id: $id, name: $name, imageUrls: $imageUrls, isVeg: $isVeg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderFoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.isVeg, isVeg) || other.isVeg == isVeg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_imageUrls),
    isVeg,
  );

  /// Create a copy of OrderFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderFoodItemImplCopyWith<_$OrderFoodItemImpl> get copyWith =>
      __$$OrderFoodItemImplCopyWithImpl<_$OrderFoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderFoodItemImplToJson(this);
  }
}

abstract class _OrderFoodItem implements OrderFoodItem {
  const factory _OrderFoodItem({
    required final String id,
    required final String name,
    final List<String> imageUrls,
    final bool isVeg,
  }) = _$OrderFoodItemImpl;

  factory _OrderFoodItem.fromJson(Map<String, dynamic> json) =
      _$OrderFoodItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<String> get imageUrls;
  @override
  bool get isVeg;

  /// Create a copy of OrderFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderFoodItemImplCopyWith<_$OrderFoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderCustomization _$OrderCustomizationFromJson(Map<String, dynamic> json) {
  return _OrderCustomization.fromJson(json);
}

/// @nodoc
mixin _$OrderCustomization {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get additionalPrice => throw _privateConstructorUsedError;

  /// Serializes this OrderCustomization to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderCustomization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCustomizationCopyWith<OrderCustomization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCustomizationCopyWith<$Res> {
  factory $OrderCustomizationCopyWith(
    OrderCustomization value,
    $Res Function(OrderCustomization) then,
  ) = _$OrderCustomizationCopyWithImpl<$Res, OrderCustomization>;
  @useResult
  $Res call({String id, String name, double additionalPrice});
}

/// @nodoc
class _$OrderCustomizationCopyWithImpl<$Res, $Val extends OrderCustomization>
    implements $OrderCustomizationCopyWith<$Res> {
  _$OrderCustomizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderCustomization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? additionalPrice = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            additionalPrice: null == additionalPrice
                ? _value.additionalPrice
                : additionalPrice // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderCustomizationImplCopyWith<$Res>
    implements $OrderCustomizationCopyWith<$Res> {
  factory _$$OrderCustomizationImplCopyWith(
    _$OrderCustomizationImpl value,
    $Res Function(_$OrderCustomizationImpl) then,
  ) = __$$OrderCustomizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, double additionalPrice});
}

/// @nodoc
class __$$OrderCustomizationImplCopyWithImpl<$Res>
    extends _$OrderCustomizationCopyWithImpl<$Res, _$OrderCustomizationImpl>
    implements _$$OrderCustomizationImplCopyWith<$Res> {
  __$$OrderCustomizationImplCopyWithImpl(
    _$OrderCustomizationImpl _value,
    $Res Function(_$OrderCustomizationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderCustomization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? additionalPrice = null,
  }) {
    return _then(
      _$OrderCustomizationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        additionalPrice: null == additionalPrice
            ? _value.additionalPrice
            : additionalPrice // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderCustomizationImpl implements _OrderCustomization {
  const _$OrderCustomizationImpl({
    required this.id,
    required this.name,
    this.additionalPrice = 0.0,
  });

  factory _$OrderCustomizationImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderCustomizationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final double additionalPrice;

  @override
  String toString() {
    return 'OrderCustomization(id: $id, name: $name, additionalPrice: $additionalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderCustomizationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.additionalPrice, additionalPrice) ||
                other.additionalPrice == additionalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, additionalPrice);

  /// Create a copy of OrderCustomization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderCustomizationImplCopyWith<_$OrderCustomizationImpl> get copyWith =>
      __$$OrderCustomizationImplCopyWithImpl<_$OrderCustomizationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderCustomizationImplToJson(this);
  }
}

abstract class _OrderCustomization implements OrderCustomization {
  const factory _OrderCustomization({
    required final String id,
    required final String name,
    final double additionalPrice,
  }) = _$OrderCustomizationImpl;

  factory _OrderCustomization.fromJson(Map<String, dynamic> json) =
      _$OrderCustomizationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get additionalPrice;

  /// Create a copy of OrderCustomization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderCustomizationImplCopyWith<_$OrderCustomizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) {
  return _DeliveryAddress.fromJson(json);
}

/// @nodoc
mixin _$DeliveryAddress {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get addressLine1 => throw _privateConstructorUsedError;
  String? get addressLine2 => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get postalCode => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;

  /// Serializes this DeliveryAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeliveryAddressCopyWith<DeliveryAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeliveryAddressCopyWith<$Res> {
  factory $DeliveryAddressCopyWith(
    DeliveryAddress value,
    $Res Function(DeliveryAddress) then,
  ) = _$DeliveryAddressCopyWithImpl<$Res, DeliveryAddress>;
  @useResult
  $Res call({
    String id,
    String label,
    String addressLine1,
    String? addressLine2,
    String city,
    String state,
    String postalCode,
    double latitude,
    double longitude,
    String phone,
  });
}

/// @nodoc
class _$DeliveryAddressCopyWithImpl<$Res, $Val extends DeliveryAddress>
    implements $DeliveryAddressCopyWith<$Res> {
  _$DeliveryAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? addressLine1 = null,
    Object? addressLine2 = freezed,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            addressLine1: null == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                      as String,
            addressLine2: freezed == addressLine2
                ? _value.addressLine2
                : addressLine2 // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String,
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as String,
            postalCode: null == postalCode
                ? _value.postalCode
                : postalCode // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeliveryAddressImplCopyWith<$Res>
    implements $DeliveryAddressCopyWith<$Res> {
  factory _$$DeliveryAddressImplCopyWith(
    _$DeliveryAddressImpl value,
    $Res Function(_$DeliveryAddressImpl) then,
  ) = __$$DeliveryAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String label,
    String addressLine1,
    String? addressLine2,
    String city,
    String state,
    String postalCode,
    double latitude,
    double longitude,
    String phone,
  });
}

/// @nodoc
class __$$DeliveryAddressImplCopyWithImpl<$Res>
    extends _$DeliveryAddressCopyWithImpl<$Res, _$DeliveryAddressImpl>
    implements _$$DeliveryAddressImplCopyWith<$Res> {
  __$$DeliveryAddressImplCopyWithImpl(
    _$DeliveryAddressImpl _value,
    $Res Function(_$DeliveryAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? addressLine1 = null,
    Object? addressLine2 = freezed,
    Object? city = null,
    Object? state = null,
    Object? postalCode = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? phone = null,
  }) {
    return _then(
      _$DeliveryAddressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        addressLine1: null == addressLine1
            ? _value.addressLine1
            : addressLine1 // ignore: cast_nullable_to_non_nullable
                  as String,
        addressLine2: freezed == addressLine2
            ? _value.addressLine2
            : addressLine2 // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: null == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String,
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as String,
        postalCode: null == postalCode
            ? _value.postalCode
            : postalCode // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeliveryAddressImpl extends _DeliveryAddress {
  const _$DeliveryAddressImpl({
    required this.id,
    required this.label,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    this.latitude = 0.0,
    this.longitude = 0.0,
    required this.phone,
  }) : super._();

  factory _$DeliveryAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeliveryAddressImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String addressLine1;
  @override
  final String? addressLine2;
  @override
  final String city;
  @override
  final String state;
  @override
  final String postalCode;
  @override
  @JsonKey()
  final double latitude;
  @override
  @JsonKey()
  final double longitude;
  @override
  final String phone;

  @override
  String toString() {
    return 'DeliveryAddress(id: $id, label: $label, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, phone: $phone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeliveryAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.phone, phone) || other.phone == phone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    label,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    latitude,
    longitude,
    phone,
  );

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeliveryAddressImplCopyWith<_$DeliveryAddressImpl> get copyWith =>
      __$$DeliveryAddressImplCopyWithImpl<_$DeliveryAddressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DeliveryAddressImplToJson(this);
  }
}

abstract class _DeliveryAddress extends DeliveryAddress {
  const factory _DeliveryAddress({
    required final String id,
    required final String label,
    required final String addressLine1,
    final String? addressLine2,
    required final String city,
    required final String state,
    required final String postalCode,
    final double latitude,
    final double longitude,
    required final String phone,
  }) = _$DeliveryAddressImpl;
  const _DeliveryAddress._() : super._();

  factory _DeliveryAddress.fromJson(Map<String, dynamic> json) =
      _$DeliveryAddressImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get addressLine1;
  @override
  String? get addressLine2;
  @override
  String get city;
  @override
  String get state;
  @override
  String get postalCode;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  String get phone;

  /// Create a copy of DeliveryAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeliveryAddressImplCopyWith<_$DeliveryAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
