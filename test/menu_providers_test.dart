import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parabdi/features/menu/data/models/menu_food.dart';
import 'package:parabdi/features/menu/data/repositories/menu_repository.dart';
import 'package:parabdi/features/menu/presentation/menu_providers.dart';

class FakeMenuRepository extends MenuRepository {
  FakeMenuRepository() : super(Dio());

  final List<Map<String, dynamic?>> calls = [];
  List<MenuFood> foods = [];
  Object? throwError;

  final List<Completer> _gates = [];
  final List<List<MenuFood>> _gateResults = [];
  bool gated = false;

  int gateCount() => _gates.length;

  void respond(int index, List<MenuFood> result) {
    _gateResults[index] = result;
    _gates[index].complete();
  }

  @override
  Future<List<MenuFood>> getFoods({
    String? categoryId,
    String? search,
    bool? isVeg,
    bool? isBestseller,
    int take = 200,
  }) async {
    calls.add({
      'categoryId': categoryId,
      'search': search,
      'isVeg': isVeg,
      'isBestseller': isBestseller,
    });
    if (throwError != null) throw throwError!;
    if (gated) {
      final index = _gates.length;
      _gates.add(Completer());
      _gateResults.add(const []);
      await _gates[index].future;
      return _gateResults[index];
    }
    var result = foods;
    if (categoryId != null) {
      result = result.where((f) => f.categoryId == categoryId).toList();
    }
    if (search != null && search.isNotEmpty) {
      result = result
          .where((f) => f.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    if (isVeg == true) {
      result = result.where((f) => f.isVeg).toList();
    }
    return result;
  }
}

MenuFood food(String id, String name, {String? categoryId, bool isVeg = true}) {
  return MenuFood(
    id: id,
    name: name,
    price: 100,
    categoryId: categoryId,
    isVeg: isVeg,
  );
}

Future<void> waitUntil(bool Function() condition,
    {int maxIterations = 100}) async {
  for (var i = 0; i < maxIterations; i++) {
    if (condition()) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('Condition not met within $maxIterations event-loop turns');
}

void main() {
  late FakeMenuRepository repo;
  late FoodListNotifier notifier;

  setUp(() {
    repo = FakeMenuRepository();
    repo.foods = [
      food('1', 'Gujarati Thali', categoryId: 'thali'),
      food('2', 'Rice Bowl', categoryId: 'rice'),
      food('3', 'Cola', categoryId: 'bev', isVeg: true),
    ];
    notifier = FoodListNotifier(repo);
  });

  tearDown(() => notifier.dispose());

  test('initial load fetches all foods with no filters', () async {
    await notifier.loadFoods();
    expect(repo.calls.last['categoryId'], isNull);
    expect(repo.calls.last['search'], isNull);
    expect(notifier.state.foods.length, 3);
    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.error, isNull);
  });

  test('setCategory filters by category; null restores full list', () async {
    await notifier.loadFoods();
    notifier.setCategory('thali');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.foods.length == 1);
    expect(repo.calls.last['categoryId'], 'thali');
    expect(notifier.state.foods.single.name, 'Gujarati Thali');

    notifier.setCategory(null);
    await waitUntil(() => !notifier.state.isLoading && notifier.state.foods.length == 3);
    expect(repo.calls.last['categoryId'], isNull);
    expect(notifier.state.foods.length, 3);
  });

  test('search + category are sent together', () async {
    await notifier.loadFoods();
    notifier.setSearch('thali');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.foods.length == 1);

    notifier.setCategory('thali');
    await waitUntil(() => !notifier.state.isLoading);
    expect(repo.calls.last['search'], 'thali');
    expect(repo.calls.last['categoryId'], 'thali');
    expect(notifier.state.foods.single.name, 'Gujarati Thali');
  });

  test('empty/whitespace search clears the search filter', () async {
    await notifier.loadFoods();
    notifier.setSearch('rice');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.foods.length == 1);

    notifier.setSearch('   ');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.foods.length == 3);
    expect(repo.calls.last['search'], isNull);
    expect(notifier.state.search, isNull);
  });

  test('veg filter combines with existing category/search', () async {
    await notifier.loadFoods();
    notifier.setSearch('cola');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.foods.length == 1);

    notifier.setVegFilter(true);
    await waitUntil(() => !notifier.state.isLoading);
    expect(repo.calls.last['isVeg'], isTrue);
    expect(repo.calls.last['search'], 'cola');
  });

  test('rapid category switches discard stale responses', () async {
    repo.gated = true;
    final f0 = notifier.loadFoods(); // request 0 (initial)
    await waitUntil(() => repo.gateCount() == 1);

    notifier.setCategory('thali'); // request 1
    await waitUntil(() => repo.gateCount() == 2);
    notifier.setCategory(null); // request 2
    await waitUntil(() => repo.gateCount() == 3);

    // Newest resolves first with the full list.
    repo.respond(2, [food('1', 'Gujarati Thali', categoryId: 'thali'), food('2', 'Rice Bowl', categoryId: 'rice')]);
    await waitUntil(() => !notifier.state.isLoading);
    expect(notifier.state.foods.length, 2);

    // Older "thali" response arrives late — must be discarded.
    repo.respond(1, [food('1', 'Gujarati Thali', categoryId: 'thali')]);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(notifier.state.foods.length, 2);

    repo.respond(0, const []);
    await f0;
    await Future<void>.delayed(Duration.zero);
    expect(notifier.state.foods.length, 2);
    expect(notifier.state.isLoading, isFalse);
  });

  test('failure clears loading and surfaces an error (no stuck spinner)',
      () async {
    repo.throwError = Exception('boom');
    await notifier.loadFoods();

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.error, isNotNull);
  });
}
