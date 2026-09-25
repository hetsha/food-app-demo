// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) {
  return _WishlistItem.fromJson(json);
}

/// @nodoc
mixin _$WishlistItem {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'food_item')
  WishlistFoodItem get foodItem => throw _privateConstructorUsedError;

  /// Serializes this WishlistItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistItemCopyWith<WishlistItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistItemCopyWith<$Res> {
  factory $WishlistItemCopyWith(
    WishlistItem value,
    $Res Function(WishlistItem) then,
  ) = _$WishlistItemCopyWithImpl<$Res, WishlistItem>;
  @useResult
  $Res call({String id, @JsonKey(name: 'food_item') WishlistFoodItem foodItem});

  $WishlistFoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class _$WishlistItemCopyWithImpl<$Res, $Val extends WishlistItem>
    implements $WishlistItemCopyWith<$Res> {
  _$WishlistItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? foodItem = null}) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            foodItem: null == foodItem
                ? _value.foodItem
                : foodItem // ignore: cast_nullable_to_non_nullable
                      as WishlistFoodItem,
          )
          as $Val,
    );
  }

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WishlistFoodItemCopyWith<$Res> get foodItem {
    return $WishlistFoodItemCopyWith<$Res>(_value.foodItem, (value) {
      return _then(_value.copyWith(foodItem: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WishlistItemImplCopyWith<$Res>
    implements $WishlistItemCopyWith<$Res> {
  factory _$$WishlistItemImplCopyWith(
    _$WishlistItemImpl value,
    $Res Function(_$WishlistItemImpl) then,
  ) = __$$WishlistItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, @JsonKey(name: 'food_item') WishlistFoodItem foodItem});

  @override
  $WishlistFoodItemCopyWith<$Res> get foodItem;
}

/// @nodoc
class __$$WishlistItemImplCopyWithImpl<$Res>
    extends _$WishlistItemCopyWithImpl<$Res, _$WishlistItemImpl>
    implements _$$WishlistItemImplCopyWith<$Res> {
  __$$WishlistItemImplCopyWithImpl(
    _$WishlistItemImpl _value,
    $Res Function(_$WishlistItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? foodItem = null}) {
    return _then(
      _$WishlistItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        foodItem: null == foodItem
            ? _value.foodItem
            : foodItem // ignore: cast_nullable_to_non_nullable
                  as WishlistFoodItem,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WishlistItemImpl implements _WishlistItem {
  const _$WishlistItemImpl({
    required this.id,
    @JsonKey(name: 'food_item') required this.foodItem,
  });

  factory _$WishlistItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistItemImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'food_item')
  final WishlistFoodItem foodItem;

  @override
  String toString() {
    return 'WishlistItem(id: $id, foodItem: $foodItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.foodItem, foodItem) ||
                other.foodItem == foodItem));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, foodItem);

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistItemImplCopyWith<_$WishlistItemImpl> get copyWith =>
      __$$WishlistItemImplCopyWithImpl<_$WishlistItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistItemImplToJson(this);
  }
}

abstract class _WishlistItem implements WishlistItem {
  const factory _WishlistItem({
    required final String id,
    @JsonKey(name: 'food_item') required final WishlistFoodItem foodItem,
  }) = _$WishlistItemImpl;

  factory _WishlistItem.fromJson(Map<String, dynamic> json) =
      _$WishlistItemImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'food_item')
  WishlistFoodItem get foodItem;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistItemImplCopyWith<_$WishlistItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WishlistFoodItem _$WishlistFoodItemFromJson(Map<String, dynamic> json) {
  return _WishlistFoodItem.fromJson(json);
}

/// @nodoc
mixin _$WishlistFoodItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_veg')
  bool get isVeg => throw _privateConstructorUsedError;

  /// Serializes this WishlistFoodItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistFoodItemCopyWith<WishlistFoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistFoodItemCopyWith<$Res> {
  factory $WishlistFoodItemCopyWith(
    WishlistFoodItem value,
    $Res Function(WishlistFoodItem) then,
  ) = _$WishlistFoodItemCopyWithImpl<$Res, WishlistFoodItem>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    @JsonKey(name: 'image_urls') List<String> imageUrls,
    double? rating,
    @JsonKey(name: 'is_veg') bool isVeg,
  });
}

/// @nodoc
class _$WishlistFoodItemCopyWithImpl<$Res, $Val extends WishlistFoodItem>
    implements $WishlistFoodItemCopyWith<$Res> {
  _$WishlistFoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? rating = freezed,
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
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: freezed == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double?,
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
abstract class _$$WishlistFoodItemImplCopyWith<$Res>
    implements $WishlistFoodItemCopyWith<$Res> {
  factory _$$WishlistFoodItemImplCopyWith(
    _$WishlistFoodItemImpl value,
    $Res Function(_$WishlistFoodItemImpl) then,
  ) = __$$WishlistFoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    @JsonKey(name: 'image_urls') List<String> imageUrls,
    double? rating,
    @JsonKey(name: 'is_veg') bool isVeg,
  });
}

/// @nodoc
class __$$WishlistFoodItemImplCopyWithImpl<$Res>
    extends _$WishlistFoodItemCopyWithImpl<$Res, _$WishlistFoodItemImpl>
    implements _$$WishlistFoodItemImplCopyWith<$Res> {
  __$$WishlistFoodItemImplCopyWithImpl(
    _$WishlistFoodItemImpl _value,
    $Res Function(_$WishlistFoodItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishlistFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? rating = freezed,
    Object? isVeg = null,
  }) {
    return _then(
      _$WishlistFoodItemImpl(
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
        rating: freezed == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double?,
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
class _$WishlistFoodItemImpl implements _WishlistFoodItem {
  const _$WishlistFoodItemImpl({
    required this.id,
    required this.name,
    required this.price,
    @JsonKey(name: 'image_urls') final List<String> imageUrls = const [],
    this.rating,
    @JsonKey(name: 'is_veg') this.isVeg = true,
  }) : _imageUrls = imageUrls;

  factory _$WishlistFoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistFoodItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  final List<String> _imageUrls;
  @override
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final double? rating;
  @override
  @JsonKey(name: 'is_veg')
  final bool isVeg;

  @override
  String toString() {
    return 'WishlistFoodItem(id: $id, name: $name, price: $price, imageUrls: $imageUrls, rating: $rating, isVeg: $isVeg)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistFoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isVeg, isVeg) || other.isVeg == isVeg));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    const DeepCollectionEquality().hash(_imageUrls),
    rating,
    isVeg,
  );

  /// Create a copy of WishlistFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistFoodItemImplCopyWith<_$WishlistFoodItemImpl> get copyWith =>
      __$$WishlistFoodItemImplCopyWithImpl<_$WishlistFoodItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistFoodItemImplToJson(this);
  }
}

abstract class _WishlistFoodItem implements WishlistFoodItem {
  const factory _WishlistFoodItem({
    required final String id,
    required final String name,
    required final double price,
    @JsonKey(name: 'image_urls') final List<String> imageUrls,
    final double? rating,
    @JsonKey(name: 'is_veg') final bool isVeg,
  }) = _$WishlistFoodItemImpl;

  factory _WishlistFoodItem.fromJson(Map<String, dynamic> json) =
      _$WishlistFoodItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price;
  @override
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls;
  @override
  double? get rating;
  @override
  @JsonKey(name: 'is_veg')
  bool get isVeg;

  /// Create a copy of WishlistFoodItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistFoodItemImplCopyWith<_$WishlistFoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
