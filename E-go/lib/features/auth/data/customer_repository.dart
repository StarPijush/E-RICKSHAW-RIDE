// E-GO mock customer repository.
// Handles customer profile read/write for demo purposes.
// Uses shared_preferences for local persistence.
// Replace with real API in production.

import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.isProfileComplete = false,
    this.hasCompletedOnboarding = false,
  });

  final String id;
  final String name;
  final String phone;
  final String? email;
  final bool isProfileComplete;
  final bool hasCompletedOnboarding;

  CustomerProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    bool? isProfileComplete,
    bool? hasCompletedOnboarding,
  }) {
    return CustomerProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  static const CustomerProfile empty = CustomerProfile(
    id: '',
    name: '',
    phone: '',
  );
}

class MockCustomerRepository {
  static const _keyName = 'ego_customer_name';
  static const _keyPhone = 'ego_customer_phone';
  static const _keyEmail = 'ego_customer_email';
  static const _keyOnboarded = 'ego_onboarding_complete';
  static const _keyProfileComplete = 'ego_profile_complete';

  Future<CustomerProfile> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return CustomerProfile(
      id: 'demo-user-001',
      name: prefs.getString(_keyName) ?? '',
      phone: prefs.getString(_keyPhone) ?? '',
      email: prefs.getString(_keyEmail),
      isProfileComplete: prefs.getBool(_keyProfileComplete) ?? false,
      hasCompletedOnboarding: prefs.getBool(_keyOnboarded) ?? false,
    );
  }

  Future<void> saveProfile(CustomerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, profile.name);
    await prefs.setString(_keyPhone, profile.phone);
    if (profile.email != null) {
      await prefs.setString(_keyEmail, profile.email!);
    }
    await prefs.setBool(_keyProfileComplete, profile.isProfileComplete);
  }

  Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboarded, true);
  }

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboarded) ?? false;
  }

  /// Demo OTP validation.
  /// Development mock only — not real SMS delivery.
  static const String devMockOtp = '123456';

  bool validateOtp(String otp) => otp == devMockOtp;
}
