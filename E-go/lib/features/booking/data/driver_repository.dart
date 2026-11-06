// E-GO mock driver repository.
// Returns simulated driver information.
// No real driver dispatch — demo data only.

import 'package:flutter/material.dart';

class MockDriver {
  const MockDriver({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalRides,
    required this.vehicleNumber,
    required this.vehicleName,
    required this.vehicleColor,
    required this.avatarIcon,
  });

  final String id;
  final String name;
  final double rating;
  final int totalRides;
  final String vehicleNumber;
  final String vehicleName;
  final String vehicleColor;
  final IconData avatarIcon;
}

class MockDriverRepository {
  /// Returns a simulated assigned driver.
  /// All data is demo data — no real driver is dispatched.
  Future<MockDriver> getAssignedDriver() async {
    await Future.delayed(const Duration(seconds: 2));
    return _demoBikeDriver;
  }

  Future<MockDriver> getAssignedTotoDriver() async {
    await Future.delayed(const Duration(seconds: 2));
    return _demoTotoDriver;
  }

  static const MockDriver _demoBikeDriver = MockDriver(
    id: 'driver-001',
    name: 'Rajan Kumar',
    rating: 4.8,
    totalRides: 324,
    vehicleNumber: 'WB 32 D 1234',
    vehicleName: 'Hero Splendor',
    vehicleColor: 'Black',
    avatarIcon: Icons.person,
  );

  static const MockDriver _demoTotoDriver = MockDriver(
    id: 'driver-002',
    name: 'Suresh Das',
    rating: 4.6,
    totalRides: 211,
    vehicleNumber: 'WB 32 E 5678',
    vehicleName: 'E-Rickshaw',
    vehicleColor: 'Green',
    avatarIcon: Icons.person,
  );
}
