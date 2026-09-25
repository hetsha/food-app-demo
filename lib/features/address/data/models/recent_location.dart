class RecentLocation {
  final String title;
  final String address;
  final double? latitude;
  final double? longitude;

  const RecentLocation({
    required this.title,
    required this.address,
    this.latitude,
    this.longitude,
  });

  factory RecentLocation.fromJson(Map<String, dynamic> json) {
    return RecentLocation(
      title: json['title'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentLocation &&
          other.title == title &&
          other.address == address &&
          other.latitude == latitude &&
          other.longitude == longitude;

  @override
  int get hashCode =>
      Object.hash(title, address, latitude, longitude);
}
