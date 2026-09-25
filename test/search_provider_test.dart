import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parabdi/features/menu/data/models/menu_food.dart';
import 'package:parabdi/features/menu/data/repositories/menu_repository.dart';
import 'package:parabdi/features/menu/presentation/search_provider.dart';

class FakeMenuRepository extends MenuRepository {
  FakeMenuRepository() : super(Dio());

  final List<Map<String, dynamic?>> calls = [];
  List<MenuFood> foods = [];
  Object? throwError;

  // Gate-based control for race-condition tests.
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
  late SearchNotifier notifier;

  setUp(() {
    repo = FakeMenuRepository();
    repo.foods = [
      food('1', 'Gujarati Thali', categoryId: 'thali'),
      food('2', 'Paneer Tikka', categoryId: 'snacks'),
      food('3', 'Chicken Biryani', categoryId: 'rice', isVeg: false),
    ];
    notifier = SearchNotifier(repo);
  });

  tearDown(() => notifier.dispose());

  test('empty query fetches the complete menu (no search param)', () async {
    notifier.submitQuery('');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);

    expect(repo.calls.last['search'], isNull);
    expect(notifier.state.results.length, 3);
    expect(notifier.state.error, isNull);
  });

  test('whitespace-only query is treated as empty', () async {
    notifier.submitQuery('   ');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);

    expect(notifier.state.query, '');
    expect(repo.calls.last['search'], isNull);
    expect(notifier.state.results.length, 3);
  });

  test('query is trimmed and sent as search param', () async {
    notifier.submitQuery('  paneer  ');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);

    expect(notifier.state.query, 'paneer');
    expect(repo.calls.last['search'], 'paneer');
    expect(notifier.state.results.single.name, 'Paneer Tikka');
  });

  test('clearing query restores the full menu and removes stale results',
      () async {
    notifier.submitQuery('paneer');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);
    expect(notifier.state.results.length, 1);

    notifier.submitQuery('');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.length > 1);
    expect(repo.calls.last['search'], isNull);
    expect(notifier.state.results.length, 3);
  });

  test('no results yields empty list and no error (clean empty state)',
      () async {
    notifier.submitQuery('zzz-not-a-food');
    await waitUntil(() => !notifier.state.isLoading);

    expect(notifier.state.results, isEmpty);
    expect(notifier.state.error, isNull);
  });

  test('veg-only filter is combined with search', () async {
    notifier.submitQuery('biryani');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);

    notifier.toggleVegOnly();
    await waitUntil(() => !notifier.state.isLoading);

    // Chicken Biryani is non-veg → filtered out.
    expect(notifier.state.isVegOnly, isTrue);
    expect(notifier.state.results, isEmpty);
    expect(repo.calls.last['isVeg'], isTrue);
  });

  test('stale responses from an older query are discarded', () async {
    repo.gated = true;

    notifier.submitQuery('first');
    await waitUntil(() => repo.gateCount() == 1);

    notifier.submitQuery('second');
    await waitUntil(() => repo.gateCount() == 2);

    // Newer request resolves first.
    repo.respond(1, [food('9', 'Second Result')]);
    await waitUntil(() => !notifier.state.isLoading);
    expect(notifier.state.results.single.name, 'Second Result');

    // Older request resolves late — must NOT overwrite newer results.
    repo.respond(0, [food('8', 'Stale Result')]);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(notifier.state.results.single.name, 'Second Result');
    expect(notifier.state.isLoading, isFalse);
  });

  test('error does not leave the screen permanently loading', () async {
    repo.throwError = Exception('network down');
    notifier.submitQuery('x');
    await waitUntil(() => !notifier.state.isLoading);

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.error, isNotNull);
  });

  test('updateQuery debounces rapid typing into a single search', () async {
    notifier.updateQuery('p');
    notifier.updateQuery('pa');
    notifier.updateQuery('paneer');
    expect(repo.calls, isEmpty); // nothing fired yet

    await Future<void>.delayed(const Duration(milliseconds: 400));
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);

    expect(repo.calls.length, 1);
    expect(repo.calls.single['search'], 'paneer');
  });

  test('clear resets state and cancels pending work', () async {
    notifier.submitQuery('paneer');
    await waitUntil(() => !notifier.state.isLoading && notifier.state.results.isNotEmpty);

    notifier.clear();
    expect(notifier.state.query, '');
    expect(notifier.state.results, isEmpty);
    expect(notifier.state.error, isNull);
  });
}
