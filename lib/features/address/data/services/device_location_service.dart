import 'package:geolocator/geolocator.dart';

import '../../../../core/storage/local_storage.dart';

enum LocationIssue { serviceDisabled, permissionDenied, permissionDeniedForever, unavailable }

class LocationException implements Exception {
  final String message;
  final LocationIssue issue;

  const LocationException(this.message, this.issue);
}

class DeviceLocationService {
  static Future<bool> isServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (_) {
      return false;
    }
  }

  static Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (_) {
      return LocationPermission.denied;
    }
  }

  static Future<void> ensureServiceEnabled() async {
    if (await isServiceEnabled()) return;
    throw const LocationException(
      'Location services are turned off. Enable them to use your current location.',
      LocationIssue.serviceDisabled,
    );
  }

  static Future<void> ensurePermission() async {
    var permission = await checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException(
        'Location permission denied. Enter the address manually.',
        LocationIssue.permissionDenied,
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission is blocked. Allow it in settings or enter the address manually.',
        LocationIssue.permissionDeniedForever,
      );
    }
  }

  static Future<Position> getCurrentPosition() async {
    try {
      await ensureServiceEnabled();
      await ensurePermission();
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } on LocationException {
      rethrow;
    } catch (_) {
      throw const LocationException(
        'Could not detect your location. Try again or enter the address manually.',
        LocationIssue.unavailable,
      );
    }
  }

  static Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (_) {}
  }

  static Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (_) {}
  }

  static Future<void> runLaunchLocationCheck({
    required Future<bool> Function() showTurnOnLocationDialog,
  }) async {
    try {
      if (LocalStorage.locationPromptShown) return;
      LocalStorage.setLocationPromptShown();

      final serviceOn = await isServiceEnabled();
      if (!serviceOn) {
        final enabled = await showTurnOnLocationDialog();
        if (!enabled || !await isServiceEnabled()) return;
      }

      final permission = await checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    } catch (_) {}
  }
}
