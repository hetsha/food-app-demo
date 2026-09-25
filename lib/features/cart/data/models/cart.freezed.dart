// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartFoodItem _$CartFoodItemFromJson(Map<String, dynamic> json) {
  return _CartFoodItem.fromJson(json);
}

/// @nodoc
mixin _$CartFoodItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVeg')
  bool get isVeg => throw _privateConstructorUsedError;
  @JsonKey(name: 'preparationTimeMinutes')
  int get preparationTimeMinutes => throw _privateConstructorUsedError;

  /// Serializes this CartFoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartFoodItemCopyWith<CartFoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartFoodItemCopyWith<$Res> {
  factory $CartFoodItemCopyWith(
    CartFoodItem value,
    $Res Function(CartFoodItem) then,
  ) = _$CartFoodItemCopyWithImpl<$Res, CartFoodItem>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    @JsonKey(name: 'imageUrls') List<String> imageUrls,
    @JsonKey(name: 'isVeg') bool isVeg,
    @JsonKey(name: 'preparationTimeMinutes') int preparationTimeMinutes,
  });
}

/// @nodoc
class _$CartFoodItemCopyWithImpl<$Res, $Val extends CartFoodItem>
    implements $CartFoodItemCopyWith<$Res> {
  _$CartFoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? isVeg = null,
    Object? preparationTimeMinutes = null,
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isVeg: null == isVeg
                ? _value.isVeg
                : isVeg // ignore: cast_nullable_to_non_nullable
                      as bool,
            preparationTimeMinutes: null == preparationTimeMinutes
                ? _value.preparationTimeMinutes
                : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartFoodItemImplCopyWith<$Res>
    implements $CartFoodItemCopyWith<$Res> {
  factory _$$CartFoodItemImplCopyWith(
    _$CartFoodItemImpl value,
    $Res Function(_$CartFoodItemImpl) then,
  ) = __$$CartFoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    @JsonKey(name: 'imageUrls') List<String> imageUrls,
    @JsonKey(name: 'isVeg') bool isVeg,
    @JsonKey(name: 'preparationTimeMinutes') int preparationTimeMinutes,
  });
}

/// @nodoc
class __$$CartFoodItemImplCopyWithImpl<$Res>
    extends _$CartFoodItemCopyWithImpl<$Res, _$CartFoodItemImpl>
    implements _$$CartFoodItemImplCopyWith<$Res> {
  __$$CartFoodItemImplCopyWithImpl(
    _$CartFoodItemImpl _value,
    $Res Function(_$CartFoodItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? isVeg = null,
    Object? preparationTimeMinutes = null,
  }) {
    return _then(
      _$CartFoodItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isVeg: null == isVeg
            ? _value.isVeg
            : isVeg // ignore: cast_nullable_to_non_nullable
                  as bool,
        preparationTimeMinutes: null == preparationTimeMinutes
            ? _value.preparationTimeMinutes
            : preparationTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartFoodItemImpl implements _CartFoodItem {
  const _$CartFoodItemImpl({
    required this.id,
    required this.name,
    required this.price,
    @JsonKey(name: 'imageUrls') final List<String> imageUrls = const [],
    @JsonKey(name: 'isVeg') this.isVeg = true,
    @JsonKey(name: 'preparationTimeMinutes') this.preparationTimeMinutes = 20,
  }) : _imageUrls = imageUrls;

  factory _$CartFoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartFoodItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  final List<String> _imageUrls;
  @override
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey(name: 'isVeg')
  final bool isVeg;
  @override
  @JsonKey(name: 'preparationTimeMinutes')
  final int preparationTimeMinutes;

  @override
  String toString() {
    return 'CartFoodItem(id: $id, name: $name, price: $price, imageUrls: $imageUrls, isVeg: $isVeg, preparationTimeMinutes: $preparationTimeMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartFoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.isVeg, isVeg) || other.isVeg == isVeg) &&
            (identical(other.preparationTimeMinutes, preparationTimeMinutes) ||
                other.preparationTimeMinutes == preparationTimeMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    const DeepCollectionEquality().hash(_imageUrls),
    isVeg,
    preparationTimeMinutes,
  );

  /// Create a copy of CartFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartFoodItemImplCopyWith<_$CartFoodItemImpl> get copyWith =>
      __$$CartFoodItemImplCopyWithImpl<_$CartFoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartFoodItemImplToJson(this);
  }
}

abstract class _CartFoodItem implements CartFoodItem {
  const factory _CartFoodItem({
    required final String id,
    required final String name,
    required final double price,
    @JsonKey(name: 'imageUrls') final List<String> imageUrls,
    @JsonKey(name: 'isVeg') final bool isVeg,
    @JsonKey(name: 'preparationTimeMinutes') final int preparationTimeMinutes,
  }) = _$CartFoodItemImpl;

  factory _CartFoodItem.fromJson(Map<String, dynamic> json) =
      _$CartFoodItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls;
  @override
  @JsonKey(name: 'isVeg')
  bool get isVeg;
  @override
  @JsonKey(name: 'preparationTimeMinutes')
  int get preparationTimeMinutes;

  /// Create a copy of CartFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartFoodItemImplCopyWith<_$CartFoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return _CartItem.fromJson(json);
}

/// @nodoc
mixin _$CartItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'foodItemId')
  String get foodItemId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'customizationItems')
  List<SelectedCustomization> get customizationItems =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'specialInstructions')
  String? get specialInstructions => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'foodItem')
  CartFoodItem get foodItem => throw _privateConstructorUsedError;
  @JsonKey(name: 'unitPrice')
  double get unitPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'itemTotal')
  double get itemTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'isAvailable')
  bool get isAvailable => throw _privateConstructorUsedError;

  /// Serializes this CartItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemCopyWith<CartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemCopyWith<$Res> {
  factory $CartItemCopyWith(CartItem value, $Res Function(CartItem) then) =
      _$CartItemCopyWithImpl<$Res, CartItem>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'foodItemId') String foodItemId,
    int quantity,
    @JsonKey(name: 'customizationItems')
    List<SelectedCustomization> customizationItems,
    @JsonKey(name: 'specialInstructions') String? specialInstructions,
    @JsonKey(name: 'createdAt') DateTime createdAt,
    @JsonKey(name: 'foodItem') CartFoodItem foodItem,
    @JsonKey(name: 'unitPrice') double unitPrice,
    @JsonKey(name: 'itemTotal') double itemTotal,
    @JsonKey(name: 'isAvailable') bool isAvailable,
  });

  $CartFoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class _$CartItemCopyWithImpl<$Res, $Val extends CartItem>
    implements $CartItemCopyWith<$Res> {
  _$CartItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItemId = null,
    Object? quantity = null,
    Object? customizationItems = null,
    Object? specialInstructions = freezed,
    Object? createdAt = null,
    Object? foodItem = null,
    Object? unitPrice = null,
    Object? itemTotal = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItemId: null == foodItemId
                ? _value.foodItemId
                : foodItemId // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            customizationItems: null == customizationItems
                ? _value.customizationItems
                : customizationItems // ignore: cast_nullable_to_non_nullable
                      as List<SelectedCustomization>,
            specialInstructions: freezed == specialInstructions
                ? _value.specialInstructions
                : specialInstructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as CartFoodItem,
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            itemTotal: null == itemTotal
                ? _value.itemTotal
                : itemTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            isAvailable: null == isAvailable
                ? _value.isAvailable
                : isAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartFoodItemCopyWith<$Res> get foodItem {
    return $CartFoodItemCopyWith<$Res>(_value.foodItem, (value) {
      return _then(_value.copyWith(foodItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemImplCopyWith<$Res>
    implements $CartItemCopyWith<$Res> {
  factory _$$CartItemImplCopyWith(
    _$CartItemImpl value,
    $Res Function(_$CartItemImpl) then,
  ) = __$$CartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'foodItemId') String foodItemId,
    int quantity,
    @JsonKey(name: 'customizationItems')
    List<SelectedCustomization> customizationItems,
    @JsonKey(name: 'specialInstructions') String? specialInstructions,
    @JsonKey(name: 'createdAt') DateTime createdAt,
    @JsonKey(name: 'foodItem') CartFoodItem foodItem,
    @JsonKey(name: 'unitPrice') double unitPrice,
    @JsonKey(name: 'itemTotal') double itemTotal,
    @JsonKey(name: 'isAvailable') bool isAvailable,
  });

  @override
  $CartFoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class __$$CartItemImplCopyWithImpl<$Res>
    extends _$CartItemCopyWithImpl<$Res, _$CartItemImpl>
    implements _$$CartItemImplCopyWith<$Res> {
  __$$CartItemImplCopyWithImpl(
    _$CartItemImpl _value,
    $Res Function(_$CartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? foodItemId = null,
    Object? quantity = null,
    Object? customizationItems = null,
    Object? specialInstructions = freezed,
    Object? createdAt = null,
    Object? foodItem = null,
    Object? unitPrice = null,
    Object? itemTotal = null,
    Object? isAvailable = null,
  }) {
    return _then(
      _$CartItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItemId: null == foodItemId
            ? _value.foodItemId
            : foodItemId // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        customizationItems: null == customizationItems
            ? _value._customizationItems
            : customizationItems // ignore: cast_nullable_to_non_nullable
                  as List<SelectedCustomization>,
        specialInstructions: freezed == specialInstructions
            ? _value.specialInstructions
            : specialInstructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as CartFoodItem,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        itemTotal: null == itemTotal
            ? _value.itemTotal
            : itemTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        isAvailable: null == isAvailable
            ? _value.isAvailable
            : isAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemImpl implements _CartItem {
  const _$CartItemImpl({
    required this.id,
    @JsonKey(name: 'foodItemId') required this.foodItemId,
    required this.quantity,
    @JsonKey(name: 'customizationItems')
    final List<SelectedCustomization> customizationItems = const [],
    @JsonKey(name: 'specialInstructions') this.specialInstructions,
    @JsonKey(name: 'createdAt') required this.createdAt,
    @JsonKey(name: 'foodItem') required this.foodItem,
    @JsonKey(name: 'unitPrice') required this.unitPrice,
    @JsonKey(name: 'itemTotal') required this.itemTotal,
    @JsonKey(name: 'isAvailable') this.isAvailable = true,
  }) : _customizationItems = customizationItems;

  factory _$CartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'foodItemId')
  final String foodItemId;
  @override
  final int quantity;
  final List<SelectedCustomization> _customizationItems;
  @override
  @JsonKey(name: 'customizationItems')
  List<SelectedCustomization> get customizationItems {
    if (_customizationItems is EqualUnmodifiableListView)
      return _customizationItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customizationItems);
  }

  @override
  @JsonKey(name: 'specialInstructions')
  final String? specialInstructions;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'foodItem')
  final CartFoodItem foodItem;
  @override
  @JsonKey(name: 'unitPrice')
  final double unitPrice;
  @override
  @JsonKey(name: 'itemTotal')
  final double itemTotal;
  @override
  @JsonKey(name: 'isAvailable')
  final bool isAvailable;

  @override
  String toString() {
    return 'CartItem(id: $id, foodItemId: $foodItemId, quantity: $quantity, customizationItems: $customizationItems, specialInstructions: $specialInstructions, createdAt: $createdAt, foodItem: $foodItem, unitPrice: $unitPrice, itemTotal: $itemTotal, isAvailable: $isAvailable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodItemId, foodItemId) ||
                other.foodItemId == foodItemId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            const DeepCollectionEquality().equals(
              other._customizationItems,
              _customizationItems,
            ) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.itemTotal, itemTotal) ||
                other.itemTotal == itemTotal) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    foodItemId,
    quantity,
    const DeepCollectionEquality().hash(_customizationItems),
    specialInstructions,
    createdAt,
    foodItem,
    unitPrice,
    itemTotal,
    isAvailable,
  );

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      __$$CartItemImplCopyWithImpl<_$CartItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemImplToJson(this);
  }
}

abstract class _CartItem implements CartItem {
  const factory _CartItem({
    required final String id,
    @JsonKey(name: 'foodItemId') required final String foodItemId,
    required final int quantity,
    @JsonKey(name: 'customizationItems')
    final List<SelectedCustomization> customizationItems,
    @JsonKey(name: 'specialInstructions') final String? specialInstructions,
    @JsonKey(name: 'createdAt') required final DateTime createdAt,
    @JsonKey(name: 'foodItem') required final CartFoodItem foodItem,
    @JsonKey(name: 'unitPrice') required final double unitPrice,
    @JsonKey(name: 'itemTotal') required final double itemTotal,
    @JsonKey(name: 'isAvailable') final bool isAvailable,
  }) = _$CartItemImpl;

  factory _CartItem.fromJson(Map<String, dynamic> json) =
      _$CartItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'foodItemId')
  String get foodItemId;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'customizationItems')
  List<SelectedCustomization> get customizationItems;
  @override
  @JsonKey(name: 'specialInstructions')
  String? get specialInstructions;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'foodItem')
  CartFoodItem get foodItem;
  @override
  @JsonKey(name: 'unitPrice')
  double get unitPrice;
  @override
  @JsonKey(name: 'itemTotal')
  double get itemTotal;
  @override
  @JsonKey(name: 'isAvailable')
  bool get isAvailable;

  /// Create a copy of CartItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemImplCopyWith<_$CartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Cart _$CartFromJson(Map<String, dynamic> json) {
  return _Cart.fromJson(json);
}

/// @nodoc
mixin _$Cart {
  String get id => throw _privateConstructorUsedError;
  List<CartItem> get items => throw _privateConstructorUsedError;
  @JsonKey(name: 'unavailableItems')
  List<CartItem> get unavailableItems => throw _privateConstructorUsedError;
  @JsonKey(name: 'itemTotal')
  double get itemTotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'itemCount')
  int get itemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'hasUnavailableItems')
  bool get hasUnavailableItems => throw _privateConstructorUsedError;

  /// Serializes this Cart to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartCopyWith<Cart> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartCopyWith<$Res> {
  factory $CartCopyWith(Cart value, $Res Function(Cart) then) =
      _$CartCopyWithImpl<$Res, Cart>;
  @useResult
  $Res call({
    String id,
    List<CartItem> items,
    @JsonKey(name: 'unavailableItems') List<CartItem> unavailableItems,
    @JsonKey(name: 'itemTotal') double itemTotal,
    @JsonKey(name: 'itemCount') int itemCount,
    @JsonKey(name: 'hasUnavailableItems') bool hasUnavailableItems,
  });
}

/// @nodoc
class _$CartCopyWithImpl<$Res, $Val extends Cart>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? unavailableItems = null,
    Object? itemTotal = null,
    Object? itemCount = null,
    Object? hasUnavailableItems = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            unavailableItems: null == unavailableItems
                ? _value.unavailableItems
                : unavailableItems // ignore: cast_nullable_to_non_nullable
                      as List<CartItem>,
            itemTotal: null == itemTotal
                ? _value.itemTotal
                : itemTotal // ignore: cast_nullable_to_non_nullable
                      as double,
            itemCount: null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                      as int,
            hasUnavailableItems: null == hasUnavailableItems
                ? _value.hasUnavailableItems
                : hasUnavailableItems // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartImplCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$$CartImplCopyWith(
    _$CartImpl value,
    $Res Function(_$CartImpl) then,
  ) = __$$CartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    List<CartItem> items,
    @JsonKey(name: 'unavailableItems') List<CartItem> unavailableItems,
    @JsonKey(name: 'itemTotal') double itemTotal,
    @JsonKey(name: 'itemCount') int itemCount,
    @JsonKey(name: 'hasUnavailableItems') bool hasUnavailableItems,
  });
}

/// @nodoc
class __$$CartImplCopyWithImpl<$Res>
    extends _$CartCopyWithImpl<$Res, _$CartImpl>
    implements _$$CartImplCopyWith<$Res> {
  __$$CartImplCopyWithImpl(_$CartImpl _value, $Res Function(_$CartImpl) _then)
    : super(_value, _then);

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? items = null,
    Object? unavailableItems = null,
    Object? itemTotal = null,
    Object? itemCount = null,
    Object? hasUnavailableItems = null,
  }) {
    return _then(
      _$CartImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        unavailableItems: null == unavailableItems
            ? _value._unavailableItems
            : unavailableItems // ignore: cast_nullable_to_non_nullable
                  as List<CartItem>,
        itemTotal: null == itemTotal
            ? _value.itemTotal
            : itemTotal // ignore: cast_nullable_to_non_nullable
                  as double,
        itemCount: null == itemCount
            ? _value.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        hasUnavailableItems: null == hasUnavailableItems
            ? _value.hasUnavailableItems
            : hasUnavailableItems // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartImpl implements _Cart {
  const _$CartImpl({
    required this.id,
    final List<CartItem> items = const [],
    @JsonKey(name: 'unavailableItems')
    final List<CartItem> unavailableItems = const [],
    @JsonKey(name: 'itemTotal') this.itemTotal = 0.0,
    @JsonKey(name: 'itemCount') this.itemCount = 0,
    @JsonKey(name: 'hasUnavailableItems') this.hasUnavailableItems = false,
  }) : _items = items,
       _unavailableItems = unavailableItems;

  factory _$CartImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartImplFromJson(json);

  @override
  final String id;
  final List<CartItem> _items;
  @override
  @JsonKey()
  List<CartItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<CartItem> _unavailableItems;
  @override
  @JsonKey(name: 'unavailableItems')
  List<CartItem> get unavailableItems {
    if (_unavailableItems is EqualUnmodifiableListView)
      return _unavailableItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unavailableItems);
  }

  @override
  @JsonKey(name: 'itemTotal')
  final double itemTotal;
  @override
  @JsonKey(name: 'itemCount')
  final int itemCount;
  @override
  @JsonKey(name: 'hasUnavailableItems')
  final bool hasUnavailableItems;

  @override
  String toString() {
    return 'Cart(id: $id, items: $items, unavailableItems: $unavailableItems, itemTotal: $itemTotal, itemCount: $itemCount, hasUnavailableItems: $hasUnavailableItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(
              other._unavailableItems,
              _unavailableItems,
            ) &&
            (identical(other.itemTotal, itemTotal) ||
                other.itemTotal == itemTotal) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.hasUnavailableItems, hasUnavailableItems) ||
                other.hasUnavailableItems == hasUnavailableItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    const DeepCollectionEquality().hash(_items),
    const DeepCollectionEquality().hash(_unavailableItems),
    itemTotal,
    itemCount,
    hasUnavailableItems,
  );

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      __$$CartImplCopyWithImpl<_$CartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartImplToJson(this);
  }
}

abstract class _Cart implements Cart {
  const factory _Cart({
    required final String id,
    final List<CartItem> items,
    @JsonKey(name: 'unavailableItems') final List<CartItem> unavailableItems,
    @JsonKey(name: 'itemTotal') final double itemTotal,
    @JsonKey(name: 'itemCount') final int itemCount,
    @JsonKey(name: 'hasUnavailableItems') final bool hasUnavailableItems,
  }) = _$CartImpl;

  factory _Cart.fromJson(Map<String, dynamic> json) = _$CartImpl.fromJson;

  @override
  String get id;
  @override
  List<CartItem> get items;
  @override
  @JsonKey(name: 'unavailableItems')
  List<CartItem> get unavailableItems;
  @override
  @JsonKey(name: 'itemTotal')
  double get itemTotal;
  @override
  @JsonKey(name: 'itemCount')
  int get itemCount;
  @override
  @JsonKey(name: 'hasUnavailableItems')
  bool get hasUnavailableItems;

  /// Create a copy of Cart
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartImplCopyWith<_$CartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
