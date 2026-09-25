import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parabdi/core/storage/local_storage.dart';
import 'package:parabdi/core/widgets/searchable_options_sheet.dart';
import 'package:parabdi/features/address/data/models/address.dart';
import 'package:parabdi/features/address/data/repositories/address_repository.dart';
import 'package:parabdi/features/address/data/repositories/places_repository.dart';
import 'package:parabdi/features/address/presentation/address_form_screen.dart';
import 'package:parabdi/features/address/presentation/address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAddressRepository extends AddressRepository {
  FakeAddressRepository([this.items = const []]) : super(Dio());

  final List<Address> items;
  final List<Map<String, dynamic>> created = [];

  @override
  Future<List<Address>> getAddresses() async => items;

  @override
  Future<Address> createAddress(Map<String, dynamic> data) async {
    created.add(data);
    return Address.fromJson({
      'id': 'new-id',
      'label': data['label'],
      'addressLine1': data['addressLine1'],
      'addressLine2': data['addressLine2'],
      'city': data['city'],
      'state': data['state'],
      'postalCode': data['postalCode'],
      'latitude': data['latitude'],
      'longitude': data['longitude'],
      'phone': data['phone'],
      'isDefault': false,
    });
  }

  @override
  Future<Address> updateAddress(String id, Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAddress(String id) => throw UnimplementedError();
}

class FakePlacesRepository extends PlacesRepository {
  FakePlacesRepository() : super(Dio());

  @override
  Future<List<PlaceResult>> searchPlaces(String query) async => [];

  @override
  Future<ReverseGeocodeResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async =>
      null;
}

Finder cityField() => find.byIcon(Icons.arrow_drop_down_rounded).at(0);
Finder stateField() => find.byIcon(Icons.arrow_drop_down_rounded).at(1);

Future<void> pumpForm(WidgetTester tester) async {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
      ),
      GoRoute(
        path: '/addresses/add',
        builder: (_, __) => const AddressFormScreen(),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        addressRepositoryProvider.overrideWithValue(FakeAddressRepository()),
        placesRepositoryProvider.overrideWithValue(FakePlacesRepository()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  router.push('/addresses/add');
  await tester.pumpAndSettle();
}

Future<void> openSheetAndPick(
  WidgetTester tester, {
  required Finder field,
  required String search,
  required String option,
}) async {
  await tester.tap(field);
  await tester.pumpAndSettle();

  expect(find.byType(SearchableOptionsSheet), findsOneWidget);

  final sheetSearch = find.descendant(
    of: find.byType(SearchableOptionsSheet),
    matching: find.byType(TextField),
  );
  await tester.enterText(sheetSearch, search);
  await tester.pumpAndSettle();

  final optionFinder = find.descendant(
    of: find.byType(SearchableOptionsSheet),
    matching: find.widgetWithText(ListTile, option),
  );
  expect(optionFinder, findsOneWidget);

  await tester.tap(optionFinder);
  await tester.pumpAndSettle();

  expect(find.byType(SearchableOptionsSheet), findsNothing);
}

Future<void> tapSave(WidgetTester tester) async {
  final saveButton = find.widgetWithText(ElevatedButton, 'Save Address');
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  testWidgets('state field opens searchable sheet and selects Gujarat',
      (tester) async {
    await pumpForm(tester);

    await tester.tap(stateField());
    await tester.pumpAndSettle();

    expect(find.text('Select State'), findsOneWidget);
    expect(find.text('Search state...'), findsOneWidget);

    final sheetSearch = find.descendant(
      of: find.byType(SearchableOptionsSheet),
      matching: find.byType(TextField),
    );
    await tester.enterText(sheetSearch, 'Guja');
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(SearchableOptionsSheet),
        matching: find.text('Gujarat'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(SearchableOptionsSheet),
        matching: find.text('Maharashtra'),
      ),
      findsNothing,
    );

    await tester.tap(
      find.descendant(
        of: find.byType(SearchableOptionsSheet),
        matching: find.text('Gujarat'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SearchableOptionsSheet), findsNothing);
    expect(find.widgetWithText(TextFormField, 'Gujarat'), findsOneWidget);
  });

  testWidgets('city options depend on the selected state', (tester) async {
    await pumpForm(tester);

    await openSheetAndPick(
      tester,
      field: stateField(),
      search: 'Gujarat',
      option: 'Gujarat',
    );
    await openSheetAndPick(
      tester,
      field: cityField(),
      search: 'Ahm',
      option: 'Ahmedabad',
    );

    expect(
      find.widgetWithText(TextFormField, 'Ahmedabad'),
      findsOneWidget,
    );

    // Change state to Maharashtra — previously selected city must clear.
    await openSheetAndPick(
      tester,
      field: stateField(),
      search: 'Maharashtra',
      option: 'Maharashtra',
    );

    expect(
      find.widgetWithText(TextFormField, 'Ahmedabad'),
      findsNothing,
    );

    // City list now shows Maharashtra cities only.
    await tester.tap(cityField());
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(SearchableOptionsSheet),
        matching: find.text('Mumbai'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(SearchableOptionsSheet),
        matching: find.text('Ahmedabad'),
      ),
      findsNothing,
    );

    await tester.tap(
      find.descendant(
        of: find.byType(SearchableOptionsSheet),
        matching: find.text('Mumbai'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextFormField, 'Mumbai'), findsOneWidget);
  });

  testWidgets('city picker asks for a state when none is selected',
      (tester) async {
    await pumpForm(tester);

    await tester.tap(cityField());
    await tester.pumpAndSettle();

    expect(find.byType(SearchableOptionsSheet), findsNothing);
    expect(find.text('Please select a state first'), findsOneWidget);
  });

  testWidgets('save blocks empty city and state with clear messages',
      (tester) async {
    await pumpForm(tester);

    await tapSave(tester);

    expect(find.text('Please select a city'), findsOneWidget);
    expect(find.text('Please select a state'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Enter valid 6-digit postal code'), findsOneWidget);
  });

  testWidgets('postal code rejects obviously invalid PIN codes',
      (tester) async {
    await pumpForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Postal Code'),
      '012345',
    );
    await tester.pumpAndSettle();

    await tapSave(tester);

    expect(find.text('Enter valid 6-digit postal code'), findsOneWidget);
  });

  testWidgets('valid selections save city, state and postal code',
      (tester) async {
    await pumpForm(tester);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Address Line 1 (Flat, House No.)'),
      '402, Silver Heights',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Postal Code'),
      '380007',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Phone Number'),
      '9876543210',
    );

    await openSheetAndPick(
      tester,
      field: stateField(),
      search: 'Guj',
      option: 'Gujarat',
    );
    await openSheetAndPick(
      tester,
      field: cityField(),
      search: 'Sur',
      option: 'Surat',
    );

    await tapSave(tester);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(MaterialApp)),
    );
    final repo = container.read(addressRepositoryProvider);
    expect(repo, isA<FakeAddressRepository>());

    final fake = repo as FakeAddressRepository;
    expect(fake.created, hasLength(1));
    expect(fake.created.first['city'], 'Surat');
    expect(fake.created.first['state'], 'Gujarat');
    expect(fake.created.first['postalCode'], '380007');
    expect(fake.created.first['addressLine1'], '402, Silver Heights');
  });
}
