import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/models/menu_food.dart';
import '../data/repositories/menu_repository.dart';
import 'menu_providers.dart';

class SearchState {
  final String query;
  final List<MenuFood> results;
  final bool isLoading;
  final bool isVegOnly;
  final String? error;

  SearchState({
    this.query = '',
    this.results = const [],
    this.isLoading = false,
    this.isVegOnly = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<MenuFood>? results,
    bool? isLoading,
    bool? isVegOnly,
    String? error,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      isVegOnly: isVegOnly ?? this.isVegOnly,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final MenuRepository _repo;
  Timer? _debounce;
  int _requestSeq = 0;

  SearchNotifier(this._repo) : super(SearchState());

  /// Debounced typing input. Trims the query; an empty/whitespace query
  /// reloads the complete menu.
  void updateQuery(String raw) {
    final query = raw.trim();
    state = state.copyWith(query: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _search(query);
    });
  }

  /// Keyboard submit: cancel debounce and search immediately.
  void submitQuery(String raw) {
    final query = raw.trim();
    state = state.copyWith(query: query);
    _debounce?.cancel();
    _search(query);
  }

  void toggleVegOnly() {
    state = state.copyWith(isVegOnly: !state.isVegOnly);
    _debounce?.cancel();
    _search(state.query);
  }

  Future<void> _search(String query) async {
    // Discard any in-flight response from a previous query.
    final seq = ++_requestSeq;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final results = await _repo.getFoods(
        search: query.isNotEmpty ? query : null,
        isVeg: state.isVegOnly ? true : null,
      );
      if (seq != _requestSeq) return; // stale response — drop it
      state = state.copyWith(results: results, isLoading: false);
    } on DioException catch (e) {
      if (seq != _requestSeq) return;
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['error']?['message'] ?? 'Search failed',
      );
    } catch (_) {
      if (seq != _requestSeq) return;
      state = state.copyWith(isLoading: false, error: 'Search failed');
    }
  }

  void clear() {
    _debounce?.cancel();
    _requestSeq++; // invalidate in-flight requests
    state = SearchState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repo = ref.read(menuRepositoryProvider);
  return SearchNotifier(repo);
});
