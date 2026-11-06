import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO booking confirmation screen.
/// Shows full ride summary before confirming.
class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final vehicle = appState.selectedVehicle;
    final pickup = appState.pickupLocation;
    final dest = appState.destinationLocation;

    if (vehicle == null || pickup == null || dest == null) {
      return const Scaffold(body: Center(child: Text('Booking data missing')));
    }

    final fare = vehicle.fareBreakdown;

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Confirm booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(EGoSpacing.lg),
              child: Column(
                children: [
                  // Vehicle + route
                  _InfoCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: EGoColors.brandYellowLight,
                                borderRadius: BorderRadius.circular(
                                  EGoSpacing.radiusMedium,
                                ),
                              ),
                              child: Center(
                                child: vehicle.type == VehicleType.toto
                                    ? const EgoLogo.icon(height: 24)
                                    : Icon(
                                        vehicle.iconData,
                                        size: 26,
                                        color: EGoColors.brandBlack,
                                      ),
                              ),
                            ),
                            const SizedBox(width: EGoSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    vehicle.name,
                                    style: EGoTypography.titleMedium,
                                  ),
                                  Text(
                                    '${fare.estimatedMinutes} min · ${fare.distanceKm} km',
                                    style: EGoTypography.bodySmall.copyWith(
                                      color: EGoColors.grey500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${fare.totalFare.toStringAsFixed(0)}',
                              style: EGoTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: EGoSpacing.md,
                          ),
                          child: Divider(height: 1),
                        ),
                        // Pickup
                        _LocationRow(
                          icon: Icons.circle,
                          iconColor: EGoColors.brandSecondary,
                          iconSize: 10,
                          label: 'Pickup',
                          name: pickup.label,
                          subtitle: pickup.subtitle,
                        ),
                        const SizedBox(height: EGoSpacing.md),
                        // Dest
                        _LocationRow(
                          icon: Icons.location_on,
                          iconColor: EGoColors.brandPrimary,
                          iconSize: 16,
                          label: 'Destination',
                          name: dest.label,
                          subtitle: dest.subtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Payment
                  _InfoCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          color: EGoColors.grey600,
                        ),
                        const SizedBox(width: EGoSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment',
                                style: EGoTypography.labelMedium.copyWith(
                                  color: EGoColors.grey600,
                                ),
                              ),
                              Text(
                                appState.paymentMethod == PaymentMethod.cash
                                    ? 'Cash'
                                    : 'UPI',
                                style: EGoTypography.titleSmall,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            EGoRouter.paymentMethods,
                          ),
                          child: const Text('Change'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Fare summary
                  _InfoCard(
                    child: Column(
                      children: [
                        _FareRow(
                          'Base fare',
                          '₹${fare.baseFare.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        _FareRow(
                          'Distance fare',
                          '₹${fare.distanceFare.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        _FareRow(
                          'Platform fee',
                          '₹${fare.platformFee.toStringAsFixed(0)}',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: EGoSpacing.sm,
                          ),
                          child: Divider(height: 1),
                        ),
                        _FareRow(
                          'Total',
                          '₹${fare.totalFare.toStringAsFixed(0)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Demo notice
                  Container(
                    padding: const EdgeInsets.all(EGoSpacing.md),
                    decoration: BoxDecoration(
                      color: EGoColors.warningLight,
                      borderRadius: BorderRadius.circular(
                        EGoSpacing.radiusLarge,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: EGoColors.warning,
                        ),
                        const SizedBox(width: EGoSpacing.sm),
                        Expanded(
                          child: Text(
                            'Demo mode: No real driver will be dispatched.',
                            style: EGoTypography.bodySmall.copyWith(
                              color: EGoColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Confirm button
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
                // Start booking search
                Navigator.pushNamed(context, EGoRouter.searchingDriver);
                await appState.confirmBooking();
              },
              label: 'Confirm booking',
              icon: const Icon(Icons.check, color: EGoColors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(EGoSpacing.lg),
      decoration: BoxDecoration(
        color: EGoColors.surface,
        borderRadius: BorderRadius.circular(EGoSpacing.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: EGoColors.mapControlShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.label,
    required this.name,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String label;
  final String name;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor),
        const SizedBox(width: EGoSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: EGoTypography.labelSmall.copyWith(
                  color: EGoColors.grey500,
                ),
              ),
              Text(
                name,
                style: EGoTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: EGoTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow(this.label, this.value, {this.isBold = false});
  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? EGoTypography.titleSmall
              : EGoTypography.bodyMedium.copyWith(color: EGoColors.grey700),
        ),
        Text(
          value,
          style: isBold
              ? EGoTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)
              : EGoTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
