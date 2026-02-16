import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glass_pill_nav/glass_pill_nav.dart';

void main() {
  testWidgets('GlassPillNav displays items and responds to taps',
      (WidgetTester tester) async {
    int currentIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return GlassPillNav(
                currentIndex: currentIndex,
                style: const GlassPillNavStyle(
                  enableShimmer: false, // Disable shimmer for stable testing
                ),
                onTabTap: (index) => setState(() => currentIndex = index),
                items: [
                  const GlassPillNavItem(
                    icon: Icons.home,
                    label: 'Home',
                  ),
                  const GlassPillNavItem(
                    icon: Icons.search,
                    label: 'Search',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    // Verify icons are present
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Tap the search item
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify index changed
    expect(currentIndex, 1);
  });

  testWidgets('GlassPillNav respects customization properties',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: GlassPillNav(
            currentIndex: 0,
            style: const GlassPillNavStyle(
              blurSigma: 25,
              animationDuration: Duration(seconds: 1),
              scaleAmount: 1.5,
              enableShimmer: false,
              enableLiquidEffect: true,
            ),
            items: const [
              GlassPillNavItem(icon: Icons.home),
              GlassPillNavItem(icon: Icons.search),
            ],
          ),
        ),
      ),
    );

    final glassPillNav = tester.widget<GlassPillNav>(find.byType(GlassPillNav));
    expect(glassPillNav.style!.blurSigma, 25);
    expect(glassPillNav.style!.animationDuration, const Duration(seconds: 1));
    expect(glassPillNav.style!.scaleAmount, 1.5);
  });
}
