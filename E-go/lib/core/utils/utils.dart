/// General utilities for E-GO.
class EGoUtils {
  EGoUtils._();

  /// Formats a phone number for display (e.g. +91 98765 43210).
  static String formatPhone(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      return '+91 ${cleaned.substring(0, 5)} ${cleaned.substring(5)}';
    }
    return raw;
  }

  /// Calculates estimated travel time in minutes based on distance in km and average speed.
  static int estimateDurationMinutes(
    double distanceKm, {
    double avgSpeedKmh = 18.0,
  }) {
    if (distanceKm <= 0) return 3;
    final hours = distanceKm / avgSpeedKmh;
    final mins = (hours * 60).ceil();
    return mins < 3 ? 3 : mins;
  }
}
