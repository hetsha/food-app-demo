import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/short_item.dart';

class ShortsRepository {
  final Dio _dio;

  ShortsRepository(this._dio);

  Future<List<ShortItem>> getShorts() async {
    final response = await _dio.get(ApiConstants.shorts);
    final data = response.data['data'];
    final list = data is List ? data : data['shorts'] ?? [];
    return (list as List).map((e) => ShortItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> likeShort(String id) async {
    await _dio.post('${ApiConstants.shorts}/$id/like');
  }

  Future<void> viewShort(String id) async {
    await _dio.post('${ApiConstants.shorts}/$id/view');
  }
}
