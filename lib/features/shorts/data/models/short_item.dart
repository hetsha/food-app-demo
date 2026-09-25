import 'package:freezed_annotation/freezed_annotation.dart';

part 'short_item.freezed.dart';
part 'short_item.g.dart';

@freezed
class ShortItem with _$ShortItem {
  const factory ShortItem({
    required String id,
    String? title,
    String? description,
    @JsonKey(name: 'video_url') String? videoUrl,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
    @JsonKey(name: 'views_count') @Default(0) int viewsCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
  }) = _ShortItem;

  factory ShortItem.fromJson(Map<String, dynamic> json) => _$ShortItemFromJson(json);
}
