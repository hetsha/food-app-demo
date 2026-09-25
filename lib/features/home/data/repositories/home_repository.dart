import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/home_data.dart';

class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  Future<List<BannerItem>> getBanners({int timeoutSeconds = 8, int maxRetries = 1}) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        if (kDebugMode) debugPrint('[HomeRepo] banners attempt ${attempt + 1}');
        final response = await _dio.get('/banners', options: Options(receiveTimeout: Duration(seconds: timeoutSeconds)));
        final data = response.data['data'];
        if (data is List) {
          return data.map((e) => BannerItem.fromJson(e as Map<String, dynamic>)).toList();
        }
        if (kDebugMode) debugPrint('[HomeRepo] banners: data is not a List');
        return [];
      } on DioException catch (e) {
        if (kDebugMode) debugPrint('[HomeRepo] banners DioException: ${e.type}, status: ${e.response?.statusCode}');
        if (attempt < maxRetries) {
          if (kDebugMode) debugPrint('[HomeRepo] banners retrying...');
          continue;
        }
        if (kDebugMode) debugPrint('[HomeRepo] banners retries exhausted');
        return [];
      } catch (e) {
        if (kDebugMode) debugPrint('[HomeRepo] banners error: $e');
        return [];
      }
    }
    return [];
  }

  Future<List<HomeCategory>> getCategories({int timeoutSeconds = 8, int maxRetries = 1}) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        if (kDebugMode) debugPrint('[HomeRepo] categories attempt ${attempt + 1}');
        final response = await _dio.get('/categories', options: Options(receiveTimeout: Duration(seconds: timeoutSeconds)));
        final data = response.data['data'];
        if (data is List) {
          return data.map((e) => HomeCategory.fromJson(e as Map<String, dynamic>)).toList();
        }
        if (kDebugMode) debugPrint('[HomeRepo] categories: data is not a List');
        return [];
      } on DioException catch (e) {
        if (kDebugMode) debugPrint('[HomeRepo] categories DioException: ${e.type}, status: ${e.response?.statusCode}');
        if (attempt < maxRetries) {
          if (kDebugMode) debugPrint('[HomeRepo] categories retrying...');
          continue;
        }
        if (kDebugMode) debugPrint('[HomeRepo] categories retries exhausted');
        return [];
      } catch (e) {
        if (kDebugMode) debugPrint('[HomeRepo] categories error: $e');
        return [];
      }
    }
    return [];
  }

  Future<List<HomeFood>> getFoods({
    String? categoryId,
    bool? isBestseller,
    bool? isVeg,
    bool? isHealthyPick,
    int? limit,
    int timeoutSeconds = 8,
    int maxRetries = 1,
  }) async {
    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        if (kDebugMode) debugPrint('[HomeRepo] foods attempt ${attempt + 1}');
        final response = await _dio.get('/foods',
          queryParameters: {
            if (categoryId != null) 'categoryId': categoryId,
            if (isBestseller != null) 'isBestseller': isBestseller,
            if (isVeg != null) 'isVeg': isVeg,
            if (isHealthyPick != null) 'isHealthyPick': isHealthyPick,
            if (limit != null) 'take': limit,
          },
          options: Options(receiveTimeout: Duration(seconds: timeoutSeconds)),
        );
        final data = response.data['data'];
        if (data is List) {
          return data.map((e) => HomeFood.fromJson(e as Map<String, dynamic>)).toList();
        }
        if (kDebugMode) debugPrint('[HomeRepo] foods: data is not a List');
        return [];
      } on DioException catch (e) {
        if (kDebugMode) debugPrint('[HomeRepo] foods DioException: ${e.type}, status: ${e.response?.statusCode}');
        if (attempt < maxRetries) {
          if (kDebugMode) debugPrint('[HomeRepo] foods retrying...');
          continue;
        }
        if (kDebugMode) debugPrint('[HomeRepo] foods retries exhausted');
        return [];
      } catch (e) {
        if (kDebugMode) debugPrint('[HomeRepo] foods error: $e');
        return [];
      }
    }
    return [];
  }
}
