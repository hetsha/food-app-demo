import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parabdi/core/storage/local_storage.dart';
import 'package:parabdi/features/address/data/models/address.dart';
import 'package:parabdi/features/address/data/repositories/address_repository.dart';
import 'package:parabdi/features/address/presentation/address_provider.dart';
import 'package:parabdi/features/home/data/models/home_data.dart';
import 'package:parabdi/features/home/data/repositories/home_repository.dart';
import 'package:parabdi/features/home/presentation/avatar_selector_sheet.dart';
import 'package:parabdi/features/home/presentation/home_provider.dart';
import 'package:parabdi/features/home/presentation/home_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAddressRepository extends AddressRepository {
  FakeAddressRepository() : super(Dio());

  @override
  Future<List<Address>> getAddresses() async => [
        Address(
          id: 'a1',
          label: 'Home',
          addressLine1: '402, Silver Heights, Ambli',
          addressLine2: 'Bopal Cross Road',
          city: 'Ahmedabad',
          state: 'Gujarat',
          postalCode: '380058',
          latitude: 23.0,
          longitude: 72.0,
          phone: '9999999999',
        ),
      ];

  @override
  Future<Address> createAddress(Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<Address> updateAddress(String id, Map<String, dynamic> data) =>
      throw UnimplementedError();

  @override
  Future<void> deleteAddress(String id) => throw UnimplementedError();
}

class FakeHomeRepository extends HomeRepository {
  FakeHomeRepository() : super(Dio());

  @override
  Future<List<BannerItem>> getBanners({int timeoutSeconds = 8, int maxRetries = 1}) async => [];

  @override
  Future<List<HomeCategory>> getCategories({int timeoutSeconds = 8, int maxRetries = 1}) async => [];

  @override
  Future<List<HomeFood>> getFoods({
    String? categoryId,
    bool? isBestseller,
    bool? isVeg,
    bool? isHealthyPick,
    int? limit,
    int timeoutSeconds = 8,
    int maxRetries = 1,
  }) async =>
      [];
}

Future<void> pumpHome(
  WidgetTester tester, {
  Size logicalSize = const Size(360, 640),
}) async {
  tester.view.physicalSize = logicalSize;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        addressRepositoryProvider.overrideWithValue(FakeAddressRepository()),
        homeRepositoryProvider.overrideWithValue(FakeHomeRepository()),
      ],
      child: const MaterialApp(home: Scaffold(body: HomeTab())),
    ),
  );
  await tester.pumpAndSettle();
}

String? _headerAvatarAsset(WidgetTester tester) {
  final pictures = tester.widgetList<SvgPicture>(find.byType(SvgPicture));
  for (final picture in pictures) {
    final loader = picture.bytesLoader;
    final assetName = (loader as dynamic).assetName;
    if (assetName is String && assetName.contains('avatar_')) {
      return assetName;
    }
  }
  return null;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await LocalStorage.init();
  });

  testWidgets('header has no horizontal overflow at 360px width',
      (tester) async {
    await pumpHome(tester);

    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Choose your avatar'), findsOneWidget);
    expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('header has no horizontal overflow at 320px width',
      (tester) async {
    await pumpHome(tester, logicalSize: const Size(320, 640));

    expect(tester.takeException(), isNull);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });

  testWidgets('no Unsplash face photo is used in the header', (tester) async {
    await pumpHome(tester);

    expect(
      find.byWidgetPredicate((w) {
        if (w is! Container || w.decoration is! BoxDecoration) return false;
        final image = (w.decoration as BoxDecoration).image;
        if (image is! DecorationImage) return false;
        return image.image is NetworkImage &&
            (image.image as NetworkImage).url.contains('unsplash');
      }),
      findsNothing,
    );
    expect(_headerAvatarAsset(tester), 'assets/images/avatar_male_1.svg');
  });

  testWidgets(
      'tapping avatar opens picker with all 10 avatars and a save button',
      (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Choose your avatar'));
    await tester.pumpAndSettle();

    expect(find.text('Choose your avatar'), findsOneWidget);
    expect(find.text('Men'), findsOneWidget);
    expect(find.text('Women'), findsOneWidget);
    for (final id in AvatarSelectorSheet.allAvatars) {
      expect(find.byKey(Key('avatar_$id')), findsOneWidget);
    }
    expect(find.byKey(const Key('save_avatar_button')), findsOneWidget);
    // Exactly one avatar (the current default) is marked selected.
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('selecting female_2 and saving updates header and persists',
      (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byTooltip('Choose your avatar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('avatar_female_2')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('save_avatar_button')));
    await tester.pumpAndSettle();

    expect(find.text('Choose your avatar'), findsNothing);
    expect(_headerAvatarAsset(tester), 'assets/images/avatar_female_2.svg');
    expect(LocalStorage.getAvatarForUser('guest'), 'female_2');

    // Selector reopens with female_2 marked as selected.
    await tester.tap(find.byTooltip('Choose your avatar'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle), findsOneWidget);

    await tester.tap(find.byKey(const Key('avatar_male_4')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save_avatar_button')));
    await tester.pumpAndSettle();

    expect(_headerAvatarAsset(tester), 'assets/images/avatar_male_4.svg');
    expect(LocalStorage.getAvatarForUser('guest'), 'male_4');
  });

  testWidgets('avatar preference is restored from storage on rebuild',
      (tester) async {
    await LocalStorage.setAvatarForUser('guest', 'female_3');

    await pumpHome(tester);

    expect(_headerAvatarAsset(tester), 'assets/images/avatar_female_3.svg');
  });

  testWidgets('legacy female style preference maps to female_1',
      (tester) async {
    await LocalStorage.setAvatarStyle('female');

    await pumpHome(tester);

    expect(_headerAvatarAsset(tester), 'assets/images/avatar_female_1.svg');
  });

  testWidgets('sheet exposes AvatarSelectorSheet.assetFor mapping',
      (tester) async {
    expect(
      AvatarSelectorSheet.assetFor('male'),
      'assets/images/avatar_male_1.svg',
    );
    expect(
      AvatarSelectorSheet.assetFor('female'),
      'assets/images/avatar_female_1.svg',
    );
    expect(AvatarSelectorSheet.assetFor('other'), 'assets/images/avatar_male_1.svg');
    expect(
      AvatarSelectorSheet.assetFor('female_4'),
      'assets/images/avatar_female_4.svg',
    );
    expect(
      AvatarSelectorSheet.assetFor('male_5'),
      'assets/images/avatar_male_5.svg',
    );
  });
}
