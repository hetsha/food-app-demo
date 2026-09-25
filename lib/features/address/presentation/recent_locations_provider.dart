import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage.dart';
import '../data/models/recent_location.dart';

const int kMaxRecentLocations = 5;

class RecentLocationsNotifier extends Notifier<List<RecentLocation>> {
  @override
  List<RecentLocation> build() => _load();

  List<RecentLocation> _load() {
    try {
      final json = LocalStorage.recentLocationsJson;
      if (json == null || json.isEmpty) return const [];
      final decoded = jsonDecode(json);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(RecentLocation.fromJson)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _persist() async {
    final json = jsonEncode(state.map((e) => e.toJson()).toList());
    await LocalStorage.setRecentLocationsJson(json);
  }

  Future<void> add(RecentLocation location) async {
    final next = [
      location,
      ...state.where((e) => e != location),
    ].take(kMaxRecentLocations).toList();
    state = next;
    await _persist();
  }

  Future<void> remove(RecentLocation location) async {
    state = state.where((e) => e != location).toList();
    await _persist();
  }

  Future<void> clear() async {
    state = const [];
    await _persist();
  }
}

final recentLocationsProvider =
    NotifierProvider<RecentLocationsNotifier, List<RecentLocation>>(
        RecentLocationsNotifier.new);
