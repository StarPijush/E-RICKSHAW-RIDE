// E-GO mock booking repository.
// Stores completed and active booking records locally.
// Replace with real API in production.

import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/features/booking/data/driver_repository.dart';

enum RideStatus { upcoming, active, completed, cancelled }

enum PaymentMethod { cash, upi }

class RideRecord {
  const RideRecord({
    required this.id,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.vehicleType,
    required this.fareBreakdown,
    required this.driver,
    required this.status,
    required this.bookedAt,
    this.completedAt,
    this.rating,
    this.ratingComment,
    this.paymentMethod = PaymentMethod.cash,
    this.tripId,
  });

  final String id;
  final SavedLocation pickupLocation;
  final SavedLocation destinationLocation;
  final VehicleType vehicleType;
  final FareBreakdown fareBreakdown;
  final MockDriver driver;
  final RideStatus status;
  final DateTime bookedAt;
  final DateTime? completedAt;
  final int? rating; // 1-5
  final String? ratingComment;
  final PaymentMethod paymentMethod;
  final String? tripId;

  String get vehicleName {
    switch (vehicleType) {
      case VehicleType.bike:
        return 'Bike';
      case VehicleType.toto:
        return 'Toto (E-Rickshaw)';
    }
  }

  RideRecord copyWith({
    String? id,
    SavedLocation? pickupLocation,
    SavedLocation? destinationLocation,
    VehicleType? vehicleType,
    FareBreakdown? fareBreakdown,
    MockDriver? driver,
    RideStatus? status,
    DateTime? bookedAt,
    DateTime? completedAt,
    int? rating,
    String? ratingComment,
    PaymentMethod? paymentMethod,
    String? tripId,
  }) {
    return RideRecord(
      id: id ?? this.id,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      vehicleType: vehicleType ?? this.vehicleType,
      fareBreakdown: fareBreakdown ?? this.fareBreakdown,
      driver: driver ?? this.driver,
      status: status ?? this.status,
      bookedAt: bookedAt ?? this.bookedAt,
      completedAt: completedAt ?? this.completedAt,
      rating: rating ?? this.rating,
      ratingComment: ratingComment ?? this.ratingComment,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tripId: tripId ?? this.tripId,
    );
  }
}

class MockBookingRepository {
  final List<RideRecord> _rides = [..._seedRides];

  List<RideRecord> getAllRides() => List.unmodifiable(_rides);

  List<RideRecord> getCompletedRides() =>
      _rides.where((r) => r.status == RideStatus.completed).toList();

  List<RideRecord> getCancelledRides() =>
      _rides.where((r) => r.status == RideStatus.cancelled).toList();

  RideRecord? getRideById(String id) {
    try {
      return _rides.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void addRide(RideRecord ride) {
    _rides.insert(0, ride);
  }

  void updateRide(RideRecord updated) {
    final index = _rides.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      _rides[index] = updated;
    }
  }

  static String generateId() {
    return 'EGO-${DateTime.now().millisecondsSinceEpoch}';
  }

  static final List<RideRecord> _seedRides = [];
}
