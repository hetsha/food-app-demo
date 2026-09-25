import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/searchable_options_sheet.dart';
import '../../../core/storage/local_storage.dart';
import '../data/models/india_locations.dart';
import '../data/services/device_location_service.dart';
import 'address_actions.dart';
import 'address_prefill.dart';
import 'address_provider.dart';

class AddressFormScreen extends ConsumerStatefulWidget {
  final String? addressId;
  final AddressPrefill? prefill;

  const AddressFormScreen({super.key, this.addressId, this.prefill});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customLabelController;
  late TextEditingController _line1Controller;
  late TextEditingController _line2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneController;
  String _selectedLabel = 'Home';
  bool _isEditing = false;
  bool _isDetectingLocation = false;
  bool _isSaving = false;
  bool _attemptedSave = false;
  double? _latitude;
  double? _longitude;

  static const List<String> _labels = ['Home', 'Office', 'Other'];

  @override
  void initState() {
    super.initState();
    _customLabelController = TextEditingController();
    _line1Controller = TextEditingController();
    _line2Controller = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _postalCodeController = TextEditingController();
    _phoneController = TextEditingController();

    if (widget.addressId != null) {
      _isEditing = true;
      final addrs = ref.read(addressNotifierProvider).addresses;
      final existing = addrs.where((a) => a.id == widget.addressId).firstOrNull;
      if (existing != null) {
        if (_labels.contains(existing.label)) {
          _selectedLabel = existing.label;
        } else {
          _selectedLabel = 'Other';
          _customLabelController.text = existing.label;
        }
        _line1Controller.text = existing.addressLine1;
        _line2Controller.text = existing.addressLine2 ?? '';
        _cityController.text = existing.city ?? '';
        _stateController.text = existing.state ?? '';
        _postalCodeController.text = existing.postalCode;
        _phoneController.text = existing.phone;
        _latitude = existing.latitude;
        _longitude = existing.longitude;
      } else {
        _isEditing = false;
      }
    }

    final prefill = widget.prefill;
    if (prefill != null && !_isEditing) {
      _latitude = prefill.latitude ?? _latitude;
      _longitude = prefill.longitude ?? _longitude;
      if (prefill.addressLine1 != null &&
          prefill.addressLine1!.trim().isNotEmpty &&
          _line1Controller.text.trim().isEmpty) {
        _line1Controller.text = prefill.addressLine1!.trim();
      }
      if (prefill.city != null &&
          prefill.city!.trim().isNotEmpty &&
          _cityController.text.trim().isEmpty) {
        _cityController.text = prefill.city!.trim();
      }
      if (prefill.state != null &&
          prefill.state!.trim().isNotEmpty &&
          _stateController.text.trim().isEmpty) {
        final matched = IndiaLocations.matchState(prefill.state!.trim());
        _stateController.text = matched ?? prefill.state!.trim();
      }
      if (prefill.postalCode != null &&
          prefill.postalCode!.trim().isNotEmpty &&
          _postalCodeController.text.trim().isEmpty) {
        _postalCodeController.text = prefill.postalCode!.trim();
      }
      if (_phoneController.text.trim().isEmpty) {
        _phoneController.text = LocalStorage.getPhoneNumber() ?? '';
      }
      if (prefill.reverseGeocode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _geocodePrefill(prefill);
        });
      }
    } else if (!_isEditing && _phoneController.text.trim().isEmpty) {
      _phoneController.text = LocalStorage.getPhoneNumber() ?? '';
    }
  }

  @override
  void dispose() {
    _customLabelController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _resolvedLabel {
    if (_selectedLabel == 'Other') {
      return _customLabelController.text.trim();
    }
    return _selectedLabel;
  }

  Future<void> _geocodePrefill(AddressPrefill prefill) async {
    if (prefill.latitude == null || prefill.longitude == null) return;
    try {
      final places = ref.read(placesRepositoryProvider);
      final geocoded = await places.reverseGeocode(
        latitude: prefill.latitude!,
        longitude: prefill.longitude!,
      );
      if (!mounted || geocoded == null) return;

      if (geocoded.address != null && geocoded.address!.isNotEmpty) {
        _line1Controller.text = geocoded.address!;
      }
      final returnedState = geocoded.state?.trim() ?? '';
      if (returnedState.isNotEmpty && _stateController.text.trim().isEmpty) {
        _stateController.text =
            IndiaLocations.matchState(returnedState) ?? returnedState;
      }
      final returnedCity = geocoded.city?.trim() ?? '';
      if (returnedCity.isNotEmpty && _cityController.text.trim().isEmpty) {
        final selectedState = _stateController.text.trim();
        final matchedCity =
            IndiaLocations.matchCity(selectedState, returnedCity);
        if (matchedCity != null) {
          _cityController.text = matchedCity;
        } else {
          _cityController.text = returnedCity;
        }
      }
      if (geocoded.postalCode != null &&
          geocoded.postalCode!.isNotEmpty &&
          _postalCodeController.text.trim().isEmpty) {
        _postalCodeController.text = geocoded.postalCode!;
      }
      setState(() {});
    } catch (_) {
      // Prefill is best-effort; user can fill fields manually.
    }
  }

  Future<void> _useCurrentLocation() async {
    if (_isDetectingLocation) return;
    setState(() => _isDetectingLocation = true);
    var fieldsPopulated = false;
    try {
      final position = await DeviceLocationService.getCurrentPosition();
      _latitude = position.latitude;
      _longitude = position.longitude;

      final places = ref.read(placesRepositoryProvider);
      final geocoded = await places.reverseGeocode(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (geocoded != null) {
        if (_line1Controller.text.trim().isEmpty &&
            geocoded.address != null &&
            geocoded.address!.isNotEmpty) {
          _line1Controller.text = geocoded.address!;
          fieldsPopulated = true;
        }

        final returnedState = geocoded.state?.trim() ?? '';
        final stateWasEmpty = _stateController.text.trim().isEmpty;
        if (stateWasEmpty && returnedState.isNotEmpty) {
          _stateController.text =
              IndiaLocations.matchState(returnedState) ?? returnedState;
          fieldsPopulated = true;
        }

        final returnedCity = geocoded.city?.trim() ?? '';
        if (_cityController.text.trim().isEmpty &&
            returnedCity.isNotEmpty) {
          final selectedState = _stateController.text.trim();
          final matchedCity =
              IndiaLocations.matchCity(selectedState, returnedCity);
          if (matchedCity != null) {
            _cityController.text = matchedCity;
            fieldsPopulated = true;
          } else if (stateWasEmpty) {
            // City came from the same geocode as the state we just set —
            // show it as-is rather than inventing a city.
            _cityController.text = returnedCity;
            fieldsPopulated = true;
          } else if (IndiaLocations.findStateForCity(returnedCity) == null) {
            // City is not in the dataset at all — show the returned value
            // and let the customer correct it manually.
            _cityController.text = returnedCity;
            fieldsPopulated = true;
          }
          // Otherwise the city belongs to a different state than the one
          // the customer selected — leave it empty so they pick a valid one.
        }

        if (_postalCodeController.text.trim().isEmpty &&
            geocoded.postalCode != null) {
          _postalCodeController.text = geocoded.postalCode!;
          fieldsPopulated = true;
        }
      }

      if (mounted) {
        if (fieldsPopulated) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location detected. Review the details and save.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        setState(() {});
      }
    } on LocationException catch (e) {
      if (!mounted) return;
      await handleLocationException(context, e);
    } finally {
      if (mounted) setState(() => _isDetectingLocation = false);
    }
  }

  String? _selectedOrNull(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _pickState() async {
    final picked = await SearchableOptionsSheet.show(
      context,
      title: 'Select State',
      options: IndiaLocations.states,
      selected: _selectedOrNull(_stateController),
      searchHint: 'Search state...',
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (_stateController.text.trim() != picked) {
        _stateController.text = picked;
        // State changed — drop any city that belonged to the previous state.
        _cityController.text = '';
      }
    });
    if (_attemptedSave) _formKey.currentState?.validate();
  }

  Future<void> _pickCity() async {
    final state = _stateController.text.trim();
    if (state.isEmpty && _cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a state first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final picked = await SearchableOptionsSheet.show(
      context,
      title: 'Select City',
      options: IndiaLocations.citiesFor(state),
      selected: _selectedOrNull(_cityController),
      searchHint: 'Search city...',
    );
    if (picked == null || !mounted) return;
    setState(() => _cityController.text = picked);
    if (_attemptedSave) _formKey.currentState?.validate();
  }

  Future<void> _resolveCoordinates(String fullAddress) async {
    if (_latitude != null && _longitude != null) return;
    try {
      final places = ref.read(placesRepositoryProvider);
      final results = await places.searchPlaces(fullAddress);
      if (results.isNotEmpty) {
        _latitude = results.first.latitude;
        _longitude = results.first.longitude;
        return;
      }
    } on DioException {
      // fallback below
    }
    _latitude = 23.0225;
    _longitude = 72.5714;
  }

  Future<void> _save() async {
    _attemptedSave = true;
    if (!_formKey.currentState!.validate()) return;

    final label = _resolvedLabel;
    if (label.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a label for this address')),
      );
      return;
    }

    final line1 = _line1Controller.text.trim();
    final line2 = _line2Controller.text.trim();
    final city = _cityController.text.trim();
    final addressState = _stateController.text.trim();
    final postalCode = _postalCodeController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() => _isSaving = true);

    if (!_isEditing) {
      final fullAddress =
          [line1, line2, city, postalCode].where((p) => p.isNotEmpty).join(' ');
      await _resolveCoordinates(fullAddress);
    }

    final notifier = ref.read(addressNotifierProvider.notifier);

    if (_isEditing) {
      final existing =
          ref.read(addressNotifierProvider).addresses
              .where((a) => a.id == widget.addressId)
              .firstOrNull;
      await notifier.updateAddress(
        id: widget.addressId!,
        label: label,
        addressLine1: line1,
        addressLine2: line2.isNotEmpty ? line2 : null,
        city: city.isNotEmpty ? city : null,
        addressState: addressState.isNotEmpty ? addressState : null,
        postalCode: postalCode,
        latitude: _latitude ?? existing?.latitude ?? 23.0225,
        longitude: _longitude ?? existing?.longitude ?? 72.5714,
        phone: phone,
      );
    } else {
      await notifier.addAddress(
        label: label,
        addressLine1: line1,
        addressLine2: line2.isNotEmpty ? line2 : null,
        city: city.isNotEmpty ? city : null,
        addressState: addressState.isNotEmpty ? addressState : null,
        postalCode: postalCode,
        latitude: _latitude ?? 23.0225,
        longitude: _longitude ?? 72.5714,
        phone: phone,
      );
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    final error = ref.read(addressNotifierProvider).errorMessage;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressNotifierProvider);
    final busy = addressState.isLoading || _isSaving;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Address' : 'Add Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Label',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.s8),
              Wrap(
                spacing: AppSpacing.s8,
                children: _labels.map((label) {
                  final isSelected = _selectedLabel == label;
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedLabel = label),
                    selectedColor: Theme.of(context).colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              if (_selectedLabel == 'Other') ...[
                const SizedBox(height: AppSpacing.s12),
                TextFormField(
                  controller: _customLabelController,
                  decoration:
                      const InputDecoration(hintText: 'Enter label (e.g., Gym)'),
                  validator: (v) =>
                      _selectedLabel == 'Other' &&
                              (v == null || v.trim().isEmpty)
                          ? 'Required'
                          : null,
                ),
              ],
              const SizedBox(height: AppSpacing.s24),
              OutlinedButton.icon(
                onPressed: _isDetectingLocation || busy
                    ? null
                    : _useCurrentLocation,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s12),
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                icon: _isDetectingLocation
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location_rounded, size: 18),
                label: Text(
                  _isDetectingLocation
                      ? 'Detecting location...'
                      : 'Use current location',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (_latitude != null && _longitude != null) ...[
                const SizedBox(height: AppSpacing.s8),
                const Text(
                  'Location captured — you can fine-tune the address below.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
              const SizedBox(height: AppSpacing.s24),
              TextFormField(
                controller: _line1Controller,
                decoration: const InputDecoration(
                    hintText: 'Address Line 1 (Flat, House No.)'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _line2Controller,
                decoration: const InputDecoration(
                    hintText: 'Address Line 2 (Area, Landmark)'),
              ),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: 'Postal Code',
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || !RegExp(r'^[1-9][0-9]{5}$').hasMatch(v)
                        ? 'Enter valid 6-digit postal code'
                        : null,
              ),
              const SizedBox(height: AppSpacing.s16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      readOnly: true,
                      onTap: _pickCity,
                      decoration: const InputDecoration(
                        hintText: 'City',
                        suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Please select a city'
                          : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      readOnly: true,
                      onTap: _pickState,
                      decoration: const InputDecoration(
                        hintText: 'State',
                        suffixIcon: Icon(Icons.arrow_drop_down_rounded),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Please select a state'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                  prefixText: '+91 ',
                  counterText: '',
                ),
                validator: (v) =>
                    v == null || v.length < 10 ? 'Enter valid phone' : null,
              ),
              const SizedBox(height: AppSpacing.s32),
              ElevatedButton(
                onPressed: busy ? null : _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                ),
                child: busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _isEditing ? 'Update Address' : 'Save Address',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
