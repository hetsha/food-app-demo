import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parabdi/core/storage/local_storage.dart';
import 'package:parabdi/features/address/data/models/address.dart';
import 'package:parabdi/features/address/data/repositories/address_repository.dart';
import 'package:parabdi/features/address/presentation/address_provider.dart';
import 'package:parabdi/features/address/presentation/select_location_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAddressRepository extends AddressRepository {
  FakeAddressRepository(this.items) : super(Dio());

  final List<Address> items;

  @override
  Future<List<Address>> getAddresses() async => items;

  @override
  Future<Address> createAddress(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<Address> updateAddress(String id, Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAddress(String id) => throw UnimplementedError();
}

Address _address({
  required String id,
  required String label,
  bool isDefault = false,
}) {
  return Address(
    id: id,
    label: label,
    addressLine1: '$label Street',
    addressLine2: 'Area',
    city: 'Ahmedabad',
    state: 'Gujarat',
    postalCode: '380001',
    latitude: 23.0,
    longitude: 72.0,
    phone: '9999999999',
    isDefault: isDefault,
  );
}

void main() {
  const homeId = 'addr-home';
  const officeId = 'addr-office';
  const userId = 'user-1';

  final home = _address(id: homeId, label: 'Home');
  final office = _address(id: officeId, label: 'Office');
  final items = [home, office];

  Future<ProviderContainer> pumpLocationScreen(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/location',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(
          path: '/location',
          builder: (_, __) => const SelectLocationScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, __) => const Scaffold(body: Text('home')),
        ),
        GoRoute(
          path: '/addresses',
          builder: (_, __) => const Scaffold(body: Text('addresses-list')),
        ),
        GoRoute(
          path: '/addresses/add',
          builder: (_, __) => const Scaffold(body: Text('add-address')),
        ),
        GoRoute(
          path: '/addresses/edit/:id',
          builder: (_, __) => const Scaffold(body: Text('edit-address')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          addressRepositoryProvider.overrideWithValue(
            FakeAddressRepository(items),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'user_id': userId,
      'selected_address_id': homeId,
      'selected_address_json': jsonEncode(home.toJson()),
      'selected_address_user_id': userId,
    });
    await LocalStorage.init();
  });

  testWidgets(
      'location screen lists saved addresses and marks the restored selection',
      (tester) async {
    await pumpLocationScreen(tester);

    expect(find.text('Select Your Location'), findsOneWidget);
    expect(find.text('Saved addresses'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('View all'), findsOneWidget);
    expect(find.text('Use Current Location'), findsOneWidget);
    expect(find.byIcon(Icons.more_vert_rounded), findsNWidgets(2));

    final containers = tester
        .widgetList<Container>(
          find.ancestor(
            of: find.text('Home'),
            matching: find.byType(Container),
          ),
        )
        .toList();
    final hasBorder = containers.any((c) {
      final decoration = c.decoration;
      if (decoration is BoxDecoration) {
        return decoration.border is Border;
      }
      return false;
    });
    expect(hasBorder, isTrue);
  });

  testWidgets(
      'tapping an address updates state, persists selection, and pops back',
      (tester) async {
    final container = await pumpLocationScreen(tester);

    expect(
      container.read(addressNotifierProvider).selectedAddress?.id,
      homeId,
    );

    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    // Selection screen popped back to the shell route.
    expect(find.text('Select Your Location'), findsNothing);
    expect(find.text('home'), findsOneWidget);

    final selected = container.read(addressNotifierProvider).selectedAddress;
    expect(selected, isNotNull);
    expect(selected!.id, officeId);
    expect(selected.label, 'Office');

    expect(LocalStorage.selectedAddressId, officeId);
    expect(LocalStorage.selectedAddressUserId, userId);
    expect(LocalStorage.selectedAddressJson, isNotNull);
    final persisted = jsonDecode(LocalStorage.selectedAddressJson!);
    expect(persisted['id'], officeId);
  });

  testWidgets('persisted selection is restored after provider rebuild',
      (tester) async {
    final container = await pumpLocationScreen(tester);

    container.invalidate(addressNotifierProvider);
    container.read(addressNotifierProvider.notifier).loadAddresses();
    await tester.pumpAndSettle();

    final restored = container.read(addressNotifierProvider).selectedAddress;
    expect(restored, isNotNull);
    expect(restored!.id, homeId);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('view all opens the addresses list screen', (tester) async {
    await pumpLocationScreen(tester);

    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();

    expect(find.text('addresses-list'), findsOneWidget);
  });
}
