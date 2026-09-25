class Country {
  final String code;
  final String name;
  final String dialCode;
  final String flag;
  final int nationalNumberLength;

  const Country({
    required this.code,
    required this.name,
    required this.dialCode,
    required this.flag,
    required this.nationalNumberLength,
  });

  static const List<Country> supportedCountries = [
    Country(
      code: 'IN',
      name: 'India',
      dialCode: '+91',
      flag: '\u{1F1EE}\u{1F1F3}',
      nationalNumberLength: 10,
    ),
    Country(
      code: 'US',
      name: 'United States',
      dialCode: '+1',
      flag: '\u{1F1FA}\u{1F1F8}',
      nationalNumberLength: 10,
    ),
    Country(
      code: 'GB',
      name: 'United Kingdom',
      dialCode: '+44',
      flag: '\u{1F1EC}\u{1F1E7}',
      nationalNumberLength: 10,
    ),
    Country(
      code: 'AE',
      name: 'UAE',
      dialCode: '+971',
      flag: '\u{1F1E6}\u{1F1EA}',
      nationalNumberLength: 9,
    ),
    Country(
      code: 'SA',
      name: 'Saudi Arabia',
      dialCode: '+966',
      flag: '\u{1F1F8}\u{1F1E6}',
      nationalNumberLength: 9,
    ),
  ];

  static Country get defaultCountry => supportedCountries.first;

  bool get isValidLength =>
      nationalNumberLength > 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
