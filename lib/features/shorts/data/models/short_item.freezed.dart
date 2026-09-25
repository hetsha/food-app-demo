// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'short_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShortItem _$ShortItemFromJson(Map<String, dynamic> json) {
  return _ShortItem.fromJson(json);
}

/// @nodoc
mixin _$ShortItem {
  String get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String? get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'likes_count')
  int get likesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'views_count')
  int get viewsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_liked')
  bool get isLiked => throw _privateConstructorUsedError;

  /// Serializes this ShortItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShortItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortItemCopyWith<ShortItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortItemCopyWith<$Res> {
  factory $ShortItemCopyWith(ShortItem value, $Res Function(ShortItem) then) =
      _$ShortItemCopyWithImpl<$Res, ShortItem>;
  @useResult
  $Res call({
    String id,
    String? title,
    String? description,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'likes_count') int likesCount,
    @JsonKey(name: 'views_count') int viewsCount,
    @JsonKey(name: 'is_liked') bool isLiked,
  });
}

/// @nodoc
class _$ShortItemCopyWithImpl<$Res, $Val extends ShortItem>
    implements $ShortItemCopyWith<$Res> {
  _$ShortItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShortItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? likesCount = null,
    Object? viewsCount = null,
    Object? isLiked = null,
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
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            videoUrl: freezed == videoUrl
                ? _value.videoUrl
                : videoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            likesCount: null == likesCount
                ? _value.likesCount
                : likesCount // ignore: cast_nullable_to_non_nullable
                      as int,
            viewsCount: null == viewsCount
                ? _value.viewsCount
                : viewsCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isLiked: null == isLiked
                ? _value.isLiked
                : isLiked // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShortItemImplCopyWith<$Res>
    implements $ShortItemCopyWith<$Res> {
  factory _$$ShortItemImplCopyWith(
    _$ShortItemImpl value,
    $Res Function(_$ShortItemImpl) then,
  ) = __$$ShortItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? title,
    String? description,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'likes_count') int likesCount,
    @JsonKey(name: 'views_count') int viewsCount,
    @JsonKey(name: 'is_liked') bool isLiked,
  });
}

/// @nodoc
class __$$ShortItemImplCopyWithImpl<$Res>
    extends _$ShortItemCopyWithImpl<$Res, _$ShortItemImpl>
    implements _$$ShortItemImplCopyWith<$Res> {
  __$$ShortItemImplCopyWithImpl(
    _$ShortItemImpl _value,
    $Res Function(_$ShortItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShortItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = freezed,
    Object? description = freezed,
    Object? videoUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? likesCount = null,
    Object? viewsCount = null,
    Object? isLiked = null,
  }) {
    return _then(
      _$ShortItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        videoUrl: freezed == videoUrl
            ? _value.videoUrl
            : videoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        likesCount: null == likesCount
            ? _value.likesCount
            : likesCount // ignore: cast_nullable_to_non_nullable
                  as int,
        viewsCount: null == viewsCount
            ? _value.viewsCount
            : viewsCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isLiked: null == isLiked
            ? _value.isLiked
            : isLiked // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShortItemImpl implements _ShortItem {
  const _$ShortItemImpl({
    required this.id,
    this.title,
    this.description,
    @JsonKey(name: 'video_url') this.videoUrl,
    @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
    @JsonKey(name: 'likes_count') this.likesCount = 0,
    @JsonKey(name: 'views_count') this.viewsCount = 0,
    @JsonKey(name: 'is_liked') this.isLiked = false,
  });

  factory _$ShortItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortItemImplFromJson(json);

  @override
  final String id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'video_url')
  final String? videoUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey(name: 'likes_count')
  final int likesCount;
  @override
  @JsonKey(name: 'views_count')
  final int viewsCount;
  @override
  @JsonKey(name: 'is_liked')
  final bool isLiked;

  @override
  String toString() {
    return 'ShortItem(id: $id, title: $title, description: $description, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, likesCount: $likesCount, viewsCount: $viewsCount, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.likesCount, likesCount) ||
                other.likesCount == likesCount) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    videoUrl,
    thumbnailUrl,
    likesCount,
    viewsCount,
    isLiked,
  );

  /// Create a copy of ShortItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortItemImplCopyWith<_$ShortItemImpl> get copyWith =>
      __$$ShortItemImplCopyWithImpl<_$ShortItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortItemImplToJson(this);
  }
}

abstract class _ShortItem implements ShortItem {
  const factory _ShortItem({
    required final String id,
    final String? title,
    final String? description,
    @JsonKey(name: 'video_url') final String? videoUrl,
    @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
    @JsonKey(name: 'likes_count') final int likesCount,
    @JsonKey(name: 'views_count') final int viewsCount,
    @JsonKey(name: 'is_liked') final bool isLiked,
  }) = _$ShortItemImpl;

  factory _ShortItem.fromJson(Map<String, dynamic> json) =
      _$ShortItemImpl.fromJson;

  @override
  String get id;
  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'video_url')
  String? get videoUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  @JsonKey(name: 'likes_count')
  int get likesCount;
  @override
  @JsonKey(name: 'views_count')
  int get viewsCount;
  @override
  @JsonKey(name: 'is_liked')
  bool get isLiked;

  /// Create a copy of ShortItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortItemImplCopyWith<_$ShortItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
