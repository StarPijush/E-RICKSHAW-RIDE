/// E-GO domain and application exceptions.
abstract class EGoException implements Exception {
  const EGoException(this.message, [this.code]);
  final String message;
  final String? code;

  @override
  String toString() => 'EGoException: $message (code: $code)';
}

class LocationException extends EGoException {
  const LocationException(super.message, [super.code]);
}

class BookingException extends EGoException {
  const BookingException(super.message, [super.code]);
}

class NetworkException extends EGoException {
  const NetworkException(super.message, [super.code]);
}

class AuthException extends EGoException {
  const AuthException(super.message, [super.code]);
}
