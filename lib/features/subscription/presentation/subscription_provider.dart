import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/subscription.dart';
import '../data/repositories/subscription_repository.dart';
import '../../../core/network/api_client.dart';

part 'subscription_provider.freezed.dart';
part 'subscription_provider.g.dart';

@riverpod
SubscriptionRepository subscriptionRepository(Ref ref) {
  return SubscriptionRepository(ApiClient.instance);
}

@freezed
class SubscriptionState with _$SubscriptionState {
  const factory SubscriptionState({
    @Default([]) List<SubscriptionPlan> plans,
    @Default([]) List<UserSubscription> mySubscriptions,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SubscriptionState;
}

@riverpod
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  SubscriptionState build() => const SubscriptionState();

  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final plans = await repo.getPlans();
      state = state.copyWith(plans: plans, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadMySubscriptions() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final subs = await repo.getMySubscriptions();
      state = state.copyWith(mySubscriptions: subs, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> subscribe(String subscriptionId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      final sub = await repo.subscribe(subscriptionId);
      state = state.copyWith(
        mySubscriptions: [...state.mySubscriptions, sub],
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> pause(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.pause(id);
      state = state.copyWith(
        mySubscriptions: state.mySubscriptions
            .map((s) => s.id == id ? s.copyWith(status: 'paused') : s)
            .toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> resume(String id) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.resume(id);
      state = state.copyWith(
        mySubscriptions: state.mySubscriptions
            .map((s) => s.id == id ? s.copyWith(status: 'active') : s)
            .toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> skipDay(String id, String date) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(subscriptionRepositoryProvider);
      await repo.skipDay(id, date);
      state = state.copyWith(
        mySubscriptions: state.mySubscriptions
            .map((s) => s.id == id
                ? s.copyWith(skipDates: [...s.skipDates, date])
                : s)
            .toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
