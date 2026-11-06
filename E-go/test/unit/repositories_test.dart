import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/auth/data/customer_repository.dart';
import 'package:e_go/features/booking/data/vehicle_repository.dart';
import 'package:e_go/features/booking/data/driver_repository.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/features/location/data/location_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/mock_data/mock_data.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Mock Repositories Unit Tests', () {
    test('Customer repository validates demo mock OTP', () {
      final repo = MockCustomerRepository();
      expect(repo.validateOtp('123456'), isTrue);
      expect(repo.validateOtp('000000'), isFalse);
      expect(repo.validateOtp(''), isFalse);
    });

    test('Location repository returns results for search', () async {
      final repo = LocationRepository();
      final all = await repo.searchPlaces('');
      expect(all, isNotEmpty);

      final searchStation = await repo.searchPlaces('Station');
      expect(searchStation, isNotEmpty);
      expect(searchStation.first.name, contains('Station'));

      final searchEmpty = await repo.searchPlaces('NonExistentPlaceXYZ');
      expect(searchEmpty, isEmpty);
    });

    test('Location repository returns recent destinations', () async {
      final repo = LocationRepository();
      final recent = await repo.getRecentDestinations();
      expect(recent, isNotEmpty);
      expect(recent.length, greaterThanOrEqualTo(2));
    });

    test(
      'Vehicle repository returns Bike and Toto options with valid pricing',
      () async {
        final repo = MockVehicleRepository();
        const from = MockData.mockCurrentLocation;
        const to = LatLng(22.4701, 86.9152);

        final vehicles = await repo.getAvailableVehicles(from: from, to: to);
        expect(vehicles.length, equals(2));

        final bike = vehicles.firstWhere((v) => v.type == VehicleType.bike);
        final toto = vehicles.firstWhere((v) => v.type == VehicleType.toto);

        expect(bike.name, equals('Bike'));
        expect(bike.capacity, equals(1));
        expect(toto.name, equals('Toto'));
        expect(toto.capacity, equals(3));
        expect(bike.fareBreakdown.totalFare, greaterThan(0));
        expect(toto.fareBreakdown.totalFare, greaterThan(0));
      },
    );

    test('Driver repository provides deterministic demo drivers', () async {
      final repo = MockDriverRepository();
      final bikeDriver = await repo.getAssignedDriver();
      final totoDriver = await repo.getAssignedTotoDriver();

      expect(bikeDriver.name, isNotEmpty);
      expect(bikeDriver.vehicleNumber, isNotEmpty);
      expect(bikeDriver.rating, greaterThan(4.0));

      expect(totoDriver.name, isNotEmpty);
      expect(totoDriver.vehicleNumber, isNotEmpty);
      expect(totoDriver.rating, greaterThan(4.0));
    });

    test('Booking repository records, retrieves, and updates ride records', () {
      final repo = MockBookingRepository();
      const pickup = SavedLocation(
        id: 'p1',
        label: 'Jhargram Station',
        coordinate: MockData.mockCurrentLocation,
      );
      const dest = SavedLocation(
        id: 'd1',
        label: 'Jhargram Palace',
        coordinate: LatLng(22.4480, 86.8950),
      );

      final fare = MockPricingService.calculateFare(
        vehicleType: VehicleType.bike,
        from: pickup.coordinate,
        to: dest.coordinate,
      );

      final ride = RideRecord(
        id: MockBookingRepository.generateId(),
        pickupLocation: pickup,
        destinationLocation: dest,
        vehicleType: VehicleType.bike,
        fareBreakdown: fare,
        driver: const MockDriver(
          id: 'd-1',
          name: 'Rajan Kumar',
          rating: 4.8,
          totalRides: 300,
          vehicleNumber: 'WB 32 D 1234',
          vehicleName: 'Hero Splendor',
          vehicleColor: 'Black',
          avatarIcon: Icons.person,
        ),
        status: RideStatus.active,
        bookedAt: DateTime.now(),
      );

      repo.addRide(ride);
      expect(repo.getAllRides(), contains(ride));
      expect(repo.getRideById(ride.id), equals(ride));

      // Update to completed
      final completed = ride.copyWith(
        status: RideStatus.completed,
        completedAt: DateTime.now(),
        rating: 5,
        ratingComment: 'Great ride',
      );
      repo.updateRide(completed);

      final fetched = repo.getRideById(ride.id);
      expect(fetched?.status, equals(RideStatus.completed));
      expect(fetched?.rating, equals(5));
      expect(repo.getCompletedRides(), contains(completed));
    });
  });
}
