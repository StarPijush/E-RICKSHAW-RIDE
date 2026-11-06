// E-GO booking state machine.
// Defines the complete lifecycle of a ride booking.
// All transitions are validated — invalid transitions are rejected.

enum BookingStatus {
  idle,
  selectingPickup,
  selectingDestination,
  selectingVehicle,
  reviewingFare,
  confirmingBooking,
  searchingDriver,
  driverAssigned,
  driverArriving,
  driverArrived,
  tripInProgress,
  tripCompleted,
  awaitingRating,
  rated,
  cancelled,
  failed,
}

/// Allowed transitions from each state.
const _allowedTransitions = <BookingStatus, Set<BookingStatus>>{
  BookingStatus.idle: {
    BookingStatus.selectingPickup,
    BookingStatus.selectingDestination,
    BookingStatus.selectingVehicle,
  },
  BookingStatus.selectingPickup: {
    BookingStatus.idle,
    BookingStatus.selectingDestination,
    BookingStatus.selectingVehicle,
  },
  BookingStatus.selectingDestination: {
    BookingStatus.idle,
    BookingStatus.selectingPickup,
    BookingStatus.selectingVehicle,
  },
  BookingStatus.selectingVehicle: {
    BookingStatus.selectingDestination,
    BookingStatus.reviewingFare,
    BookingStatus.confirmingBooking,
    BookingStatus.idle,
  },
  BookingStatus.reviewingFare: {
    BookingStatus.selectingVehicle,
    BookingStatus.confirmingBooking,
    BookingStatus.idle,
  },
  BookingStatus.confirmingBooking: {
    BookingStatus.reviewingFare,
    BookingStatus.searchingDriver,
    BookingStatus.idle,
  },
  BookingStatus.searchingDriver: {
    BookingStatus.driverAssigned,
    BookingStatus.failed,
    BookingStatus.cancelled,
    BookingStatus.idle,
  },
  BookingStatus.driverAssigned: {
    BookingStatus.driverArriving,
    BookingStatus.cancelled,
  },
  BookingStatus.driverArriving: {
    BookingStatus.driverArrived,
    BookingStatus.cancelled,
  },
  BookingStatus.driverArrived: {
    BookingStatus.tripInProgress,
    BookingStatus.cancelled,
  },
  BookingStatus.tripInProgress: {BookingStatus.tripCompleted},
  BookingStatus.tripCompleted: {BookingStatus.awaitingRating},
  BookingStatus.awaitingRating: {
    BookingStatus.rated,
    BookingStatus.idle, // skip rating
  },
  BookingStatus.rated: {BookingStatus.idle},
  BookingStatus.cancelled: {BookingStatus.idle},
  BookingStatus.failed: {
    BookingStatus.idle,
    BookingStatus.searchingDriver, // retry
  },
};

/// Returns true if the transition from [from] to [to] is valid.
bool isValidTransition(BookingStatus from, BookingStatus to) {
  return _allowedTransitions[from]?.contains(to) ?? false;
}

/// Human-readable label for each booking status.
String bookingStatusLabel(BookingStatus status) {
  switch (status) {
    case BookingStatus.idle:
      return 'Ready';
    case BookingStatus.selectingPickup:
      return 'Select pickup';
    case BookingStatus.selectingDestination:
      return 'Select destination';
    case BookingStatus.selectingVehicle:
      return 'Choose vehicle';
    case BookingStatus.reviewingFare:
      return 'Review fare';
    case BookingStatus.confirmingBooking:
      return 'Confirm booking';
    case BookingStatus.searchingDriver:
      return 'Finding driver';
    case BookingStatus.driverAssigned:
      return 'Driver assigned';
    case BookingStatus.driverArriving:
      return 'Driver arriving';
    case BookingStatus.driverArrived:
      return 'Driver arrived';
    case BookingStatus.tripInProgress:
      return 'Trip in progress';
    case BookingStatus.tripCompleted:
      return 'Trip completed';
    case BookingStatus.awaitingRating:
      return 'Rate your ride';
    case BookingStatus.rated:
      return 'Rated';
    case BookingStatus.cancelled:
      return 'Cancelled';
    case BookingStatus.failed:
      return 'Search failed';
  }
}
