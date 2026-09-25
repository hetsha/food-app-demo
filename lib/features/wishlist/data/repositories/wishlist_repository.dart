import 'package:dio/dio.dart';
import '../models/wishlist_item.dart';

class WishlistRepository {
  final Dio _dio;

  WishlistRepository(this._dio);

  Future<List<WishlistItem>> getWishlist() async {
    final response = await _dio.get('/wishlist');
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => WishlistItem.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<bool> toggleWishlist(String foodItemId) async {
    final response = await _dio.post('/wishlist/$foodItemId');
    return response.data['data']['added'] ?? false;
  }
}
