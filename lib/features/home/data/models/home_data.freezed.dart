// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

HomeData _$HomeDataFromJson(Map<String, dynamic> json) {
  return _HomeData.fromJson(json);
}

/// @nodoc
mixin _$HomeData {
  List<BannerItem> get banners => throw _privateConstructorUsedError;
  List<HomeCategory> get categories => throw _privateConstructorUsedError;
  List<HomeFood> get featuredFoods => throw _privateConstructorUsedError;
  List<HomeFood> get bestsellers => throw _privateConstructorUsedError;
  List<HomeFood> get healthyPicks => throw _privateConstructorUsedError;

  /// Serializes this HomeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeDataCopyWith<HomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDataCopyWith<$Res> {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) then) =
      _$HomeDataCopyWithImpl<$Res, HomeData>;
  @useResult
  $Res call({
    List<BannerItem> banners,
    List<HomeCategory> categories,
    List<HomeFood> featuredFoods,
    List<HomeFood> bestsellers,
    List<HomeFood> healthyPicks,
  });
}

/// @nodoc
class _$HomeDataCopyWithImpl<$Res, $Val extends HomeData>
    implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banners = null,
    Object? categories = null,
    Object? featuredFoods = null,
    Object? bestsellers = null,
    Object? healthyPicks = null,
  }) {
    return _then(
      _value.copyWith(
            banners: null == banners
                ? _value.banners
                : banners // ignore: cast_nullable_to_non_nullable
                      as List<BannerItem>,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<HomeCategory>,
            featuredFoods: null == featuredFoods
                ? _value.featuredFoods
                : featuredFoods // ignore: cast_nullable_to_non_nullable
                      as List<HomeFood>,
            bestsellers: null == bestsellers
                ? _value.bestsellers
                : bestsellers // ignore: cast_nullable_to_non_nullable
                      as List<HomeFood>,
            healthyPicks: null == healthyPicks
                ? _value.healthyPicks
                : healthyPicks // ignore: cast_nullable_to_non_nullable
                      as List<HomeFood>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeDataImplCopyWith<$Res>
    implements $HomeDataCopyWith<$Res> {
  factory _$$HomeDataImplCopyWith(
    _$HomeDataImpl value,
    $Res Function(_$HomeDataImpl) then,
  ) = __$$HomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<BannerItem> banners,
    List<HomeCategory> categories,
    List<HomeFood> featuredFoods,
    List<HomeFood> bestsellers,
    List<HomeFood> healthyPicks,
  });
}

/// @nodoc
class __$$HomeDataImplCopyWithImpl<$Res>
    extends _$HomeDataCopyWithImpl<$Res, _$HomeDataImpl>
    implements _$$HomeDataImplCopyWith<$Res> {
  __$$HomeDataImplCopyWithImpl(
    _$HomeDataImpl _value,
    $Res Function(_$HomeDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banners = null,
    Object? categories = null,
    Object? featuredFoods = null,
    Object? bestsellers = null,
    Object? healthyPicks = null,
  }) {
    return _then(
      _$HomeDataImpl(
        banners: null == banners
            ? _value._banners
            : banners // ignore: cast_nullable_to_non_nullable
                  as List<BannerItem>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<HomeCategory>,
        featuredFoods: null == featuredFoods
            ? _value._featuredFoods
            : featuredFoods // ignore: cast_nullable_to_non_nullable
                  as List<HomeFood>,
        bestsellers: null == bestsellers
            ? _value._bestsellers
            : bestsellers // ignore: cast_nullable_to_non_nullable
                  as List<HomeFood>,
        healthyPicks: null == healthyPicks
            ? _value._healthyPicks
            : healthyPicks // ignore: cast_nullable_to_non_nullable
                  as List<HomeFood>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeDataImpl implements _HomeData {
  const _$HomeDataImpl({
    final List<BannerItem> banners = const [],
    final List<HomeCategory> categories = const [],
    final List<HomeFood> featuredFoods = const [],
    final List<HomeFood> bestsellers = const [],
    final List<HomeFood> healthyPicks = const [],
  }) : _banners = banners,
       _categories = categories,
       _featuredFoods = featuredFoods,
       _bestsellers = bestsellers,
       _healthyPicks = healthyPicks;

  factory _$HomeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeDataImplFromJson(json);

  final List<BannerItem> _banners;
  @override
  @JsonKey()
  List<BannerItem> get banners {
    if (_banners is EqualUnmodifiableListView) return _banners;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banners);
  }

  final List<HomeCategory> _categories;
  @override
  @JsonKey()
  List<HomeCategory> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  final List<HomeFood> _featuredFoods;
  @override
  @JsonKey()
  List<HomeFood> get featuredFoods {
    if (_featuredFoods is EqualUnmodifiableListView) return _featuredFoods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_featuredFoods);
  }

  final List<HomeFood> _bestsellers;
  @override
  @JsonKey()
  List<HomeFood> get bestsellers {
    if (_bestsellers is EqualUnmodifiableListView) return _bestsellers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bestsellers);
  }

  final List<HomeFood> _healthyPicks;
  @override
  @JsonKey()
  List<HomeFood> get healthyPicks {
    if (_healthyPicks is EqualUnmodifiableListView) return _healthyPicks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthyPicks);
  }

  @override
  String toString() {
    return 'HomeData(banners: $banners, categories: $categories, featuredFoods: $featuredFoods, bestsellers: $bestsellers, healthyPicks: $healthyPicks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDataImpl &&
            const DeepCollectionEquality().equals(other._banners, _banners) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            const DeepCollectionEquality().equals(
              other._featuredFoods,
              _featuredFoods,
            ) &&
            const DeepCollectionEquality().equals(
              other._bestsellers,
              _bestsellers,
            ) &&
            const DeepCollectionEquality().equals(
              other._healthyPicks,
              _healthyPicks,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_banners),
    const DeepCollectionEquality().hash(_categories),
    const DeepCollectionEquality().hash(_featuredFoods),
    const DeepCollectionEquality().hash(_bestsellers),
    const DeepCollectionEquality().hash(_healthyPicks),
  );

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      __$$HomeDataImplCopyWithImpl<_$HomeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeDataImplToJson(this);
  }
}

abstract class _HomeData implements HomeData {
  const factory _HomeData({
    final List<BannerItem> banners,
    final List<HomeCategory> categories,
    final List<HomeFood> featuredFoods,
    final List<HomeFood> bestsellers,
    final List<HomeFood> healthyPicks,
  }) = _$HomeDataImpl;

  factory _HomeData.fromJson(Map<String, dynamic> json) =
      _$HomeDataImpl.fromJson;

  @override
  List<BannerItem> get banners;
  @override
  List<HomeCategory> get categories;
  @override
  List<HomeFood> get featuredFoods;
  @override
  List<HomeFood> get bestsellers;
  @override
  List<HomeFood> get healthyPicks;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BannerItem _$BannerItemFromJson(Map<String, dynamic> json) {
  return _BannerItem.fromJson(json);
}

/// @nodoc
mixin _$BannerItem {
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get link => throw _privateConstructorUsedError;

  /// Serializes this BannerItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BannerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BannerItemCopyWith<BannerItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BannerItemCopyWith<$Res> {
  factory $BannerItemCopyWith(
    BannerItem value,
    $Res Function(BannerItem) then,
  ) = _$BannerItemCopyWithImpl<$Res, BannerItem>;
  @useResult
  $Res call({String id, String? title, String? imageUrl, String? link});
}

/// @nodoc
class _$BannerItemCopyWithImpl<$Res, $Val extends BannerItem>
    implements $BannerItemCopyWith<$Res> {
  _$BannerItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BannerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? imageUrl = freezed,
    Object? link = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            link: freezed == link
                ? _value.link
                : link // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BannerItemImplCopyWith<$Res>
    implements $BannerItemCopyWith<$Res> {
  factory _$$BannerItemImplCopyWith(
    _$BannerItemImpl value,
    $Res Function(_$BannerItemImpl) then,
  ) = __$$BannerItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String? title, String? imageUrl, String? link});
}

/// @nodoc
class __$$BannerItemImplCopyWithImpl<$Res>
    extends _$BannerItemCopyWithImpl<$Res, _$BannerItemImpl>
    implements _$$BannerItemImplCopyWith<$Res> {
  __$$BannerItemImplCopyWithImpl(
    _$BannerItemImpl _value,
    $Res Function(_$BannerItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BannerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? imageUrl = freezed,
    Object? link = freezed,
  }) {
    return _then(
      _$BannerItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        link: freezed == link
            ? _value.link
            : link // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BannerItemImpl implements _BannerItem {
  const _$BannerItemImpl({
    required this.id,
    this.title,
    this.imageUrl,
    this.link,
  });

  factory _$BannerItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$BannerItemImplFromJson(json);

  @override
  final String id;
  @override
  final String? title;
  @override
  final String? imageUrl;
  @override
  final String? link;

  @override
  String toString() {
    return 'BannerItem(id: $id, title: $title, imageUrl: $imageUrl, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BannerItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.link, link) || other.link == link));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, imageUrl, link);

  /// Create a copy of BannerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BannerItemImplCopyWith<_$BannerItemImpl> get copyWith =>
      __$$BannerItemImplCopyWithImpl<_$BannerItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BannerItemImplToJson(this);
  }
}

abstract class _BannerItem implements BannerItem {
  const factory _BannerItem({
    required final String id,
    final String? title,
    final String? imageUrl,
    final String? link,
  }) = _$BannerItemImpl;

  factory _BannerItem.fromJson(Map<String, dynamic> json) =
      _$BannerItemImpl.fromJson;

  @override
  String get id;
  @override
  String? get title;
  @override
  String? get imageUrl;
  @override
  String? get link;

  /// Create a copy of BannerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BannerItemImplCopyWith<_$BannerItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeCategory _$HomeCategoryFromJson(Map<String, dynamic> json) {
  return _HomeCategory.fromJson(json);
}

/// @nodoc
mixin _$HomeCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get foodCount => throw _privateConstructorUsedError;

  /// Serializes this HomeCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeCategoryCopyWith<HomeCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeCategoryCopyWith<$Res> {
  factory $HomeCategoryCopyWith(
    HomeCategory value,
    $Res Function(HomeCategory) then,
  ) = _$HomeCategoryCopyWithImpl<$Res, HomeCategory>;
  @useResult
  $Res call({
    String id,
    String name,
    String? icon,
    String? imageUrl,
    int foodCount,
  });
}

/// @nodoc
class _$HomeCategoryCopyWithImpl<$Res, $Val extends HomeCategory>
    implements $HomeCategoryCopyWith<$Res> {
  _$HomeCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = freezed,
    Object? imageUrl = freezed,
    Object? foodCount = null,
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
            icon: freezed == icon
                ? _value.icon
                : icon // ignore: cast_nullable_to_non_nullable
                      as String?,
            imageUrl: freezed == imageUrl
                ? _value.imageUrl
                : imageUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            foodCount: null == foodCount
                ? _value.foodCount
                : foodCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeCategoryImplCopyWith<$Res>
    implements $HomeCategoryCopyWith<$Res> {
  factory _$$HomeCategoryImplCopyWith(
    _$HomeCategoryImpl value,
    $Res Function(_$HomeCategoryImpl) then,
  ) = __$$HomeCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? icon,
    String? imageUrl,
    int foodCount,
  });
}

/// @nodoc
class __$$HomeCategoryImplCopyWithImpl<$Res>
    extends _$HomeCategoryCopyWithImpl<$Res, _$HomeCategoryImpl>
    implements _$$HomeCategoryImplCopyWith<$Res> {
  __$$HomeCategoryImplCopyWithImpl(
    _$HomeCategoryImpl _value,
    $Res Function(_$HomeCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = freezed,
    Object? imageUrl = freezed,
    Object? foodCount = null,
  }) {
    return _then(
      _$HomeCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        icon: freezed == icon
            ? _value.icon
            : icon // ignore: cast_nullable_to_non_nullable
                  as String?,
        imageUrl: freezed == imageUrl
            ? _value.imageUrl
            : imageUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        foodCount: null == foodCount
            ? _value.foodCount
            : foodCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeCategoryImpl implements _HomeCategory {
  const _$HomeCategoryImpl({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
    this.foodCount = 0,
  });

  factory _$HomeCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? icon;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int foodCount;

  @override
  String toString() {
    return 'HomeCategory(id: $id, name: $name, icon: $icon, imageUrl: $imageUrl, foodCount: $foodCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.foodCount, foodCount) ||
                other.foodCount == foodCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, icon, imageUrl, foodCount);

  /// Create a copy of HomeCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeCategoryImplCopyWith<_$HomeCategoryImpl> get copyWith =>
      __$$HomeCategoryImplCopyWithImpl<_$HomeCategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeCategoryImplToJson(this);
  }
}

abstract class _HomeCategory implements HomeCategory {
  const factory _HomeCategory({
    required final String id,
    required final String name,
    final String? icon,
    final String? imageUrl,
    final int foodCount,
  }) = _$HomeCategoryImpl;

  factory _HomeCategory.fromJson(Map<String, dynamic> json) =
      _$HomeCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get icon;
  @override
  String? get imageUrl;
  @override
  int get foodCount;

  /// Create a copy of HomeCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeCategoryImplCopyWith<_$HomeCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HomeFood _$HomeFoodFromJson(Map<String, dynamic> json) {
  return _HomeFood.fromJson(json);
}

/// @nodoc
mixin _$HomeFood {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'isVeg')
  bool get isVeg => throw _privateConstructorUsedError;
  @JsonKey(name: 'isBestseller')
  bool get isBestseller => throw _privateConstructorUsedError;

  /// Serializes this HomeFood to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HomeFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeFoodCopyWith<HomeFood> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeFoodCopyWith<$Res> {
  factory $HomeFoodCopyWith(HomeFood value, $Res Function(HomeFood) then) =
      _$HomeFoodCopyWithImpl<$Res, HomeFood>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    @JsonKey(name: 'imageUrls') List<String> imageUrls,
    double? rating,
    @JsonKey(name: 'isVeg') bool isVeg,
    @JsonKey(name: 'isBestseller') bool isBestseller,
  });
}

/// @nodoc
class _$HomeFoodCopyWithImpl<$Res, $Val extends HomeFood>
    implements $HomeFoodCopyWith<$Res> {
  _$HomeFoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeFood
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
    Object? isBestseller = null,
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
            isBestseller: null == isBestseller
                ? _value.isBestseller
                : isBestseller // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomeFoodImplCopyWith<$Res>
    implements $HomeFoodCopyWith<$Res> {
  factory _$$HomeFoodImplCopyWith(
    _$HomeFoodImpl value,
    $Res Function(_$HomeFoodImpl) then,
  ) = __$$HomeFoodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    @JsonKey(name: 'imageUrls') List<String> imageUrls,
    double? rating,
    @JsonKey(name: 'isVeg') bool isVeg,
    @JsonKey(name: 'isBestseller') bool isBestseller,
  });
}

/// @nodoc
class __$$HomeFoodImplCopyWithImpl<$Res>
    extends _$HomeFoodCopyWithImpl<$Res, _$HomeFoodImpl>
    implements _$$HomeFoodImplCopyWith<$Res> {
  __$$HomeFoodImplCopyWithImpl(
    _$HomeFoodImpl _value,
    $Res Function(_$HomeFoodImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomeFood
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
    Object? isBestseller = null,
  }) {
    return _then(
      _$HomeFoodImpl(
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
        isBestseller: null == isBestseller
            ? _value.isBestseller
            : isBestseller // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HomeFoodImpl implements _HomeFood {
  const _$HomeFoodImpl({
    required this.id,
    required this.name,
    required this.price,
    @JsonKey(name: 'imageUrls') final List<String> imageUrls = const [],
    this.rating,
    @JsonKey(name: 'isVeg') this.isVeg = true,
    @JsonKey(name: 'isBestseller') this.isBestseller = false,
  }) : _imageUrls = imageUrls;

  factory _$HomeFoodImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomeFoodImplFromJson(json);

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
  final double? rating;
  @override
  @JsonKey(name: 'isVeg')
  final bool isVeg;
  @override
  @JsonKey(name: 'isBestseller')
  final bool isBestseller;

  @override
  String toString() {
    return 'HomeFood(id: $id, name: $name, price: $price, imageUrls: $imageUrls, rating: $rating, isVeg: $isVeg, isBestseller: $isBestseller)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeFoodImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.isVeg, isVeg) || other.isVeg == isVeg) &&
            (identical(other.isBestseller, isBestseller) ||
                other.isBestseller == isBestseller));
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
    isBestseller,
  );

  /// Create a copy of HomeFood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeFoodImplCopyWith<_$HomeFoodImpl> get copyWith =>
      __$$HomeFoodImplCopyWithImpl<_$HomeFoodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomeFoodImplToJson(this);
  }
}

abstract class _HomeFood implements HomeFood {
  const factory _HomeFood({
    required final String id,
    required final String name,
    required final double price,
    @JsonKey(name: 'imageUrls') final List<String> imageUrls,
    final double? rating,
    @JsonKey(name: 'isVeg') final bool isVeg,
    @JsonKey(name: 'isBestseller') final bool isBestseller,
  }) = _$HomeFoodImpl;

  factory _HomeFood.fromJson(Map<String, dynamic> json) =
      _$HomeFoodImpl.fromJson;

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
  double? get rating;
  @override
  @JsonKey(name: 'isVeg')
  bool get isVeg;
  @override
  @JsonKey(name: 'isBestseller')
  bool get isBestseller;

  /// Create a copy of HomeFood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeFoodImplCopyWith<_$HomeFoodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
