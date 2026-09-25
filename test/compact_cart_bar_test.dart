import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parabdi/features/home/presentation/compact_cart_bar.dart';

void main() {
  testWidgets('CompactCartBar shows count, total and View Cart',
      (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CompactCartBar(
            itemCount: 3,
            total: 420,
            onViewCart: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('3 Items • ₹420'), findsOneWidget);
    expect(find.text('View Cart'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

    await tester.tap(find.text('View Cart'));
    expect(tapped, isTrue);
  });

  testWidgets('CompactCartBar is 56 logical pixels tall',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CompactCartBar(
            itemCount: 1,
            total: 100,
            onViewCart: () {},
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byType(InkWell));
    expect(size.height, 56);
  });

  testWidgets('Tapping anywhere on the bar opens the cart', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CompactCartBar(
            itemCount: 2,
            total: 250,
            onViewCart: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CompactCartBar));
    expect(tapped, isTrue);
  });

  testWidgets('Bar sits above a bottom navigation without overlap',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CompactCartBar(
                itemCount: 2,
                total: 250,
                onViewCart: () {},
              ),
              const SizedBox(
                height: 72,
                child: Center(child: Text('NAV')),
              ),
            ],
          ),
          body: const Center(child: Text('CONTENT')),
        ),
      ),
    );

    final bar = tester.getRect(find.byType(CompactCartBar));
    final nav = tester.getRect(find.text('NAV'));

    // Cart bar is strictly above the navigation — no overlap.
    expect(bar.bottom <= nav.top, isTrue);
    expect(find.text('CONTENT'), findsOneWidget);
  });
}
