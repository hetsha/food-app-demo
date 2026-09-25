// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeDataImpl _$$HomeDataImplFromJson(Map<String, dynamic> json) =>
    _$HomeDataImpl(
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => HomeCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      featuredFoods:
          (json['featuredFoods'] as List<dynamic>?)
              ?.map((e) => HomeFood.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bestsellers:
          (json['bestsellers'] as List<dynamic>?)
              ?.map((e) => HomeFood.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      healthyPicks:
          (json['healthyPicks'] as List<dynamic>?)
              ?.map((e) => HomeFood.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$HomeDataImplToJson(_$HomeDataImpl instance) =>
    <String, dynamic>{
      'banners': instance.banners,
      'categories': instance.categories,
      'featuredFoods': instance.featuredFoods,
      'bestsellers': instance.bestsellers,
      'healthyPicks': instance.healthyPicks,
    };

_$BannerItemImpl _$$BannerItemImplFromJson(Map<String, dynamic> json) =>
    _$BannerItemImpl(
      id: json['id'] as String,
      title: json['title'] as String?,
      imageUrl: json['imageUrl'] as String?,
      link: json['link'] as String?,
    );

Map<String, dynamic> _$$BannerItemImplToJson(_$BannerItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageUrl': instance.imageUrl,
      'link': instance.link,
    };

_$HomeCategoryImpl _$$HomeCategoryImplFromJson(Map<String, dynamic> json) =>
    _$HomeCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
      imageUrl: json['imageUrl'] as String?,
      foodCount: (json['foodCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$HomeCategoryImplToJson(_$HomeCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'imageUrl': instance.imageUrl,
      'foodCount': instance.foodCount,
    };

_$HomeFoodImpl _$$HomeFoodImplFromJson(Map<String, dynamic> json) =>
    _$HomeFoodImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rating: (json['rating'] as num?)?.toDouble(),
      isVeg: json['isVeg'] as bool? ?? true,
      isBestseller: json['isBestseller'] as bool? ?? false,
    );

Map<String, dynamic> _$$HomeFoodImplToJson(_$HomeFoodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'imageUrls': instance.imageUrls,
      'rating': instance.rating,
      'isVeg': instance.isVeg,
      'isBestseller': instance.isBestseller,
    };
