import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/core/mock_pricing.dart';

void main() {
  group('MockPricingService Unit Tests', () {
    const from = LatLng(22.4550, 86.9020); // Jhargram Station Area
    const to = LatLng(22.4701, 86.9152); // Jhargram Bazar

    test('Distance calculation is positive and realistic for local route', () {
      final distance = MockPricingService.distanceKm(from, to);
      expect(distance, greaterThan(0.5));
      expect(distance, lessThan(10.0));
    });

    test('Bike fare calculation components sum exactly to total fare', () {
      final fare = MockPricingService.calculateFare(
        vehicleType: VehicleType.bike,
        from: from,
        to: to,
      );

      expect(fare.vehicleType, equals(VehicleType.bike));
      expect(fare.vehicleName, equals('Bike'));
      expect(fare.baseFare, equals(20.0));
      expect(fare.platformFee, equals(3.0));
      expect(
        fare.totalFare,
        equals(fare.baseFare + fare.distanceFare + fare.platformFee),
      );
      expect(fare.estimatedMinutes, greaterThanOrEqualTo(2));
      expect(fare.estimatedArrivalMinutes, greaterThanOrEqualTo(1));
    });

    test('Toto fare calculation components sum exactly to total fare', () {
      final fare = MockPricingService.calculateFare(
        vehicleType: VehicleType.toto,
        from: from,
        to: to,
      );

      expect(fare.vehicleType, equals(VehicleType.toto));
      expect(fare.vehicleName, contains('Toto'));
      expect(fare.baseFare, equals(15.0));
      expect(fare.platformFee, equals(2.0));
      expect(
        fare.totalFare,
        equals(fare.baseFare + fare.distanceFare + fare.platformFee),
      );
      expect(fare.estimatedMinutes, greaterThanOrEqualTo(3));
      expect(fare.estimatedArrivalMinutes, greaterThanOrEqualTo(1));
    });

    test(
      'Zero or near-zero distance enforces minimum distance calculation',
      () {
        final fare = MockPricingService.calculateFare(
          vehicleType: VehicleType.bike,
          from: from,
          to: from, // Same point
        );

        expect(fare.distanceKm, greaterThanOrEqualTo(0.5));
        expect(fare.totalFare, greaterThanOrEqualTo(25.0));
      },
    );
  });
}
