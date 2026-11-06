import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// Domain model for location search results.
class LocationSearchResult {
  const LocationSearchResult({
    required this.id,
    required this.name,
    required this.address,
    required this.coordinate,
    this.type = PlaceType.other,
  });

  final String id;
  final String name;
  final String address;
  final LatLng coordinate;
  final PlaceType type;
}

enum PlaceType {
  market,
  transport,
  landmark,
  hospital,
  education,
  residential,
  other,
}

/// Domain model for a saved/recent location.
class SavedLocation {
  const SavedLocation({
    required this.id,
    required this.label,
    this.subtitle,
    required this.coordinate,
    this.icon,
    this.type = PlaceType.other,
    this.createdAt,
  });

  final String id;
  final String label;
  final String? subtitle;
  final LatLng coordinate;
  final IconData? icon;
  final PlaceType type;
  final DateTime? createdAt;
}

/// Domain model for current location state.
class CurrentLocationState {
  const CurrentLocationState({
    this.coordinate,
    this.accuracy,
    this.isLoading = false,
    this.error,
    this.lastUpdated,
  });

  final LatLng? coordinate;
  final double? accuracy;
  final bool isLoading;
  final String? error;
  final DateTime? lastUpdated;

  CurrentLocationState copyWith({
    LatLng? coordinate,
    double? accuracy,
    bool? isLoading,
    String? error,
    DateTime? lastUpdated,
  }) {
    return CurrentLocationState(
      coordinate: coordinate ?? this.coordinate,
      accuracy: accuracy ?? this.accuracy,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
