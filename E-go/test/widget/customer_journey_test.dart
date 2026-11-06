import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/core/booking_state.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/mock_data/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Full Customer Journey Integration Flow', () {
    testWidgets(
      'Simulated end-to-end booking, driver tracking, completion, and rating flow',
      (tester) async {
        await tester.runAsync(() async {
          final appState = AppState();

          // Step 1: Initial state
          expect(appState.bookingStatus, equals(BookingStatus.idle));

          // Step 2: Set Pickup and Destination
          const pickup = SavedLocation(
            id: 'p1',
            label: 'Jhargram Railway Station',
            subtitle: 'Station Road',
            coordinate: MockData.mockCurrentLocation,
          );
          const destination = SavedLocation(
            id: 'd1',
            label: 'Jhargram Raj Palace',
            subtitle: 'Palace Road',
            coordinate: LatLng(22.4480, 86.8950),
          );

          appState.setPickupLocation(pickup);
          appState.setDestinationLocation(destination);

          expect(
            appState.pickupLocation?.label,
            equals('Jhargram Railway Station'),
          );
          expect(
            appState.destinationLocation?.label,
            equals('Jhargram Raj Palace'),
          );

          // Step 3: Load available vehicles and select Toto
          await appState.proceedToVehicleSelection();
          expect(
            appState.bookingStatus,
            equals(BookingStatus.selectingVehicle),
          );
          expect(appState.availableVehicles.length, equals(2));

          final toto = appState.availableVehicles.firstWhere(
            (v) => v.type == VehicleType.toto,
          );
          appState.selectVehicle(toto);
          expect(appState.selectedVehicle?.name, equals('Toto'));

          // Step 4: Fare Review
          appState.proceedToFareReview();
          expect(appState.bookingStatus, equals(BookingStatus.reviewingFare));
          expect(
            appState.selectedVehicle!.fareBreakdown.totalFare,
            greaterThan(0),
          );

          // Step 5: Proceed to confirmation
          appState.proceedToConfirmation();
          expect(
            appState.bookingStatus,
            equals(BookingStatus.confirmingBooking),
          );

          // Step 6: Confirm booking (Triggers searching -> assigned driver)
          final bookingFuture = appState.confirmBooking();
          expect(appState.bookingStatus, equals(BookingStatus.searchingDriver));

          await bookingFuture;
          expect(appState.bookingStatus, equals(BookingStatus.driverAssigned));
          expect(appState.assignedDriver, isNotNull);
          expect(appState.currentRide, isNotNull);
          expect(appState.currentRide?.status, equals(RideStatus.active));

          // Step 7: Driver arrives & trip starts
          await appState.driverStartsArriving();
          expect(appState.bookingStatus, equals(BookingStatus.driverArriving));

          await appState.driverArrived();
          expect(appState.bookingStatus, equals(BookingStatus.driverArrived));

          await appState.startTrip();
          expect(appState.bookingStatus, equals(BookingStatus.tripInProgress));

          // Step 8: Trip completion
          await appState.completeTrip();
          expect(appState.bookingStatus, equals(BookingStatus.awaitingRating));
          expect(appState.currentRide?.status, equals(RideStatus.completed));

          // Step 9: Submit Rating
          await appState.submitRating(rating: 5, comment: 'Great smooth ride');
          expect(appState.bookingStatus, equals(BookingStatus.rated));
          expect(appState.currentRide?.rating, equals(5));

          // Step 10: Verify recorded in booking repository & all rides
          expect(appState.allRides, isNotEmpty);
          expect(appState.completedRides, isNotEmpty);
          expect(appState.completedRides.first.rating, equals(5));
        });
      },
    );

    testWidgets(
      'Booking cancellation lifecycle works correctly and cleans state',
      (tester) async {
        await tester.runAsync(() async {
          final appState = AppState();

          const pickup = SavedLocation(
            id: 'p1',
            label: 'Jhargram Station',
            coordinate: MockData.mockCurrentLocation,
          );
          const destination = SavedLocation(
            id: 'd1',
            label: 'Jhargram Bazar',
            coordinate: LatLng(22.4701, 86.9152),
          );

          appState.setPickupLocation(pickup);
          appState.setDestinationLocation(destination);
          await appState.proceedToVehicleSelection();
          appState.selectVehicle(appState.availableVehicles.first);
          appState.proceedToConfirmation();

          final bookingFuture = appState.confirmBooking();
          expect(appState.bookingStatus, equals(BookingStatus.searchingDriver));

          // Cancel during search
          await appState.cancelRide();
          expect(appState.bookingStatus, equals(BookingStatus.idle));
          expect(appState.pickupLocation, isNull);
          expect(appState.destinationLocation, isNull);

          await bookingFuture;
        });
      },
    );
  });
}
