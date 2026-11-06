import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/mock_data/mock_data.dart';
import 'package:e_go/shared/widgets/location_components.dart';

/// E-GO ride tracking screen.
/// Shows simulated driver movement on map.
class RideTrackingScreen extends StatefulWidget {
  const RideTrackingScreen({super.key});

  @override
  State<RideTrackingScreen> createState() => _RideTrackingScreenState();
}

class _RideTrackingScreenState extends State<RideTrackingScreen> {
  final MapController _mapController = MapController();
  Timer? _tripTimer;
  int _tripProgress = 0; // 0-100
  bool _driverArrived = false;
  bool _tripStarted = false;
  LatLng _driverPosition = MockData.mockCurrentLocation;

  @override
  void initState() {
    super.initState();
    _simulateDriverMovement();
  }

  void _simulateDriverMovement() {
    final appState = context.read<AppState>();
    final pickup =
        appState.pickupLocation?.coordinate ?? MockData.mockCurrentLocation;
    final dest =
        appState.destinationLocation?.coordinate ?? MockData.jhargramCenter;

    // Phase 1: Driver approaches pickup (0-40%)
    // Phase 2: Trip in progress (40-100%)
    _tripTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _tripProgress = (_tripProgress + 5).clamp(0, 100);

        if (_tripProgress <= 40) {
          // Move driver toward pickup
          final t = _tripProgress / 40;
          _driverPosition = LatLng(
            MockData.mockCurrentLocation.latitude +
                (pickup.latitude - MockData.mockCurrentLocation.latitude) * t,
            MockData.mockCurrentLocation.longitude +
                (pickup.longitude - MockData.mockCurrentLocation.longitude) * t,
          );
        } else if (_tripProgress == 45 && !_driverArrived) {
          _driverArrived = true;
          appState.driverArrived();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Driver has arrived at pickup!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (_tripProgress == 50 && !_tripStarted) {
          _tripStarted = true;
          appState.startTrip();
        } else if (_tripProgress > 50) {
          // Move driver toward destination
          final t = (_tripProgress - 50) / 50;
          _driverPosition = LatLng(
            pickup.latitude + (dest.latitude - pickup.latitude) * t,
            pickup.longitude + (dest.longitude - pickup.longitude) * t,
          );
        }

        if (_tripProgress >= 100) {
          timer.cancel();
          _completeTrip();
        }
      });
    });
  }

  Future<void> _completeTrip() async {
    await context.read<AppState>().completeTrip();
    if (mounted) {
      Navigator.pushReplacementNamed(context, EGoRouter.tripCompleted);
    }
  }

  @override
  void dispose() {
    _tripTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pickup =
        appState.pickupLocation?.coordinate ?? MockData.mockCurrentLocation;
    final dest =
        appState.destinationLocation?.coordinate ?? MockData.jhargramCenter;
    final driver = appState.assignedDriver;
    final vehicle = appState.selectedVehicle;

    final statusText = !_driverArrived
        ? 'Driver arriving...'
        : !_tripStarted
        ? 'Driver arrived'
        : 'Trip in progress';

    return Scaffold(
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: pickup, initialZoom: 14.5),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ego.customer',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pickup,
                    width: 32,
                    height: 32,
                    child: const Icon(
                      Icons.circle,
                      color: EGoColors.brandSecondary,
                      size: 24,
                    ),
                  ),
                  Marker(
                    point: dest,
                    width: 40,
                    height: 40,
                    child: const EGoDestinationMarker(size: 36),
                  ),
                  Marker(
                    point: _driverPosition,
                    width: 40,
                    height: 40,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: EGoColors.brandYellow,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: vehicle?.type == VehicleType.toto
                            ? const EgoLogo.icon(height: 20)
                            : Icon(
                                vehicle?.iconData ?? Icons.two_wheeler,
                                color: EGoColors.brandBlack,
                                size: 22,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Status bar at top
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: EGoSpacing.lg,
                        vertical: EGoSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: EGoColors.surface,
                        borderRadius: BorderRadius.circular(
                          EGoSpacing.radiusPill,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: EGoColors.mapControlShadow,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        statusText,
                        style: EGoTypography.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom driver panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: EGoColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(EGoSpacing.radiusXLarge),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(
                EGoSpacing.lg,
                EGoSpacing.lg,
                EGoSpacing.lg,
                EGoSpacing.xxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: EGoColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Progress bar
                  LinearProgressIndicator(
                    value: _tripProgress / 100,
                    backgroundColor: EGoColors.grey200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      EGoColors.brandPrimary,
                    ),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  // Driver info
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: EGoColors.brandPrimaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person,
                          color: EGoColors.brandPrimary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: EGoSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver?.name ?? 'Your driver',
                              style: EGoTypography.titleSmall,
                            ),
                            Text(
                              driver?.vehicleNumber ?? '',
                              style: EGoTypography.bodySmall.copyWith(
                                color: EGoColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          _TrackingActionButton(
                            icon: Icons.call,
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Call driver (demo)'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                ),
                          ),
                          const SizedBox(width: EGoSpacing.sm),
                          _TrackingActionButton(
                            icon: Icons.chat_bubble_outline,
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Chat with driver (demo)'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  // Destination reminder
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: EGoColors.brandPrimary,
                      ),
                      const SizedBox(width: EGoSpacing.sm),
                      Expanded(
                        child: Text(
                          appState.destinationLocation?.label ?? 'Destination',
                          style: EGoTypography.bodySmall.copyWith(
                            color: EGoColors.grey700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '₹${vehicle?.fareBreakdown.totalFare.toStringAsFixed(0) ?? '—'}',
                        style: EGoTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
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

class _TrackingActionButton extends StatelessWidget {
  const _TrackingActionButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: EGoColors.brandPrimaryLight,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: EGoColors.brandPrimary, size: 20),
      ),
    );
  }
}
