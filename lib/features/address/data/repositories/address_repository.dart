import 'package:dio/dio.dart';

import '../models/address.dart';

class AddressRepository {
  final Dio _dio;

  AddressRepository(this._dio);

  Future<List<Address>> getAddresses() async {
    final response = await _dio.get('/addresses');
    final data = response.data['data'];
    if (data is List) {
      return data.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<Address> createAddress(Map<String, dynamic> data) async {
    final response = await _dio.post('/addresses', data: data);
    return Address.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<Address> updateAddress(String id, Map<String, dynamic> data) async {
    final response = await _dio.patch('/addresses/$id', data: data);
    return Address.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteAddress(String id) async {
    await _dio.delete('/addresses/$id');
  }
}
