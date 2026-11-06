import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/shared/widgets/buttons.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';

/// E-GO fare details screen.
/// Shows the full fare breakdown for the selected vehicle and route.
class FareDetailsScreen extends StatelessWidget {
  const FareDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final vehicle = appState.selectedVehicle;
    final pickup = appState.pickupLocation;
    final dest = appState.destinationLocation;

    if (vehicle == null) {
      return const Scaffold(body: Center(child: Text('No vehicle selected')));
    }

    final fare = vehicle.fareBreakdown;

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Fare breakdown'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route card
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your route',
                          style: EGoTypography.titleSmall.copyWith(
                            color: EGoColors.grey600,
                          ),
                        ),
                        const SizedBox(height: EGoSpacing.md),
                        _RouteRow(
                          icon: Icons.circle,
                          iconColor: EGoColors.brandSecondary,
                          iconSize: 10,
                          text: pickup?.label ?? 'Pickup location',
                          subtitle: pickup?.subtitle,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 7),
                          child: SizedBox(
                            height: 20,
                            child: VerticalDivider(width: 1, thickness: 1),
                          ),
                        ),
                        _RouteRow(
                          icon: Icons.location_on,
                          iconColor: EGoColors.brandPrimary,
                          iconSize: 16,
                          text: dest?.label ?? 'Destination',
                          subtitle: dest?.subtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Vehicle info
                  _SectionCard(
                    child: Row(
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
                                '${fare.distanceKm} km · ${fare.estimatedMinutes} min trip',
                                style: EGoTypography.bodySmall.copyWith(
                                  color: EGoColors.grey500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Fare breakdown
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fare estimate',
                          style: EGoTypography.titleSmall.copyWith(
                            color: EGoColors.grey600,
                          ),
                        ),
                        const SizedBox(height: EGoSpacing.md),
                        _FareRow(
                          label: 'Base fare',
                          value: '₹${fare.baseFare.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        _FareRow(
                          label:
                              'Distance (${fare.distanceKm} km × ₹${_ratePerKm(vehicle.type).toStringAsFixed(0)})',
                          value: '₹${fare.distanceFare.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: EGoSpacing.sm),
                        _FareRow(
                          label: 'Platform fee',
                          value: '₹${fare.platformFee.toStringAsFixed(0)}',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: EGoSpacing.md,
                          ),
                          child: Divider(height: 1),
                        ),
                        _FareRow(
                          label: 'Total estimate',
                          value: '₹${fare.totalFare.toStringAsFixed(0)}',
                          isTotal: true,
                        ),
                        const SizedBox(height: EGoSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(EGoSpacing.md),
                          decoration: BoxDecoration(
                            color: EGoColors.infoLight,
                            borderRadius: BorderRadius.circular(
                              EGoSpacing.radiusMedium,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 14,
                                color: EGoColors.info,
                              ),
                              const SizedBox(width: EGoSpacing.xs),
                              Expanded(
                                child: Text(
                                  'This is a demo fare estimate. Actual fares may vary.',
                                  style: EGoTypography.labelSmall.copyWith(
                                    color: EGoColors.info,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.lg),
                  // Payment method
                  _SectionCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          color: EGoColors.grey600,
                          size: 20,
                        ),
                        const SizedBox(width: EGoSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment method',
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
                ],
              ),
            ),
          ),
          // Bottom
          Container(
            color: EGoColors.surface,
            padding: const EdgeInsets.fromLTRB(
              EGoSpacing.lg,
              EGoSpacing.lg,
              EGoSpacing.lg,
              EGoSpacing.xxl,
            ),
            child: EGoPrimaryButton(
              onPressed: () {
                appState.proceedToConfirmation();
                Navigator.pushNamed(context, EGoRouter.bookingConfirmation);
              },
              label: 'Confirm vehicle',
            ),
          ),
        ],
      ),
    );
  }

  double _ratePerKm(dynamic type) {
    if (type.toString().contains('bike')) return 10;
    return 7;
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
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

class _FareRow extends StatelessWidget {
  const _FareRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final String value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: isTotal
                ? EGoTypography.titleSmall
                : EGoTypography.bodyMedium.copyWith(color: EGoColors.grey700),
          ),
        ),
        Text(
          value,
          style: isTotal
              ? EGoTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)
              : EGoTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({
    required this.icon,
    required this.iconColor,
    required this.iconSize,
    required this.text,
    this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final String text;
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
                text,
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
