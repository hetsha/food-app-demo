import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/address.dart';
import '../data/repositories/address_repository.dart';
import '../data/repositories/places_repository.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_storage.dart';

part 'address_provider.freezed.dart';
part 'address_provider.g.dart';

@riverpod
AddressRepository addressRepository(Ref ref) {
  return AddressRepository(ApiClient.instance);
}

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  return PlacesRepository(ApiClient.instance);
});

@freezed
class AddressState with _$AddressState {
  const factory AddressState({
    @Default([]) List<Address> addresses,
    @Default(false) bool isLoading,
    String? errorMessage,
    Address? selectedAddress,
  }) = _AddressState;
}

Address? _restorePersistedSelection() {
  try {
    final userId = LocalStorage.getUserId();
    final storedUserId = LocalStorage.selectedAddressUserId;
    final json = LocalStorage.selectedAddressJson;
    if (userId == null || json == null) return null;
    if (storedUserId != null && storedUserId != userId) return null;
    return Address.fromJson(_decodeJson(json));
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> _decodeJson(String json) {
  final decoded = switch (jsonDecode(json)) {
    final Map<String, dynamic> map => map,
    _ => <String, dynamic>{},
  };
  return decoded;
}

String _extractError(Object e) {
  if (e is DioException) {
    final message = e.error;
    if (message is String && message.isNotEmpty) return message;
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic> && error['message'] != null) {
        return error['message'].toString();
      }
      if (data['message'] != null) return data['message'].toString();
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Cannot reach the server. Check your connection and retry.';
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return 'Session expired. Please log in again.';
        }
        return 'The server could not process this request.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
  return 'Something went wrong. Please try again.';
}

@riverpod
class AddressNotifier extends _$AddressNotifier {
  Future<void>? _inFlightLoad;

  @override
  AddressState build() {
    final restored = _restorePersistedSelection();
    return AddressState(selectedAddress: restored);
  }

  Future<void> _persistSelection(Address? address) async {
    try {
      if (address == null) {
        await LocalStorage.clearSelectedAddress();
        return;
      }
      final userId = LocalStorage.getUserId();
      if (userId == null) return;
      await LocalStorage.setSelectedAddress(
        id: address.id,
        json: jsonEncode(address.toJson()),
        userId: userId,
      );
    } catch (_) {}
  }

  Address? _resolveSelection(List<Address> addresses) {
    final current = state.selectedAddress;
    if (current != null) {
      final match = addresses.where((a) => a.id == current.id).firstOrNull;
      if (match != null) return match;
    }
    final persistedId = LocalStorage.selectedAddressId;
    if (persistedId != null) {
      final match = addresses.where((a) => a.id == persistedId).firstOrNull;
      if (match != null) return match;
    }
    return addresses.where((a) => a.isDefault).firstOrNull ??
        addresses.firstOrNull;
  }

  Future<void> loadAddresses() {
    final inFlight = _inFlightLoad;
    if (inFlight != null) return inFlight;
    final future = _performLoad();
    _inFlightLoad = future;
    future.whenComplete(() {
      if (identical(_inFlightLoad, future)) {
        _inFlightLoad = null;
      }
    });
    return future;
  }

  Future<void> _performLoad() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(addressRepositoryProvider);
      final addresses = await repo.getAddresses();
      Address? selected;
      if (addresses.isEmpty) {
        selected = null;
      } else {
        selected = _resolveSelection(addresses);
      }
      state = state.copyWith(
        addresses: addresses,
        isLoading: false,
        selectedAddress: selected,
      );
      await _persistSelection(selected);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _extractError(e));
    }
  }

  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address, errorMessage: null);
    _persistSelection(address);
  }

  Future<Address?> addAddress({
    required String label,
    required String addressLine1,
    String? addressLine2,
    String? city,
    String? addressState,
    required String postalCode,
    required double latitude,
    required double longitude,
    required String phone,
    bool isDefault = false,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(addressRepositoryProvider);
      final address = await repo.createAddress({
        'label': label,
        'addressLine1': addressLine1,
        if (addressLine2 != null) 'addressLine2': addressLine2,
        if (city != null) 'city': city,
        if (addressState != null) 'state': addressState,
        'postalCode': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
        if (isDefault) 'isDefault': true,
      });
      state = state.copyWith(
        addresses: [...state.addresses, address],
        isLoading: false,
        selectedAddress: address,
      );
      await _persistSelection(address);
      return address;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _extractError(e));
      return null;
    }
  }

  Future<void> updateAddress({
    required String id,
    required String label,
    required String addressLine1,
    String? addressLine2,
    String? city,
    String? addressState,
    required String postalCode,
    required double latitude,
    required double longitude,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(addressRepositoryProvider);
      final updated = await repo.updateAddress(id, {
        'label': label,
        'addressLine1': addressLine1,
        if (addressLine2 != null) 'addressLine2': addressLine2,
        if (city != null) 'city': city,
        if (addressState != null) 'state': addressState,
        'postalCode': postalCode,
        'latitude': latitude,
        'longitude': longitude,
        'phone': phone,
      });
      final list = state.addresses.map((a) => a.id == id ? updated : a).toList();
      final selected = state.selectedAddress?.id == id ? updated : state.selectedAddress;
      state = state.copyWith(
        addresses: list,
        isLoading: false,
        selectedAddress: selected,
      );
      if (selected?.id == updated.id) {
        await _persistSelection(updated);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _extractError(e));
    }
  }

  Future<void> deleteAddress(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(addressRepositoryProvider);
      await repo.deleteAddress(id);
      final list = state.addresses.where((a) => a.id != id).toList();
      final wasSelected = state.selectedAddress?.id == id;
      final selected = wasSelected
          ? (list.where((a) => a.isDefault).firstOrNull ?? list.firstOrNull)
          : state.selectedAddress;
      state = state.copyWith(
        addresses: list,
        isLoading: false,
        selectedAddress: selected,
      );
      if (wasSelected) {
        await _persistSelection(selected);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _extractError(e));
    }
  }

  Future<bool> setDefaultAddress(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(addressRepositoryProvider);
      final updated = await repo.updateAddress(id, {'isDefault': true});
      final list = state.addresses
          .map((a) => a.id == id
              ? updated
              : (a.isDefault ? a.copyWith(isDefault: false) : a))
          .toList();
      state = state.copyWith(
        addresses: list,
        isLoading: false,
        selectedAddress: updated,
      );
      await _persistSelection(updated);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: _extractError(e));
      return false;
    }
  }

  void clear() {
    state = const AddressState();
    LocalStorage.clearSelectedAddress();
  }
}
