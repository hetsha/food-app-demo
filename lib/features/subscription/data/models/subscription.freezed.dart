// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserSubscription _$UserSubscriptionFromJson(Map<String, dynamic> json) {
  return _UserSubscription.fromJson(json);
}

/// @nodoc
mixin _$UserSubscription {
  String get id => throw _privateConstructorUsedError;
  String get subscriptionId => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  int get mealsRemaining => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<String> get skipDates => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  SubscriptionPlan? get subscription => throw _privateConstructorUsedError;

  /// Serializes this UserSubscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSubscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSubscriptionCopyWith<UserSubscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSubscriptionCopyWith<$Res> {
  factory $UserSubscriptionCopyWith(
    UserSubscription value,
    $Res Function(UserSubscription) then,
  ) = _$UserSubscriptionCopyWithImpl<$Res, UserSubscription>;
  @useResult
  $Res call({
    String id,
    String subscriptionId,
    DateTime startDate,
    DateTime endDate,
    int mealsRemaining,
    String status,
    List<String> skipDates,
    DateTime createdAt,
    SubscriptionPlan? subscription,
  });
}

/// @nodoc
class _$UserSubscriptionCopyWithImpl<$Res, $Val extends UserSubscription>
    implements $UserSubscriptionCopyWith<$Res> {
  _$UserSubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSubscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subscriptionId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? mealsRemaining = null,
    Object? status = null,
    Object? skipDates = null,
    Object? createdAt = null,
    Object? subscription = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            subscriptionId: null == subscriptionId
                ? _value.subscriptionId
                : subscriptionId // ignore: cast_nullable_to_non_nullable
                      as String,
            startDate: null == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endDate: null == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            mealsRemaining: null == mealsRemaining
                ? _value.mealsRemaining
                : mealsRemaining // ignore: cast_nullable_to_non_nullable
                      as int,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            skipDates: null == skipDates
                ? _value.skipDates
                : skipDates // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            subscription: freezed == subscription
                ? _value.subscription
                : subscription // ignore: cast_nullable_to_non_nullable
                      as SubscriptionPlan?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserSubscriptionImplCopyWith<$Res>
    implements $UserSubscriptionCopyWith<$Res> {
  factory _$$UserSubscriptionImplCopyWith(
    _$UserSubscriptionImpl value,
    $Res Function(_$UserSubscriptionImpl) then,
  ) = __$$UserSubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String subscriptionId,
    DateTime startDate,
    DateTime endDate,
    int mealsRemaining,
    String status,
    List<String> skipDates,
    DateTime createdAt,
    SubscriptionPlan? subscription,
  });
}

/// @nodoc
class __$$UserSubscriptionImplCopyWithImpl<$Res>
    extends _$UserSubscriptionCopyWithImpl<$Res, _$UserSubscriptionImpl>
    implements _$$UserSubscriptionImplCopyWith<$Res> {
  __$$UserSubscriptionImplCopyWithImpl(
    _$UserSubscriptionImpl _value,
    $Res Function(_$UserSubscriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserSubscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? subscriptionId = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? mealsRemaining = null,
    Object? status = null,
    Object? skipDates = null,
    Object? createdAt = null,
    Object? subscription = freezed,
  }) {
    return _then(
      _$UserSubscriptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        subscriptionId: null == subscriptionId
            ? _value.subscriptionId
            : subscriptionId // ignore: cast_nullable_to_non_nullable
                  as String,
        startDate: null == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endDate: null == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        mealsRemaining: null == mealsRemaining
            ? _value.mealsRemaining
            : mealsRemaining // ignore: cast_nullable_to_non_nullable
                  as int,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        skipDates: null == skipDates
            ? _value._skipDates
            : skipDates // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        subscription: freezed == subscription
            ? _value.subscription
            : subscription // ignore: cast_nullable_to_non_nullable
                  as SubscriptionPlan?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSubscriptionImpl implements _UserSubscription {
  const _$UserSubscriptionImpl({
    required this.id,
    required this.subscriptionId,
    required this.startDate,
    required this.endDate,
    this.mealsRemaining = 0,
    required this.status,
    final List<String> skipDates = const [],
    required this.createdAt,
    this.subscription,
  }) : _skipDates = skipDates;

  factory _$UserSubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSubscriptionImplFromJson(json);

  @override
  final String id;
  @override
  final String subscriptionId;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey()
  final int mealsRemaining;
  @override
  final String status;
  final List<String> _skipDates;
  @override
  @JsonKey()
  List<String> get skipDates {
    if (_skipDates is EqualUnmodifiableListView) return _skipDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skipDates);
  }

  @override
  final DateTime createdAt;
  @override
  final SubscriptionPlan? subscription;

  @override
  String toString() {
    return 'UserSubscription(id: $id, subscriptionId: $subscriptionId, startDate: $startDate, endDate: $endDate, mealsRemaining: $mealsRemaining, status: $status, skipDates: $skipDates, createdAt: $createdAt, subscription: $subscription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSubscriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subscriptionId, subscriptionId) ||
                other.subscriptionId == subscriptionId) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.mealsRemaining, mealsRemaining) ||
                other.mealsRemaining == mealsRemaining) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._skipDates,
              _skipDates,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.subscription, subscription) ||
                other.subscription == subscription));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subscriptionId,
    startDate,
    endDate,
    mealsRemaining,
    status,
    const DeepCollectionEquality().hash(_skipDates),
    createdAt,
    subscription,
  );

  /// Create a copy of UserSubscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSubscriptionImplCopyWith<_$UserSubscriptionImpl> get copyWith =>
      __$$UserSubscriptionImplCopyWithImpl<_$UserSubscriptionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSubscriptionImplToJson(this);
  }
}

abstract class _UserSubscription implements UserSubscription {
  const factory _UserSubscription({
    required final String id,
    required final String subscriptionId,
    required final DateTime startDate,
    required final DateTime endDate,
    final int mealsRemaining,
    required final String status,
    final List<String> skipDates,
    required final DateTime createdAt,
    final SubscriptionPlan? subscription,
  }) = _$UserSubscriptionImpl;

  factory _UserSubscription.fromJson(Map<String, dynamic> json) =
      _$UserSubscriptionImpl.fromJson;

  @override
  String get id;
  @override
  String get subscriptionId;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  int get mealsRemaining;
  @override
  String get status;
  @override
  List<String> get skipDates;
  @override
  DateTime get createdAt;
  @override
  SubscriptionPlan? get subscription;

  /// Create a copy of UserSubscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSubscriptionImplCopyWith<_$UserSubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
