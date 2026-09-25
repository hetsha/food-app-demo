import 'package:dio/dio.dart';
import '../models/home_data.dart';

class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  Future<List<BannerItem>> getBanners() async {
    final response = await _dio.get('/banners');
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => BannerItem.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<HomeCategory>> getCategories() async {
    final response = await _dio.get('/categories');
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => HomeCategory.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<List<HomeFood>> getFoods({
    String? categoryId,
    bool? isBestseller,
    bool? isVeg,
    bool? isHealthyPick,
    int? limit,
  }) async {
    final response = await _dio.get('/foods', queryParameters: {
      if (categoryId != null) 'categoryId': categoryId,
      if (isBestseller != null) 'isBestseller': isBestseller,
      if (isVeg != null) 'isVeg': isVeg,
      if (isHealthyPick != null) 'isHealthyPick': isHealthyPick,
      if (limit != null) 'take': limit,
    });
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => HomeFood.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }
}
