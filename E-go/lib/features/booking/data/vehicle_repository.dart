// E-GO mock vehicle repository.
// Returns available vehicle options for a given route.
// Uses mock data — no real driver availability.

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:e_go/core/mock_pricing.dart';

class VehicleOption {
  const VehicleOption({
    required this.type,
    required this.name,
    required this.subtitle,
    required this.capacity,
    required this.iconData,
    required this.fareBreakdown,
    this.isAvailable = true,
  });

  final VehicleType type;
  final String name;
  final String subtitle;
  final int capacity;
  final IconData iconData;
  final FareBreakdown fareBreakdown;
  final bool isAvailable;
}

class MockVehicleRepository {
  /// Returns mock vehicle options for the given route.
  /// All data is simulated — no real drivers.
  Future<List<VehicleOption>> getAvailableVehicles({
    required LatLng from,
    required LatLng to,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final bikefare = MockPricingService.calculateFare(
      vehicleType: VehicleType.bike,
      from: from,
      to: to,
    );
    final totoFare = MockPricingService.calculateFare(
      vehicleType: VehicleType.toto,
      from: from,
      to: to,
    );

    return [
      VehicleOption(
        type: VehicleType.bike,
        name: 'Bike',
        subtitle: 'Fast & affordable',
        capacity: 1,
        iconData: Icons.two_wheeler,
        fareBreakdown: bikefare,
      ),
      VehicleOption(
        type: VehicleType.toto,
        name: 'Toto',
        subtitle: 'E-Rickshaw · Up to 3 passengers',
        capacity: 3,
        iconData: Icons.electric_rickshaw,
        fareBreakdown: totoFare,
      ),
    ];
  }
}
