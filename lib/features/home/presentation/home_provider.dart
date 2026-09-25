import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/models/home_data.dart';
import '../data/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ApiClient.instance);
});

class HomeState {
  final bool isLoading;
  final String? errorMessage;
  final List<BannerItem> banners;
  final List<HomeCategory> categories;
  final List<HomeFood> bestsellers;
  final List<HomeFood> healthyPicks;
  final bool bannersError;
  final bool categoriesError;
  final bool bestsellersError;
  final bool healthyPicksError;
  final bool bannersLoading;
  final bool categoriesLoading;
  final bool bestsellersLoading;
  final bool healthyPicksLoading;

  HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.banners = const [],
    this.categories = const [],
    this.bestsellers = const [],
    this.healthyPicks = const [],
    this.bannersError = false,
    this.categoriesError = false,
    this.bestsellersError = false,
    this.healthyPicksError = false,
    this.bannersLoading = false,
    this.categoriesLoading = false,
    this.bestsellersLoading = false,
    this.healthyPicksLoading = false,
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BannerItem>? banners,
    List<HomeCategory>? categories,
    List<HomeFood>? bestsellers,
    List<HomeFood>? healthyPicks,
    bool? bannersError,
    bool? categoriesError,
    bool? bestsellersError,
    bool? healthyPicksError,
    bool? bannersLoading,
    bool? categoriesLoading,
    bool? bestsellersLoading,
    bool? healthyPicksLoading,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      bestsellers: bestsellers ?? this.bestsellers,
      healthyPicks: healthyPicks ?? this.healthyPicks,
      bannersError: bannersError ?? this.bannersError,
      categoriesError: categoriesError ?? this.categoriesError,
      bestsellersError: bestsellersError ?? this.bestsellersError,
      healthyPicksError: healthyPicksError ?? this.healthyPicksError,
      bannersLoading: bannersLoading ?? this.bannersLoading,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      bestsellersLoading: bestsellersLoading ?? this.bestsellersLoading,
      healthyPicksLoading: healthyPicksLoading ?? this.healthyPicksLoading,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repo;

  HomeNotifier(this._repo) : super(HomeState()) {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await _loadSection(
      () => _repo.getBanners(),
      setLoading: () => state.copyWith(bannersLoading: true),
      setData: (List<dynamic> data) => state.copyWith(banners: data.cast<BannerItem>(), bannersLoading: false, bannersError: false),
      setError: () => state.copyWith(bannersLoading: false, bannersError: true),
    );
    await _loadSection(
      () => _repo.getCategories(),
      setLoading: () => state.copyWith(categoriesLoading: true),
      setData: (List<dynamic> data) => state.copyWith(categories: data.cast<HomeCategory>(), categoriesLoading: false, categoriesError: false),
      setError: () => state.copyWith(categoriesLoading: false, categoriesError: true),
    );
    await _loadSection(
      () => _repo.getFoods(isBestseller: true, limit: 10),
      setLoading: () => state.copyWith(bestsellersLoading: true),
      setData: (List<dynamic> data) => state.copyWith(bestsellers: data.cast<HomeFood>(), bestsellersLoading: false, bestsellersError: false),
      setError: () => state.copyWith(bestsellersLoading: false, bestsellersError: true),
    );
    await _loadSection(
      () => _repo.getFoods(isHealthyPick: true, limit: 10),
      setLoading: () => state.copyWith(healthyPicksLoading: true),
      setData: (List<dynamic> data) => state.copyWith(healthyPicks: data.cast<HomeFood>(), healthyPicksLoading: false, healthyPicksError: false),
      setError: () => state.copyWith(healthyPicksLoading: false, healthyPicksError: true),
    );
    state = state.copyWith(isLoading: false);
  }

  Future<void> _loadSection(
    Future<List<dynamic>> Function() request, {
    required HomeState Function() setLoading,
    required HomeState Function(List<dynamic> data) setData,
    required HomeState Function() setError,
  }) async {
    state = setLoading();
    if (kDebugMode) debugPrint('[HomeNotifier] loading section');
    try {
      final data = await request();
      state = setData(data);
    } catch (e) {
      if (kDebugMode) debugPrint('[HomeNotifier] section error: $e');
      state = setError();
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      isLoading: true,
      bannersLoading: true,
      categoriesLoading: true,
      bestsellersLoading: true,
      healthyPicksLoading: true,
      bannersError: false,
      categoriesError: false,
      bestsellersError: false,
      healthyPicksError: false,
    );
    await loadHomeData();
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repo = ref.read(homeRepositoryProvider);
  return HomeNotifier(repo);
});
