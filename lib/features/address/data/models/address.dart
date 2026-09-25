import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? 0.0;
  return 0.0;
}

@freezed
class Address with _$Address {
  const Address._();
  const factory Address({
    required String id,
    required String label,
    required String addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    required String postalCode,
    required double latitude,
    required double longitude,
    required String phone,
    @Default(false) bool isDefault,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] as String,
    label: json['label'] as String,
    addressLine1: json['addressLine1'] as String,
    addressLine2: json['addressLine2'] as String?,
    city: json['city'] as String?,
    state: json['state'] as String?,
    postalCode: json['postalCode'] as String,
    latitude: _toDouble(json['latitude']),
    longitude: _toDouble(json['longitude']),
    phone: json['phone'] as String,
    isDefault: json['isDefault'] as bool? ?? false,
  );
}
