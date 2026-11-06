import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/theme/theme.dart';
import 'package:e_go/app/theme/colors.dart';
import 'package:e_go/core/branding/widgets/ego_logo.dart';
import 'package:e_go/features/home/presentation/home_screen.dart';
import 'package:e_go/features/home/presentation/widgets/home_location_marker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('EGoTheme creates valid ThemeData', () {
    final theme = EGoTheme.light;
    expect(theme, isNotNull);
    expect(theme.colorScheme.primary, equals(EGoColors.brandPrimary));
    expect(theme.colorScheme.surface, equals(const Color(0xFFFFFFFF)));
    expect(theme.scaffoldBackgroundColor, equals(EGoColors.grey50));
    expect(theme.appBarTheme.backgroundColor, equals(const Color(0xFFFFFFFF)));
    expect(theme.cardTheme.color, equals(const Color(0xFFFFFFFF)));
  });

  testWidgets(
    'EGoHomeScreen renders refined header without icons and with enlarged recenter button',
    (tester) async {
      final appState = AppState();

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>.value(
          value: appState,
          child: const MaterialApp(home: EGoHomeScreen()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      // Verify CustomPaint for map and animated location marker
      expect(find.byType(CustomPaint), findsWidgets);
      expect(find.byType(HomeCurrentLocationMarker), findsOneWidget);

      // Verify top header uses the official EgoLogo widget (not text or icon)
      expect(find.byType(EgoLogo), findsWidgets);
      // Verify lightning bolt logo symbol is completely removed
      expect(find.byIcon(Icons.electric_bolt), findsNothing);
      // Verify notification action icon is completely removed
      expect(find.byIcon(Icons.notifications_outlined), findsNothing);

      // Verify enlarged recenter button exists and is tappable
      final recenterFinder = find.byIcon(Icons.my_location_rounded);
      expect(recenterFinder, findsWidgets);
      await tester.tap(recenterFinder.first);
      await tester.pump(const Duration(milliseconds: 600));

      // Verify booking bottom sheet elements remain intact
      expect(find.text('Where to?'), findsOneWidget);
      expect(find.text('Choose your destination'), findsOneWidget);
      expect(find.text('PICKUP LOCATION'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
      expect(find.text('Add saved place'), findsOneWidget);
      expect(find.text('CHOOSE LOCATION'), findsOneWidget);

      // Verify bottom navigation items remain intact
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Rides'), findsOneWidget);
      expect(find.text('Safety'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    },
  );
}
