/// E-GO core constants and design tokens.
class EGoConstants {
  EGoConstants._();

  static const String appName = 'E-GO';
  static const String appTagline = 'Move your way.';
  static const String defaultCity = 'Jhargram, West Bengal';

  // Geometry
  static const double minTouchTarget = 48.0;
  static const double recenterButtonSize = 56.0;
  static const double primaryButtonHeight = 54.0;
  static const double inputFieldHeight = 54.0;
  static const double bottomNavHeight = 64.0;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration standardAnimation = Duration(milliseconds: 250);
  static const Duration longAnimation = Duration(milliseconds: 400);

  // Default Coordinates (Jhargram Railway Station)
  static const double defaultLatitude = 22.4511;
  static const double defaultLongitude = 86.9942;
}
