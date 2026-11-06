// E-GO mock pricing service.
// Deterministic fare calculation for demo purposes.
// All fares are estimates — clearly marked as demo data.
// Replace with real pricing API in production.

import 'dart:math' as math;
import 'package:latlong2/latlong.dart';

enum VehicleType { bike, toto }

class FareBreakdown {
  const FareBreakdown({
    required this.vehicleType,
    required this.baseFare,
    required this.distanceFare,
    required this.platformFee,
    required this.distanceKm,
    required this.estimatedMinutes,
    required this.estimatedArrivalMinutes,
  });

  final VehicleType vehicleType;
  final double baseFare;
  final double distanceFare;
  final double platformFee;
  final double distanceKm;
  final int estimatedMinutes;
  final int estimatedArrivalMinutes;

  double get totalFare => baseFare + distanceFare + platformFee;

  String get vehicleName {
    switch (vehicleType) {
      case VehicleType.bike:
        return 'Bike';
      case VehicleType.toto:
        return 'Toto (E-Rickshaw)';
    }
  }

  FareBreakdown copyWith({
    VehicleType? vehicleType,
    double? baseFare,
    double? distanceFare,
    double? platformFee,
    double? distanceKm,
    int? estimatedMinutes,
    int? estimatedArrivalMinutes,
  }) {
    return FareBreakdown(
      vehicleType: vehicleType ?? this.vehicleType,
      baseFare: baseFare ?? this.baseFare,
      distanceFare: distanceFare ?? this.distanceFare,
      platformFee: platformFee ?? this.platformFee,
      distanceKm: distanceKm ?? this.distanceKm,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      estimatedArrivalMinutes:
          estimatedArrivalMinutes ?? this.estimatedArrivalMinutes,
    );
  }
}

/// Calculates mock fare based on distance.
/// Pricing is demo-only and does not reflect real rates.
abstract class MockPricingService {
  /// Haversine distance between two coordinates in kilometers.
  static double distanceKm(LatLng from, LatLng to) {
    const r = 6371.0;
    final lat1 = from.latitudeInRad;
    final lat2 = to.latitudeInRad;
    final dLat = to.latitudeInRad - from.latitudeInRad;
    final dLon = to.longitudeInRad - from.longitudeInRad;

    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
    final c = 2 * math.asin(math.sqrt(a));
    return r * c;
  }

  static FareBreakdown calculateFare({
    required VehicleType vehicleType,
    required LatLng from,
    required LatLng to,
  }) {
    final distance = distanceKm(from, to);
    // Minimum 0.5 km for fare purposes
    final effectiveDistance = distance < 0.5 ? 0.5 : distance;

    switch (vehicleType) {
      case VehicleType.bike:
        final baseFare = 20.0;
        final distanceFare = double.parse(
          (effectiveDistance * 10).toStringAsFixed(0),
        );
        const platformFee = 3.0;
        final travelMins = (effectiveDistance / 20 * 60 + 3).round().clamp(
          2,
          60,
        );
        const arrivalMins = 3;
        return FareBreakdown(
          vehicleType: vehicleType,
          baseFare: baseFare,
          distanceFare: distanceFare,
          platformFee: platformFee,
          distanceKm: double.parse(effectiveDistance.toStringAsFixed(1)),
          estimatedMinutes: travelMins,
          estimatedArrivalMinutes: arrivalMins,
        );
      case VehicleType.toto:
        final baseFare = 15.0;
        final distanceFare = double.parse(
          (effectiveDistance * 7).toStringAsFixed(0),
        );
        const platformFee = 2.0;
        final travelMins = (effectiveDistance / 12 * 60 + 5).round().clamp(
          3,
          90,
        );
        const arrivalMins = 5;
        return FareBreakdown(
          vehicleType: vehicleType,
          baseFare: baseFare,
          distanceFare: distanceFare,
          platformFee: platformFee,
          distanceKm: double.parse(effectiveDistance.toStringAsFixed(1)),
          estimatedMinutes: travelMins,
          estimatedArrivalMinutes: arrivalMins,
        );
    }
  }
}
