class AddressPrefill {
  final double? latitude;
  final double? longitude;
  final String? addressLine1;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? title;
  final bool reverseGeocode;
  final String? cityOrStateHint;

  const AddressPrefill({
    this.latitude,
    this.longitude,
    this.addressLine1,
    this.city,
    this.state,
    this.postalCode,
    this.title,
    this.reverseGeocode = false,
    this.cityOrStateHint,
  });
}
