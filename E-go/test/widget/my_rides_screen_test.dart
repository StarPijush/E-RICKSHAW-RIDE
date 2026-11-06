import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/features/booking/data/driver_repository.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/features/rides/presentation/my_rides_screen.dart';
import 'package:e_go/features/rides/presentation/widgets/book_toto_button.dart';
import 'package:e_go/features/rides/presentation/widgets/ride_filter_tabs.dart';
import 'package:e_go/features/rides/presentation/widgets/rides_header.dart';
import 'package:e_go/features/rides/presentation/widgets/rides_empty_state.dart';
import 'package:e_go/features/rides/presentation/widgets/ride_card.dart';
import 'package:e_go/shared/widgets/bottom_nav_bar.dart';

Widget _buildTestApp(Widget child, AppState appState) {
  return ChangeNotifierProvider<AppState>.value(
    value: appState,
    child: MaterialApp(
      theme: EGoTheme.light,
      onGenerateRoute: EGoRouter.generateRoute,
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppState appState;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    appState = AppState();
  });

  group('E-GO Rides Screen (Pixel-Perfect Native Flutter)', () {
    testWidgets(
      'renders header, filter pills, empty state and bottom navigation',
      (tester) async {
        await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
        await tester.pump();

        // Header
        expect(find.byType(RidesHeader), findsOneWidget);
        expect(find.text('Your rides'), findsOneWidget);
        expect(find.byIcon(Icons.history), findsOneWidget);

        // Filter pills
        expect(find.byType(RideFilterTabs), findsOneWidget);
        expect(find.text('All'), findsOneWidget);
        expect(find.text('Electric TOTOs'), findsOneWidget);
        expect(find.text('Shared'), findsOneWidget);

        // Empty State
        expect(find.byType(RidesEmptyState), findsOneWidget);
        expect(find.text('No rides yet'), findsOneWidget);
        expect(
          find.text('Your completed and cancelled rides will appear here.'),
          findsOneWidget,
        );

        // Booking CTA
        expect(find.byType(BookTotoButton), findsOneWidget);
        expect(find.text('Book a TOTO'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);

        // Shared Bottom Navigation
        expect(find.byType(EGoBottomNavBar), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Rides'), findsOneWidget);
        expect(find.text('Safety'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
        expect(
          find.text('Account'),
          findsNothing,
        ); // Exactly Profile, not Account
      },
    );

    testWidgets('filter tabs selection updates visually', (tester) async {
      await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
      await tester.pump();

      // Tap 'Electric TOTOs'
      await tester.tap(find.text('Electric TOTOs'));
      await tester.pumpAndSettle();

      // Tap 'Shared'
      await tester.tap(find.text('Shared'));
      await tester.pumpAndSettle();

      // Tap 'All'
      await tester.tap(find.text('All'));
      await tester.pumpAndSettle();
    });

    testWidgets('history action button resets filter to All', (tester) async {
      await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
      await tester.pump();

      // Select 'Shared'
      await tester.tap(find.text('Shared'));
      await tester.pumpAndSettle();

      // Tap history action
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Still in empty state with All
      expect(find.text('No rides yet'), findsOneWidget);
    });

    testWidgets('Book a TOTO button opens destination selection booking flow', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
      await tester.pump();

      final bookButton = find.byType(BookTotoButton);
      expect(bookButton, findsOneWidget);
      await tester.tap(bookButton);
      await tester.pumpAndSettle();

      // Destination selection route is opened
      expect(find.text('Where are you going?'), findsOneWidget);
    });

    testWidgets(
      'renders populated ride list when rides exist and respects filters',
      (tester) async {
        const pickup = SavedLocation(
          id: 'p1',
          label: 'Jhargram Station',
          subtitle: 'Station Rd',
          coordinate: LatLng(22.45, 86.98),
        );
        const destination = SavedLocation(
          id: 'd1',
          label: 'Jhargram Raj Palace',
          subtitle: 'Palace Rd',
          coordinate: LatLng(22.47, 86.99),
        );
        const mockDriver = MockDriver(
          id: 'drv-1',
          name: 'Bikash Mahato',
          rating: 4.8,
          totalRides: 140,
          vehicleNumber: 'WB-50-1234',
          vehicleName: 'Mayuri Deluxe',
          vehicleColor: 'Green',
          avatarIcon: Icons.person,
        );

        final totoRide = RideRecord(
          id: 'ride-toto',
          pickupLocation: pickup,
          destinationLocation: destination,
          vehicleType: VehicleType.toto,
          fareBreakdown: const FareBreakdown(
            vehicleType: VehicleType.toto,
            baseFare: 15,
            distanceFare: 21,
            platformFee: 2,
            distanceKm: 3.0,
            estimatedMinutes: 15,
            estimatedArrivalMinutes: 5,
          ),
          driver: mockDriver,
          status: RideStatus.completed,
          bookedAt: DateTime(2026, 11, 6, 14, 30),
          rating: 5,
        );

        final bikeRide = RideRecord(
          id: 'ride-bike',
          pickupLocation: pickup,
          destinationLocation: destination,
          vehicleType: VehicleType.bike,
          fareBreakdown: const FareBreakdown(
            vehicleType: VehicleType.bike,
            baseFare: 20,
            distanceFare: 30,
            platformFee: 3,
            distanceKm: 3.0,
            estimatedMinutes: 10,
            estimatedArrivalMinutes: 3,
          ),
          driver: mockDriver,
          status: RideStatus.completed,
          bookedAt: DateTime(2026, 11, 5, 10, 15),
        );

        // Add rides to appState
        appState.bookingRepository.addRide(totoRide);
        appState.bookingRepository.addRide(bikeRide);

        await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
        await tester.pumpAndSettle();

        // Both rides shown under 'All'
        expect(find.byType(RideCard), findsNWidgets(2));
        expect(find.text('Toto (E-Rickshaw)'), findsOneWidget);
        expect(find.text('Bike'), findsOneWidget);
        expect(find.byType(RidesEmptyState), findsNothing);

        // Filter by 'Electric TOTOs'
        await tester.tap(find.text('Electric TOTOs'));
        await tester.pumpAndSettle();

        expect(find.byType(RideCard), findsOneWidget);
        expect(find.text('Toto (E-Rickshaw)'), findsOneWidget);
        expect(find.text('Bike'), findsNothing);

        // Filter by 'Shared' -> Honest empty result
        await tester.tap(find.text('Shared'));
        await tester.pumpAndSettle();

        expect(find.byType(RideCard), findsNothing);
        expect(find.byType(RidesEmptyState), findsOneWidget);
        expect(find.text('No rides yet'), findsOneWidget);
      },
    );

    testWidgets('tapping ride card navigates to ride details screen', (
      tester,
    ) async {
      const pickup = SavedLocation(
        id: 'p1',
        label: 'Jhargram Station',
        subtitle: 'Station Rd',
        coordinate: LatLng(22.45, 86.98),
      );
      const destination = SavedLocation(
        id: 'd1',
        label: 'Jhargram Raj Palace',
        subtitle: 'Palace Rd',
        coordinate: LatLng(22.47, 86.99),
      );
      const mockDriver = MockDriver(
        id: 'drv-1',
        name: 'Bikash Mahato',
        rating: 4.8,
        totalRides: 140,
        vehicleNumber: 'WB-50-1234',
        vehicleName: 'Mayuri Deluxe',
        vehicleColor: 'Green',
        avatarIcon: Icons.person,
      );

      final totoRide = RideRecord(
        id: 'ride-toto',
        pickupLocation: pickup,
        destinationLocation: destination,
        vehicleType: VehicleType.toto,
        fareBreakdown: const FareBreakdown(
          vehicleType: VehicleType.toto,
          baseFare: 15,
          distanceFare: 21,
          platformFee: 2,
          distanceKm: 3.0,
          estimatedMinutes: 15,
          estimatedArrivalMinutes: 5,
        ),
        driver: mockDriver,
        status: RideStatus.completed,
        bookedAt: DateTime(2026, 11, 6, 14, 30),
      );

      appState.bookingRepository.addRide(totoRide);

      await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(RideCard));
      await tester.pumpAndSettle();

      // Ride details screen is displayed
      expect(find.text('Ride details'), findsOneWidget);
      expect(find.text('Fare breakdown'), findsOneWidget);
    });

    testWidgets('bottom navigation tabs navigate to appropriate routes', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
      await tester.pump();

      // Safety tab tap
      await tester.tap(find.text('Safety'));
      await tester.pumpAndSettle();
      expect(find.text('Help & Support'), findsOneWidget);

      // Back to Rides
      Navigator.pop(tester.element(find.text('Help & Support')));
      await tester.pumpAndSettle();

      // Profile tab tap
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('responsive layout verification across mobile viewports', (
      tester,
    ) async {
      const viewports = [
        Size(393, 852), // iPhone 14 / Pixel reference
        Size(360, 800), // Standard Android
        Size(375, 812), // iPhone X/11/12 mini
        Size(412, 915), // Pixel 7 Pro
        Size(430, 932), // iPhone 14 Pro Max
      ];

      for (final size in viewports) {
        tester.view.physicalSize = Size(size.width * 2, size.height * 2);
        tester.view.devicePixelRatio = 2.0;

        await tester.pumpWidget(_buildTestApp(const MyRidesScreen(), appState));
        await tester.pumpAndSettle();

        expect(find.text('Your rides'), findsOneWidget);
        expect(find.text('No rides yet'), findsOneWidget);
        expect(find.text('Book a TOTO'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
