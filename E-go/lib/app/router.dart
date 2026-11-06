import 'package:flutter/material.dart';
import 'package:e_go/features/auth/presentation/splash_screen.dart';
import 'package:e_go/features/auth/presentation/onboarding_screen.dart';
import 'package:e_go/features/auth/presentation/login_screen.dart';
import 'package:e_go/features/auth/presentation/otp_screen.dart';
import 'package:e_go/features/auth/presentation/profile_setup_screen.dart';
import 'package:e_go/features/home/presentation/home_screen.dart';
import 'package:e_go/features/location/presentation/pickup_selection_screen.dart';
import 'package:e_go/features/location/presentation/destination_selection_screen.dart';
import 'package:e_go/features/location/presentation/saved_places_screen.dart';
import 'package:e_go/features/booking/presentation/vehicle_selection_screen.dart';
import 'package:e_go/features/booking/presentation/fare_details_screen.dart';
import 'package:e_go/features/booking/presentation/booking_confirmation_screen.dart';
import 'package:e_go/features/booking/presentation/searching_driver_screen.dart';
import 'package:e_go/features/booking/presentation/driver_assigned_screen.dart';
import 'package:e_go/features/booking/presentation/ride_tracking_screen.dart';
import 'package:e_go/features/booking/presentation/trip_completed_screen.dart';
import 'package:e_go/features/booking/presentation/ride_rating_screen.dart';
import 'package:e_go/features/rides/presentation/my_rides_screen.dart';
import 'package:e_go/features/rides/presentation/ride_details_screen.dart';
import 'package:e_go/features/account/presentation/profile_screen.dart';
import 'package:e_go/features/account/presentation/edit_profile_screen.dart';
import 'package:e_go/features/account/presentation/payment_methods_screen.dart';
import 'package:e_go/features/account/presentation/settings_screen.dart';
import 'package:e_go/features/account/presentation/about_screen.dart';
import 'package:e_go/features/notifications/presentation/notifications_screen.dart';
import 'package:e_go/features/support/presentation/help_support_screen.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';

/// E-GO application router.
/// Defines all navigation routes for the complete customer application.
class EGoRouter {
  // Module A: Onboarding & Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profileSetup = '/profile-setup';

  // Module B: Home & Location
  static const String home = '/home';
  static const String pickupSelection = '/pickup-selection';
  static const String destinationSelection = '/destination-selection';
  static const String savedPlaces = '/saved-places';

  // Module C: Vehicle Selection & Booking Lifecycle
  static const String vehicleSelection = '/vehicle-selection';
  static const String fareDetails = '/fare-details';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String searchingDriver = '/searching-driver';
  static const String driverAssigned = '/driver-assigned';
  static const String rideTracking = '/ride-tracking';
  static const String tripCompleted = '/trip-completed';
  static const String rideRating = '/ride-rating';

  // Module D: Customer Account & Support
  static const String myRides = '/my-rides';
  static const String rideDetails = '/ride-details';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String paymentMethods = '/payment-methods';
  static const String notifications = '/notifications';
  static const String helpSupport = '/help-support';
  static const String settings = '/settings';
  static const String about = '/about';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Module A
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case otp:
        final phone = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpScreen(phone: phone),
          settings: settings,
        );
      case profileSetup:
        return MaterialPageRoute(
          builder: (_) => const ProfileSetupScreen(),
          settings: settings,
        );

      // Module B
      case home:
        return MaterialPageRoute(
          builder: (_) => const EGoHomeScreen(),
          settings: settings,
        );
      case pickupSelection:
        return MaterialPageRoute(
          builder: (_) => const PickupSelectionScreen(),
          settings: settings,
        );
      case destinationSelection:
        return MaterialPageRoute(
          builder: (_) => const DestinationSelectionScreen(),
          settings: settings,
        );
      case savedPlaces:
        return MaterialPageRoute(
          builder: (_) => const SavedPlacesScreen(),
          settings: settings,
        );

      // Module C
      case vehicleSelection:
        return MaterialPageRoute(
          builder: (_) => const VehicleSelectionScreen(),
          settings: settings,
        );
      case fareDetails:
        return MaterialPageRoute(
          builder: (_) => const FareDetailsScreen(),
          settings: settings,
        );
      case bookingConfirmation:
        return MaterialPageRoute(
          builder: (_) => const BookingConfirmationScreen(),
          settings: settings,
        );
      case searchingDriver:
        return MaterialPageRoute(
          builder: (_) => const SearchingDriverScreen(),
          settings: settings,
        );
      case driverAssigned:
        return MaterialPageRoute(
          builder: (_) => const DriverAssignedScreen(),
          settings: settings,
        );
      case rideTracking:
        return MaterialPageRoute(
          builder: (_) => const RideTrackingScreen(),
          settings: settings,
        );
      case tripCompleted:
        return MaterialPageRoute(
          builder: (_) => const TripCompletedScreen(),
          settings: settings,
        );
      case rideRating:
        return MaterialPageRoute(
          builder: (_) => const RideRatingScreen(),
          settings: settings,
        );

      // Module D
      case myRides:
        return MaterialPageRoute(
          builder: (_) => const MyRidesScreen(),
          settings: settings,
        );
      case rideDetails:
        final ride = settings.arguments as RideRecord;
        return MaterialPageRoute(
          builder: (_) => RideDetailsScreen(ride: ride),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
          settings: settings,
        );
      case paymentMethods:
        return MaterialPageRoute(
          builder: (_) => const PaymentMethodsScreen(),
          settings: settings,
        );
      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );
      case helpSupport:
        return MaterialPageRoute(
          builder: (_) => const HelpSupportScreen(),
          settings: settings,
        );
      case EGoRouter.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
          settings: settings,
        );
      case about:
        return MaterialPageRoute(
          builder: (_) => const AboutScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}
