import 'package:flutter_test/flutter_test.dart';
import 'package:e_go/core/booking_state.dart';

void main() {
  group('Booking State Machine Validation', () {
    test(
      'Initial idle state allows selectingPickup and selectingDestination',
      () {
        expect(
          isValidTransition(BookingStatus.idle, BookingStatus.selectingPickup),
          isTrue,
        );
        expect(
          isValidTransition(
            BookingStatus.idle,
            BookingStatus.selectingDestination,
          ),
          isTrue,
        );
        expect(
          isValidTransition(BookingStatus.idle, BookingStatus.tripInProgress),
          isFalse,
        );
        expect(
          isValidTransition(BookingStatus.idle, BookingStatus.driverAssigned),
          isFalse,
        );
      },
    );

    test(
      'Selecting destination allows selectingVehicle or returning to idle',
      () {
        expect(
          isValidTransition(
            BookingStatus.selectingDestination,
            BookingStatus.selectingVehicle,
          ),
          isTrue,
        );
        expect(
          isValidTransition(
            BookingStatus.selectingDestination,
            BookingStatus.idle,
          ),
          isTrue,
        );
        expect(
          isValidTransition(
            BookingStatus.selectingDestination,
            BookingStatus.tripCompleted,
          ),
          isFalse,
        );
      },
    );

    test(
      'Searching driver transitions to driverAssigned, cancelled, or failed',
      () {
        expect(
          isValidTransition(
            BookingStatus.searchingDriver,
            BookingStatus.driverAssigned,
          ),
          isTrue,
        );
        expect(
          isValidTransition(
            BookingStatus.searchingDriver,
            BookingStatus.cancelled,
          ),
          isTrue,
        );
        expect(
          isValidTransition(
            BookingStatus.searchingDriver,
            BookingStatus.failed,
          ),
          isTrue,
        );
        expect(
          isValidTransition(
            BookingStatus.searchingDriver,
            BookingStatus.tripCompleted,
          ),
          isFalse,
        );
      },
    );

    test('Driver lifecycle transitions sequentially', () {
      expect(
        isValidTransition(
          BookingStatus.driverAssigned,
          BookingStatus.driverArriving,
        ),
        isTrue,
      );
      expect(
        isValidTransition(
          BookingStatus.driverArriving,
          BookingStatus.driverArrived,
        ),
        isTrue,
      );
      expect(
        isValidTransition(
          BookingStatus.driverArrived,
          BookingStatus.tripInProgress,
        ),
        isTrue,
      );
      expect(
        isValidTransition(
          BookingStatus.tripInProgress,
          BookingStatus.tripCompleted,
        ),
        isTrue,
      );
    });

    test('Cannot cancel after trip is completed', () {
      expect(
        isValidTransition(BookingStatus.tripCompleted, BookingStatus.cancelled),
        isFalse,
      );
      expect(
        isValidTransition(
          BookingStatus.awaitingRating,
          BookingStatus.cancelled,
        ),
        isFalse,
      );
      expect(
        isValidTransition(BookingStatus.rated, BookingStatus.cancelled),
        isFalse,
      );
    });

    test('Rating lifecycle transitions properly', () {
      expect(
        isValidTransition(
          BookingStatus.tripCompleted,
          BookingStatus.awaitingRating,
        ),
        isTrue,
      );
      expect(
        isValidTransition(BookingStatus.awaitingRating, BookingStatus.rated),
        isTrue,
      );
      expect(
        isValidTransition(BookingStatus.awaitingRating, BookingStatus.idle),
        isTrue,
      ); // skip rating
      expect(
        isValidTransition(BookingStatus.rated, BookingStatus.idle),
        isTrue,
      );
    });

    test('Booking status labels are non-empty and descriptive', () {
      for (final status in BookingStatus.values) {
        final label = bookingStatusLabel(status);
        expect(label, isNotEmpty);
      }
    });
  });
}
