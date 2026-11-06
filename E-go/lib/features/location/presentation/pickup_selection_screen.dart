import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/location/data/location_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/features/location/presentation/location_search_delegate.dart';
import 'package:e_go/mock_data/mock_data.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO pickup location selection screen.
/// Allows map-based pin adjustment, current location pick, or searching.
class PickupSelectionScreen extends StatefulWidget {
  const PickupSelectionScreen({super.key});

  @override
  State<PickupSelectionScreen> createState() => _PickupSelectionScreenState();
}

class _PickupSelectionScreenState extends State<PickupSelectionScreen> {
  final MapController _mapController = MapController();
  final LocationRepository _locationRepo = LocationRepository();

  LatLng _centerCoordinate = MockData.mockCurrentLocation;
  String _addressTitle = 'Jhargram Station Road';
  String _addressSubtitle = 'Near Railway Station, Jhargram';
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    final currentPickup = context.read<AppState>().pickupLocation;
    if (currentPickup != null) {
      _centerCoordinate = currentPickup.coordinate;
      _addressTitle = currentPickup.label;
      _addressSubtitle = currentPickup.subtitle ?? 'Jhargram';
    }
  }

  void _onMapPositionChanged(MapCamera camera, bool hasGesture) {
    if (hasGesture) {
      setState(() {
        _centerCoordinate = camera.center;
        _addressTitle = 'Pinned Pickup Point';
        _addressSubtitle =
            '${camera.center.latitude.toStringAsFixed(4)}, ${camera.center.longitude.toStringAsFixed(4)} (Jhargram)';
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    final loc = await _locationRepo.getCurrentLocation();
    if (mounted) {
      setState(() {
        _isLocating = false;
        if (loc != null) {
          _centerCoordinate = loc;
          _addressTitle = 'Current Location';
          _addressSubtitle = 'Jhargram Station Area';
          _mapController.move(loc, 16.0);
        }
      });
    }
  }

  Future<void> _openSearch() async {
    final result = await showSearch<LocationSearchResult?>(
      context: context,
      delegate: EGoLocationSearchDelegate(repository: _locationRepo),
    );

    if (result != null && mounted) {
      setState(() {
        _centerCoordinate = result.coordinate;
        _addressTitle = result.name;
        _addressSubtitle = result.address;
        _mapController.move(result.coordinate, 16.0);
      });
    }
  }

  void _confirmPickup() {
    final location = SavedLocation(
      id: 'pickup-${DateTime.now().millisecondsSinceEpoch}',
      label: _addressTitle,
      subtitle: _addressSubtitle,
      coordinate: _centerCoordinate,
      icon: Icons.my_location,
      type: PlaceType.other,
    );

    context.read<AppState>().setPickupLocation(location);
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EGoColors.surface,
      appBar: AppBar(
        title: const Text('Set pickup point'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search pickup location',
            onPressed: _openSearch,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centerCoordinate,
              initialZoom: 16.0,
              onPositionChanged: _onMapPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ego.customer',
              ),
            ],
          ),

          // Static Center Pin Marker
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 36.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: EGoSpacing.md,
                      vertical: EGoSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: EGoColors.grey900,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusMedium,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Pickup point',
                      style: EGoTypography.labelSmall.copyWith(
                        color: EGoColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.location_pin,
                    size: 42,
                    color: EGoColors.brandYellow,
                  ),
                ],
              ),
            ),
          ),

          // Recenter / Current location button
          Positioned(
            right: EGoSpacing.lg,
            bottom: 180,
            child: FloatingActionButton.small(
              backgroundColor: EGoColors.white,
              foregroundColor: EGoColors.brandPrimary,
              elevation: 4,
              onPressed: _isLocating ? null : _useCurrentLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          // Bottom card with address & confirm
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(
                EGoSpacing.lg,
                EGoSpacing.lg,
                EGoSpacing.lg,
                EGoSpacing.xxl,
              ),
              decoration: const BoxDecoration(
                color: EGoColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(EGoSpacing.radiusXLarge),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(EGoSpacing.sm),
                        decoration: BoxDecoration(
                          color: EGoColors.brandYellow.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.circle,
                          size: 14,
                          color: EGoColors.brandYellow,
                        ),
                      ),
                      const SizedBox(width: EGoSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _addressTitle,
                              style: EGoTypography.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              _addressSubtitle,
                              style: EGoTypography.bodySmall.copyWith(
                                color: EGoColors.grey500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _openSearch,
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Change'),
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  EGoPrimaryButton(
                    onPressed: _confirmPickup,
                    label: 'Confirm pickup location',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
