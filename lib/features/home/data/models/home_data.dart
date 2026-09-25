import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_data.freezed.dart';
part 'home_data.g.dart';

@freezed
class HomeData with _$HomeData {
  const factory HomeData({
    @Default([]) List<BannerItem> banners,
    @Default([]) List<HomeCategory> categories,
    @Default([]) List<HomeFood> featuredFoods,
    @Default([]) List<HomeFood> bestsellers,
    @Default([]) List<HomeFood> healthyPicks,
  }) = _HomeData;

  factory HomeData.fromJson(Map<String, dynamic> json) => _$HomeDataFromJson(json);
}

@freezed
class BannerItem with _$BannerItem {
  const factory BannerItem({
    required String id,
    String? title,
    String? imageUrl,
    String? link,
  }) = _BannerItem;

  factory BannerItem.fromJson(Map<String, dynamic> json) => _$BannerItemFromJson(json);
}

@freezed
class HomeCategory with _$HomeCategory {
  const factory HomeCategory({
    required String id,
    required String name,
    String? icon,
    String? imageUrl,
    @Default(0) int foodCount,
  }) = _HomeCategory;

  factory HomeCategory.fromJson(Map<String, dynamic> json) => _$HomeCategoryFromJson(json);
}

@freezed
class HomeFood with _$HomeFood {
  const factory HomeFood({
    required String id,
    required String name,
    required double price,
    @JsonKey(name: 'imageUrls') @Default([]) List<String> imageUrls,
    double? rating,
    @JsonKey(name: 'isVeg') @Default(true) bool isVeg,
    @JsonKey(name: 'isBestseller') @Default(false) bool isBestseller,
  }) = _HomeFood;

  factory HomeFood.fromJson(Map<String, dynamic> json) => _$HomeFoodFromJson(json);
}
