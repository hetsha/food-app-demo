// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$addressRepositoryHash() => r'137c2abac38afc6673aea5bf155fce193217c3f6';

/// See also [addressRepository].
@ProviderFor(addressRepository)
final addressRepositoryProvider =
    AutoDisposeProvider<AddressRepository>.internal(
      addressRepository,
      name: r'addressRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddressRepositoryRef = AutoDisposeProviderRef<AddressRepository>;
String _$addressNotifierHash() => r'cad466600dac73f9cdb30b9ad57da2fee6ab966f';

/// See also [AddressNotifier].
@ProviderFor(AddressNotifier)
final addressNotifierProvider =
    AutoDisposeNotifierProvider<AddressNotifier, AddressState>.internal(
      AddressNotifier.new,
      name: r'addressNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$addressNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AddressNotifier = AutoDisposeNotifier<AddressState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
