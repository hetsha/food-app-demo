import 'package:dio/dio.dart';
import '../models/menu_food.dart';
import '../models/menu_category.dart';

class MenuRepository {
  final Dio _dio;

  MenuRepository(this._dio);

  Future<List<MenuFood>> getFoods({
    String? categoryId,
    String? search,
    bool? isVeg,
    bool? isBestseller,
    int take = 200,
  }) async {
    final response = await _dio.get('/foods', queryParameters: {
      if (categoryId != null) 'categoryId': categoryId,
      if (search != null && search.isNotEmpty) 'search': search,
      if (isVeg != null) 'isVeg': isVeg,
      if (isBestseller != null) 'isBestseller': isBestseller,
      'take': take,
    });
    final data = response.data['data'];
    if (data is List) return data.map((e) => MenuFood.fromJson(e)).toList();
    return [];
  }

  Future<MenuFood> getFood(String id) async {
    final response = await _dio.get('/foods/$id');
    return MenuFood.fromJson(response.data['data']);
  }

  Future<List<MenuCategory>> getCategories() async {
    final response = await _dio.get('/categories');
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => MenuCategory.fromJson(e)).toList();
    }
    return [];
  }
}
