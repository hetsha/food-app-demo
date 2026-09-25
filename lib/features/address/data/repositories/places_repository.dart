import 'package:dio/dio.dart';

class PlaceResult {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  const PlaceResult({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory PlaceResult.fromJson(Map<String, dynamic> json) => PlaceResult(
        name: json['name'] as String? ?? '',
        address: json['address'] as String? ?? '',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      );
}

class ReverseGeocodeResult {
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;

  const ReverseGeocodeResult({
    this.address,
    this.city,
    this.state,
    this.postalCode,
  });
}

class PlacesRepository {
  final Dio _dio;

  PlacesRepository(this._dio);

  Future<List<PlaceResult>> searchPlaces(String query) async {
    final response = await _dio.get('/places/search', queryParameters: {
      'query': query,
    });
    final data = response.data['data'];
    if (data is Map<String, dynamic> && data['places'] is List) {
      return (data['places'] as List)
          .whereType<Map<String, dynamic>>()
          .map(PlaceResult.fromJson)
          .toList();
    }
    return [];
  }

  Future<ReverseGeocodeResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get('/places/reverse-geocode', queryParameters: {
        'lat': latitude,
        'lng': longitude,
      });
      final data = response.data['data'];
      if (data is Map<String, dynamic> && data['address'] != null) {
        return ReverseGeocodeResult(
          address: data['address'] as String?,
          city: data['city'] as String?,
          state: data['state'] as String?,
          postalCode: (data['postalCode'] as String?)?.isNotEmpty == true
              ? data['postalCode'] as String
              : null,
        );
      }
      return null;
    } on DioException {
      return null;
    }
  }
}
