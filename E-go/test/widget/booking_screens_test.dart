import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/booking/presentation/vehicle_selection_screen.dart';
import 'package:e_go/features/booking/presentation/fare_details_screen.dart';
import 'package:e_go/features/booking/presentation/booking_confirmation_screen.dart';
import 'package:e_go/features/booking/presentation/searching_driver_screen.dart';
import 'package:e_go/features/booking/presentation/trip_completed_screen.dart';
import 'package:e_go/features/booking/presentation/ride_rating_screen.dart';
import 'package:e_go/features/rides/presentation/my_rides_screen.dart';
import 'package:e_go/features/account/presentation/profile_screen.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/mock_data/mock_data.dart';

Widget _buildTestWidget(Widget child, AppState appState) {
  return ChangeNotifierProvider<AppState>.value(
    value: appState,
    child: MaterialApp(theme: EGoTheme.light, home: child),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppState appState;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    appState = AppState();
    appState.setPickupLocation(
      const SavedLocation(
        id: 'p-test',
        label: 'Jhargram Station',
        subtitle: 'Station Road',
        coordinate: MockData.mockCurrentLocation,
      ),
    );
    appState.setDestinationLocation(
      const SavedLocation(
        id: 'd-test',
        label: 'Jhargram Bazar',
        subtitle: 'Main Market Area',
        coordinate: LatLng(22.4701, 86.9152),
      ),
    );
  });

  group('Vehicle Selection & Booking Widget Tests', () {
    testWidgets(
      'VehicleSelectionScreen displays route summary and vehicle options',
      (tester) async {
        await tester.runAsync(() async {
          await appState.proceedToVehicleSelection();
        });

        await tester.pumpWidget(
          _buildTestWidget(const VehicleSelectionScreen(), appState),
        );
        await tester.pump();

        expect(find.text('Choose vehicle'), findsOneWidget);
        expect(find.text('Jhargram Station'), findsOneWidget);
        expect(find.text('Jhargram Bazar'), findsOneWidget);
        expect(find.text('Bike'), findsOneWidget);
        expect(find.text('Toto'), findsOneWidget);
        expect(find.text('Continue'), findsOneWidget);
      },
    );

    testWidgets('FareDetailsScreen renders breakdown and total correctly', (
      tester,
    ) async {
      await tester.runAsync(() async {
        await appState.proceedToVehicleSelection();
      });
      final bikeOption = appState.availableVehicles.first;
      appState.selectVehicle(bikeOption);
      appState.proceedToFareReview();

      await tester.pumpWidget(
        _buildTestWidget(const FareDetailsScreen(), appState),
      );
      await tester.pump();

      expect(find.text('Fare breakdown'), findsOneWidget);
      expect(find.text('Base fare'), findsOneWidget);
      expect(find.text('Platform fee'), findsOneWidget);
      expect(find.text('Total estimate'), findsOneWidget);
      expect(find.text('Confirm vehicle'), findsOneWidget);
    });

    testWidgets('BookingConfirmationScreen renders confirmation actions', (
      tester,
    ) async {
      await tester.runAsync(() async {
        await appState.proceedToVehicleSelection();
      });
      appState.selectVehicle(appState.availableVehicles.first);
      appState.proceedToConfirmation();

      await tester.pumpWidget(
        _buildTestWidget(const BookingConfirmationScreen(), appState),
      );
      await tester.pump();

      expect(find.text('Confirm booking'), findsWidgets);
      expect(find.text('Pickup'), findsOneWidget);
      expect(find.text('Destination'), findsOneWidget);
      expect(find.text('Payment'), findsOneWidget);
    });

    testWidgets('SearchingDriverScreen displays animated searching state', (
      tester,
    ) async {
      await tester.runAsync(() async {
        await appState.proceedToVehicleSelection();
      });
      appState.selectVehicle(appState.availableVehicles.first);

      await tester.pumpWidget(
        _buildTestWidget(const SearchingDriverScreen(), appState),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Finding your driver'), findsOneWidget);
      expect(find.text('Cancel search'), findsOneWidget);

      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('TripCompletedScreen displays trip summary and rate action', (
      tester,
    ) async {
      await tester.runAsync(() async {
        await appState.proceedToVehicleSelection();
      });
      appState.selectVehicle(appState.availableVehicles.first);

      await tester.pumpWidget(
        _buildTestWidget(const TripCompletedScreen(), appState),
      );
      await tester.pump();

      expect(find.text("You've arrived!"), findsOneWidget);
      expect(find.text('Rate your ride'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('RideRatingScreen renders stars and tag selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(const RideRatingScreen(), appState),
      );
      await tester.pump();

      expect(find.text('Rate your ride'), findsOneWidget);
      expect(find.text('How was your ride?'), findsOneWidget);
      expect(find.text('Submit rating'), findsOneWidget);
      expect(find.text('Great driver'), findsOneWidget);
    });

    testWidgets('MyRidesScreen renders tabs and lists', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(const MyRidesScreen(), appState),
      );
      await tester.pump();

      expect(find.text('Your rides'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Electric TOTOs'), findsOneWidget);
      expect(find.text('Shared'), findsOneWidget);
    });

    testWidgets('ProfileScreen renders account options and navigation items', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestWidget(const ProfileScreen(), appState),
      );
      await tester.pump();

      expect(find.text('Account'), findsOneWidget);
      expect(find.text('My rides'), findsOneWidget);
      expect(find.text('Saved places'), findsOneWidget);
      expect(find.text('Payment methods'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });
  });
}
