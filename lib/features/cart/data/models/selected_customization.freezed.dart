// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'selected_customization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SelectedCustomization _$SelectedCustomizationFromJson(
  Map<String, dynamic> json,
) {
  return _SelectedCustomization.fromJson(json);
}

/// @nodoc
mixin _$SelectedCustomization {
  @JsonKey(name: 'customization_item_id')
  String get customizationItemId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'additional_price')
  double get additionalPrice => throw _privateConstructorUsedError;

  /// Serializes this SelectedCustomization to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SelectedCustomization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SelectedCustomizationCopyWith<SelectedCustomization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectedCustomizationCopyWith<$Res> {
  factory $SelectedCustomizationCopyWith(
    SelectedCustomization value,
    $Res Function(SelectedCustomization) then,
  ) = _$SelectedCustomizationCopyWithImpl<$Res, SelectedCustomization>;
  @useResult
  $Res call({
    @JsonKey(name: 'customization_item_id') String customizationItemId,
    String name,
    @JsonKey(name: 'additional_price') double additionalPrice,
  });
}

/// @nodoc
class _$SelectedCustomizationCopyWithImpl<
  $Res,
  $Val extends SelectedCustomization
>
    implements $SelectedCustomizationCopyWith<$Res> {
  _$SelectedCustomizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SelectedCustomization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customizationItemId = null,
    Object? name = null,
    Object? additionalPrice = null,
  }) {
    return _then(
      _value.copyWith(
            customizationItemId: null == customizationItemId
                ? _value.customizationItemId
                : customizationItemId // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SelectedCustomizationImplCopyWith<$Res>
    implements $SelectedCustomizationCopyWith<$Res> {
  factory _$$SelectedCustomizationImplCopyWith(
    _$SelectedCustomizationImpl value,
    $Res Function(_$SelectedCustomizationImpl) then,
  ) = __$$SelectedCustomizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'customization_item_id') String customizationItemId,
    String name,
    @JsonKey(name: 'additional_price') double additionalPrice,
  });
}

/// @nodoc
class __$$SelectedCustomizationImplCopyWithImpl<$Res>
    extends
        _$SelectedCustomizationCopyWithImpl<$Res, _$SelectedCustomizationImpl>
    implements _$$SelectedCustomizationImplCopyWith<$Res> {
  __$$SelectedCustomizationImplCopyWithImpl(
    _$SelectedCustomizationImpl _value,
    $Res Function(_$SelectedCustomizationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SelectedCustomization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customizationItemId = null,
    Object? name = null,
    Object? additionalPrice = null,
  }) {
    return _then(
      _$SelectedCustomizationImpl(
        customizationItemId: null == customizationItemId
            ? _value.customizationItemId
            : customizationItemId // ignore: cast_nullable_to_non_nullable
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
class _$SelectedCustomizationImpl implements _SelectedCustomization {
  const _$SelectedCustomizationImpl({
    @JsonKey(name: 'customization_item_id') required this.customizationItemId,
    required this.name,
    @JsonKey(name: 'additional_price') this.additionalPrice = 0.0,
  });

  factory _$SelectedCustomizationImpl.fromJson(Map<String, dynamic> json) =>
      _$$SelectedCustomizationImplFromJson(json);

  @override
  @JsonKey(name: 'customization_item_id')
  final String customizationItemId;
  @override
  final String name;
  @override
  @JsonKey(name: 'additional_price')
  final double additionalPrice;

  @override
  String toString() {
    return 'SelectedCustomization(customizationItemId: $customizationItemId, name: $name, additionalPrice: $additionalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectedCustomizationImpl &&
            (identical(other.customizationItemId, customizationItemId) ||
                other.customizationItemId == customizationItemId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.additionalPrice, additionalPrice) ||
                other.additionalPrice == additionalPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, customizationItemId, name, additionalPrice);

  /// Create a copy of SelectedCustomization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectedCustomizationImplCopyWith<_$SelectedCustomizationImpl>
  get copyWith =>
      __$$SelectedCustomizationImplCopyWithImpl<_$SelectedCustomizationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SelectedCustomizationImplToJson(this);
  }
}

abstract class _SelectedCustomization implements SelectedCustomization {
  const factory _SelectedCustomization({
    @JsonKey(name: 'customization_item_id')
    required final String customizationItemId,
    required final String name,
    @JsonKey(name: 'additional_price') final double additionalPrice,
  }) = _$SelectedCustomizationImpl;

  factory _SelectedCustomization.fromJson(Map<String, dynamic> json) =
      _$SelectedCustomizationImpl.fromJson;

  @override
  @JsonKey(name: 'customization_item_id')
  String get customizationItemId;
  @override
  String get name;
  @override
  @JsonKey(name: 'additional_price')
  double get additionalPrice;

  /// Create a copy of SelectedCustomization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectedCustomizationImplCopyWith<_$SelectedCustomizationImpl>
  get copyWith => throw _privateConstructorUsedError;
}
