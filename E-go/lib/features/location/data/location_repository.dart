import 'package:latlong2/latlong.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/mock_data/mock_data.dart';

/// Location data repository.
/// Uses mock data for development. Replace with real API integration.
class LocationRepository {
  Future<List<LocationSearchResult>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network

    if (query.trim().isEmpty) {
      return MockData.suggestedPlaces
          .map(
            (p) => LocationSearchResult(
              id: p.id,
              name: p.name,
              address: p.address,
              coordinate: p.coordinate,
              type: p.type,
            ),
          )
          .toList();
    }

    final lowercaseQuery = query.toLowerCase();
    return MockData.suggestedPlaces
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowercaseQuery) ||
              p.address.toLowerCase().contains(lowercaseQuery),
        )
        .map(
          (p) => LocationSearchResult(
            id: p.id,
            name: p.name,
            address: p.address,
            coordinate: p.coordinate,
            type: p.type,
          ),
        )
        .toList();
  }

  Future<List<SavedLocation>> getRecentDestinations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return MockData.recentDestinations
        .map(
          (r) => SavedLocation(
            id: r.id,
            label: r.label,
            subtitle: r.subtitle,
            coordinate: r.coordinate,
            icon: r.icon,
            type: r.type,
          ),
        )
        .toList();
  }

  Future<LatLng?> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.mockCurrentLocation;
  }

  Future<void> saveRecentDestination(SavedLocation location) async {
    // TODO: Persist to local storage
    await Future.delayed(const Duration(milliseconds: 50));
  }
}
