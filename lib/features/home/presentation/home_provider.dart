import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
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

  HomeState({
    this.isLoading = false,
    this.errorMessage,
    this.banners = const [],
    this.categories = const [],
    this.bestsellers = const [],
    this.healthyPicks = const [],
  });

  HomeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BannerItem>? banners,
    List<HomeCategory>? categories,
    List<HomeFood>? bestsellers,
    List<HomeFood>? healthyPicks,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      bestsellers: bestsellers ?? this.bestsellers,
      healthyPicks: healthyPicks ?? this.healthyPicks,
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
    try {
      final results = await Future.wait([
        _repo.getBanners().catchError((e) {
          debugPrint('Error fetching banners: $e');
          return <BannerItem>[];
        }),
        _repo.getCategories().catchError((e) {
          debugPrint('Error fetching categories: $e');
          return <HomeCategory>[];
        }),
        _repo.getFoods(isBestseller: true, limit: 10).catchError((e) {
          debugPrint('Error fetching bestsellers: $e');
          return <HomeFood>[];
        }),
        _repo.getFoods(isHealthyPick: true, limit: 10).catchError((e) {
          debugPrint('Error fetching healthy picks: $e');
          return <HomeFood>[];
        }),
      ]);

      state = state.copyWith(
        isLoading: false,
        banners: results[0] as List<BannerItem>,
        categories: results[1] as List<HomeCategory>,
        bestsellers: results[2] as List<HomeFood>,
        healthyPicks: results[3] as List<HomeFood>,
      );
    } catch (e) {
      final message = e is DioException ? _extractError(e) : 'Something went wrong. Please try again.';
      state = state.copyWith(
        isLoading: false,
        errorMessage: message,
      );
    }
  }

  Future<void> refresh() async => loadHomeData();

  String _extractError(DioException e) {
    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data;
      if (data['error'] is Map && data['error']['message'] != null) {
        return data['error']['message'].toString();
      }
      if (data['message'] != null) {
        return data['message'].toString();
      }
    }
    return e.error?.toString() ?? 'Something went wrong';
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repo = ref.read(homeRepositoryProvider);
  return HomeNotifier(repo);
});
