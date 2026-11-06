import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO driver assigned screen.
/// Shows driver profile and allows ride tracking.
class DriverAssignedScreen extends StatefulWidget {
  const DriverAssignedScreen({super.key});

  @override
  State<DriverAssignedScreen> createState() => _DriverAssignedScreenState();
}

class _DriverAssignedScreenState extends State<DriverAssignedScreen> {
  Timer? _autoAdvanceTimer;

  @override
  void initState() {
    super.initState();
    // Auto-advance to driver arriving after 3 seconds (simulated)
    _autoAdvanceTimer = Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await context.read<AppState>().driverStartsArriving();
      if (mounted) {
        Navigator.pushReplacementNamed(context, EGoRouter.rideTracking);
      }
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final driver = appState.assignedDriver;
    final vehicle = appState.selectedVehicle;

    if (driver == null) {
      return const Scaffold(body: Center(child: Text('Driver not assigned')));
    }

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Driver assigned'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showCancelDialog(context),
            tooltip: 'Cancel ride',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              child: Column(
                children: [
                  // Status card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(EGoSpacing.xl),
                    decoration: BoxDecoration(
                      color: EGoColors.brandYellow,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusXLarge,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: EGoColors.brandBlack,
                          size: 48,
                        ),
                        const SizedBox(height: EGoSpacing.md),
                        Text(
                          'Your driver is on the way!',
                          style: EGoTypography.titleLarge.copyWith(
                            color: EGoColors.brandBlack,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        Text(
                          'Arriving in ${vehicle?.fareBreakdown.estimatedArrivalMinutes ?? 3} min (demo)',
                          style: EGoTypography.bodyMedium.copyWith(
                            color: EGoColors.brandBlack.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Driver card
                  Container(
                    padding: const EdgeInsets.all(EGoSpacing.lg),
                    decoration: BoxDecoration(
                      color: EGoColors.surface,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusXLarge,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: EGoColors.mapControlShadow,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: EGoColors.brandPrimaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 36,
                                color: EGoColors.brandBlack,
                              ),
                            ),
                            const SizedBox(width: EGoSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    driver.name,
                                    style: EGoTypography.titleMedium,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Color(0xFFFBBC04),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${driver.rating}',
                                        style: EGoTypography.labelMedium,
                                      ),
                                      const SizedBox(width: EGoSpacing.sm),
                                      Text(
                                        '· ${driver.totalRides} rides',
                                        style: EGoTypography.labelSmall
                                            .copyWith(color: EGoColors.grey500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Contact buttons
                            Row(
                              children: [
                                _ContactButton(
                                  icon: Icons.call,
                                  onTap: () => _showContactDialog(
                                    context,
                                    'Call driver',
                                    'Calling ${driver.name}...',
                                  ),
                                ),
                                const SizedBox(width: EGoSpacing.sm),
                                _ContactButton(
                                  icon: Icons.chat_bubble_outline,
                                  onTap: () => _showContactDialog(
                                    context,
                                    'Message driver',
                                    'Chat with ${driver.name}',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: EGoSpacing.md,
                          ),
                          child: Divider(height: 1),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _VehicleDetail(
                                label: 'Vehicle',
                                value: driver.vehicleName,
                              ),
                            ),
                            Expanded(
                              child: _VehicleDetail(
                                label: 'Color',
                                value: driver.vehicleColor,
                              ),
                            ),
                            Expanded(
                              child: _VehicleDetail(
                                label: 'Plate',
                                value: driver.vehicleNumber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(EGoSpacing.sm),
                          decoration: BoxDecoration(
                            color: EGoColors.warningLight,
                            borderRadius: BorderRadius.circular(
                              EGoSpacing.radiusMedium,
                            ),
                          ),
                          child: Text(
                            '⚠️ Demo driver — not a real person',
                            style: EGoTypography.labelSmall.copyWith(
                              color: EGoColors.warning,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Route summary
                  Container(
                    padding: const EdgeInsets.all(EGoSpacing.lg),
                    decoration: BoxDecoration(
                      color: EGoColors.surface,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusXLarge,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: EGoColors.mapControlShadow,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your ride',
                          style: EGoTypography.titleSmall.copyWith(
                            color: EGoColors.grey600,
                          ),
                        ),
                        const SizedBox(height: EGoSpacing.md),
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 10,
                              color: EGoColors.brandSecondary,
                            ),
                            const SizedBox(width: EGoSpacing.md),
                            Expanded(
                              child: Text(
                                appState.pickupLocation?.label ??
                                    'Pickup location',
                                style: EGoTypography.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: EGoColors.brandYellow,
                            ),
                            const SizedBox(width: EGoSpacing.md),
                            Expanded(
                              child: Text(
                                appState.destinationLocation?.label ??
                                    'Destination',
                                style: EGoTypography.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom action — navigate to tracking
          Container(
            color: EGoColors.surface,
            padding: const EdgeInsets.fromLTRB(
              EGoSpacing.lg,
              EGoSpacing.lg,
              EGoSpacing.lg,
              EGoSpacing.xxl,
            ),
            child: EGoPrimaryButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await context.read<AppState>().driverStartsArriving();
                if (mounted) {
                  navigator.pushReplacementNamed(EGoRouter.rideTracking);
                }
              },
              label: 'Track driver',
              icon: const Icon(Icons.navigation, color: EGoColors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel ride?'),
        content: const Text('Are you sure you want to cancel this ride?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No, keep ride'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              navigator.pop();
              await context.read<AppState>().cancelRide();
              navigator.pushNamedAndRemoveUntil(EGoRouter.home, (_) => false);
            },
            child: Text(
              'Yes, cancel',
              style: TextStyle(color: EGoColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message (demo)'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.icon, required this.onTap});
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

class _VehicleDetail extends StatelessWidget {
  const _VehicleDetail({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: EGoTypography.labelSmall.copyWith(color: EGoColors.grey500),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: EGoTypography.labelMedium,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
