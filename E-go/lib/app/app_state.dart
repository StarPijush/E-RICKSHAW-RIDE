// E-GO application state.
// Central ChangeNotifier for booking lifecycle and app-level state.
// Implements the booking state machine with validated transitions.

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_go/core/booking_state.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/auth/data/customer_repository.dart';
import 'package:e_go/features/booking/data/vehicle_repository.dart';
import 'package:e_go/features/booking/data/driver_repository.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/features/notifications/data/notification_repository.dart';

class AppState extends ChangeNotifier {
  AppState() {
    _init();
  }

  // Repositories
  final MockCustomerRepository _customerRepo = MockCustomerRepository();
  final MockVehicleRepository _vehicleRepo = MockVehicleRepository();
  final MockDriverRepository _driverRepo = MockDriverRepository();
  final MockBookingRepository _bookingRepo = MockBookingRepository();
  final MockNotificationRepository _notificationRepo =
      MockNotificationRepository();

  // ── Auth state ──────────────────────────────────────────────────────────
  CustomerProfile _profile = CustomerProfile.empty;
  bool _isAuthInitialized = false;
  bool _isLoading = false;
  String? _error;

  CustomerProfile get profile => _profile;
  bool get isAuthInitialized => _isAuthInitialized;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn =>
      _profile.phone.isNotEmpty && _profile.isProfileComplete;
  bool get hasCompletedOnboarding => _profile.hasCompletedOnboarding;

  // ── Booking state machine ───────────────────────────────────────────────
  BookingStatus _bookingStatus = BookingStatus.idle;
  SavedLocation? _pickupLocation;
  SavedLocation? _destinationLocation;
  VehicleOption? _selectedVehicle;
  List<VehicleOption> _availableVehicles = [];
  MockDriver? _assignedDriver;
  RideRecord? _currentRide;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  bool _vehiclesLoading = false;

  BookingStatus get bookingStatus => _bookingStatus;
  SavedLocation? get pickupLocation => _pickupLocation;
  SavedLocation? get destinationLocation => _destinationLocation;
  VehicleOption? get selectedVehicle => _selectedVehicle;
  List<VehicleOption> get availableVehicles => _availableVehicles;
  MockDriver? get assignedDriver => _assignedDriver;
  RideRecord? get currentRide => _currentRide;
  PaymentMethod get paymentMethod => _paymentMethod;
  bool get vehiclesLoading => _vehiclesLoading;

  // ── Rides ───────────────────────────────────────────────────────────────
  MockBookingRepository get bookingRepository => _bookingRepo;
  List<RideRecord> get allRides => _bookingRepo.getAllRides();
  List<RideRecord> get completedRides => _bookingRepo.getCompletedRides();

  // ── Notifications ───────────────────────────────────────────────────────
  List<AppNotification> get notifications => _notificationRepo.getAll();
  int get unreadNotificationCount => _notificationRepo.unreadCount;

  // ── Init ─────────────────────────────────────────────────────────────────
  Future<void> _init() async {
    _profile = await _customerRepo.getProfile();
    _isAuthInitialized = true;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // ── Auth ─────────────────────────────────────────────────────────────────
  Future<bool> submitPhone(String phone) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 800));
    _profile = _profile.copyWith(phone: '+91$phone');
    _setLoading(false);
    return true;
  }

  /// Validates the demo OTP.
  /// Development mock only — not real SMS.
  bool validateOtp(String otp) {
    return _customerRepo.validateOtp(otp);
  }

  Future<void> completeProfileSetup({
    required String name,
    String? email,
  }) async {
    _setLoading(true);
    final updated = _profile.copyWith(
      name: name,
      email: email,
      isProfileComplete: true,
      hasCompletedOnboarding: true,
    );
    await _customerRepo.saveProfile(updated);
    _profile = updated;
    _setLoading(false);
  }

  Future<void> updateProfile({required String name, String? email}) async {
    _setLoading(true);
    final updated = _profile.copyWith(name: name, email: email);
    await _customerRepo.saveProfile(updated);
    _profile = updated;
    _setLoading(false);
  }

  Future<void> markOnboardingComplete() async {
    await _customerRepo.markOnboardingComplete();
    _profile = _profile.copyWith(hasCompletedOnboarding: true);
    notifyListeners();
  }

  Future<void> logout() async {
    await _clearPrefs();
    _profile = CustomerProfile.empty;
    _resetBooking();
    notifyListeners();
  }

  // ── Booking state machine ─────────────────────────────────────────────────
  bool _transition(BookingStatus to) {
    if (!isValidTransition(_bookingStatus, to)) {
      debugPrint('Invalid transition: $_bookingStatus → $to');
      return false;
    }
    _bookingStatus = to;
    notifyListeners();
    return true;
  }

  void setPickupLocation(SavedLocation location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void setDestinationLocation(SavedLocation location) {
    _destinationLocation = location;
    notifyListeners();
  }

  Future<void> loadVehicles() async {
    if (_pickupLocation == null || _destinationLocation == null) return;
    _vehiclesLoading = true;
    notifyListeners();
    try {
      _availableVehicles = await _vehicleRepo.getAvailableVehicles(
        from: _pickupLocation!.coordinate,
        to: _destinationLocation!.coordinate,
      );
    } catch (_) {
      _availableVehicles = [];
    } finally {
      _vehiclesLoading = false;
      notifyListeners();
    }
  }

  void selectVehicle(VehicleOption vehicle) {
    _selectedVehicle = vehicle;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void startSelectingPickup() => _transition(BookingStatus.selectingPickup);
  void startSelectingDestination() =>
      _transition(BookingStatus.selectingDestination);

  Future<void> proceedToVehicleSelection() async {
    if (_transition(BookingStatus.selectingVehicle)) {
      await loadVehicles();
    }
  }

  void proceedToFareReview() => _transition(BookingStatus.reviewingFare);
  void proceedToConfirmation() => _transition(BookingStatus.confirmingBooking);

  /// Starts the driver search simulation.
  Future<void> confirmBooking() async {
    if (!_transition(BookingStatus.searchingDriver)) return;

    // Simulate search delay (3-5 seconds)
    await Future.delayed(const Duration(seconds: 4));

    if (_bookingStatus != BookingStatus.searchingDriver) return; // Cancelled

    final vehicle = _selectedVehicle!;
    final driver = vehicle.type == VehicleType.bike
        ? await _driverRepo.getAssignedDriver()
        : await _driverRepo.getAssignedTotoDriver();

    _assignedDriver = driver;

    final rideId = MockBookingRepository.generateId();
    _currentRide = RideRecord(
      id: rideId,
      pickupLocation: _pickupLocation!,
      destinationLocation: _destinationLocation!,
      vehicleType: vehicle.type,
      fareBreakdown: vehicle.fareBreakdown,
      driver: driver,
      status: RideStatus.active,
      bookedAt: DateTime.now(),
      paymentMethod: _paymentMethod,
      tripId: rideId,
    );
    _bookingRepo.addRide(_currentRide!);

    _transition(BookingStatus.driverAssigned);
  }

  Future<void> driverStartsArriving() async {
    _transition(BookingStatus.driverArriving);
  }

  Future<void> driverArrived() async {
    _transition(BookingStatus.driverArrived);
  }

  Future<void> startTrip() async {
    _transition(BookingStatus.tripInProgress);
  }

  Future<void> completeTrip() async {
    if (_currentRide != null) {
      final completed = _currentRide!.copyWith(
        status: RideStatus.completed,
        completedAt: DateTime.now(),
      );
      _bookingRepo.updateRide(completed);
      _currentRide = completed;
    }
    _transition(BookingStatus.tripCompleted);
    await Future.delayed(const Duration(milliseconds: 500));
    _transition(BookingStatus.awaitingRating);
  }

  Future<void> submitRating({required int rating, String? comment}) async {
    if (_currentRide != null) {
      final rated = _currentRide!.copyWith(
        rating: rating,
        ratingComment: comment,
      );
      _bookingRepo.updateRide(rated);
      _currentRide = rated;
    }
    _transition(BookingStatus.rated);
  }

  void skipRating() => _transition(BookingStatus.idle);

  Future<void> cancelRide({String? reason}) async {
    if (_currentRide != null) {
      final cancelled = _currentRide!.copyWith(
        status: RideStatus.cancelled,
        completedAt: DateTime.now(),
      );
      _bookingRepo.updateRide(cancelled);
      _currentRide = cancelled;
    }
    _transition(BookingStatus.cancelled);
    await Future.delayed(const Duration(milliseconds: 300));
    _transition(BookingStatus.idle);
    _resetBooking();
  }

  void handleSearchFailure() {
    _transition(BookingStatus.failed);
  }

  void retrySearch() {
    _transition(BookingStatus.searchingDriver);
    confirmBooking();
  }

  void resetToIdle() {
    _resetBooking();
    _bookingStatus = BookingStatus.idle;
    notifyListeners();
  }

  void _resetBooking() {
    _pickupLocation = null;
    _destinationLocation = null;
    _selectedVehicle = null;
    _availableVehicles = [];
    _assignedDriver = null;
    _currentRide = null;
  }

  // ── Notifications ─────────────────────────────────────────────────────────
  void markNotificationRead(String id) {
    _notificationRepo.markRead(id);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    _notificationRepo.markAllRead();
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
