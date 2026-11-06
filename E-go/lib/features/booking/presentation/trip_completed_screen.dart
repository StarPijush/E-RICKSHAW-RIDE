import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO trip completed screen.
/// Shows ride summary and leads to rating.
class TripCompletedScreen extends StatelessWidget {
  const TripCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final ride = appState.currentRide;
    final vehicle = appState.selectedVehicle;
    final driver = appState.assignedDriver;

    return Scaffold(
      backgroundColor: EGoColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(EGoSpacing.xxl),
          child: Column(
            children: [
              const SizedBox(height: EGoSpacing.xxxl),
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: EGoColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 56,
                  color: EGoColors.success,
                ),
              ),
              const SizedBox(height: EGoSpacing.xl),
              Text(
                'You\'ve arrived!',
                style: EGoTypography.headlineMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: EGoSpacing.sm),
              Text(
                'Your trip is complete.',
                style: EGoTypography.bodyMedium.copyWith(
                  color: EGoColors.grey500,
                ),
              ),
              const SizedBox(height: EGoSpacing.xxxl),
              // Fare box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(EGoSpacing.xl),
                decoration: BoxDecoration(
                  color: EGoColors.brandPrimaryLight,
                  borderRadius: BorderRadius.circular(EGoSpacing.radiusXLarge),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total fare',
                      style: EGoTypography.bodyMedium.copyWith(
                        color: EGoColors.brandPrimary,
                      ),
                    ),
                    const SizedBox(height: EGoSpacing.sm),
                    Text(
                      '₹${ride?.fareBreakdown.totalFare.toStringAsFixed(0) ?? vehicle?.fareBreakdown.totalFare.toStringAsFixed(0) ?? '—'}',
                      style: EGoTypography.headlineLarge.copyWith(
                        color: EGoColors.brandPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: EGoSpacing.sm),
                    Text(
                      'Cash payment',
                      style: EGoTypography.bodySmall.copyWith(
                        color: EGoColors.brandPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EGoSpacing.xl),
              // Trip summary
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(EGoSpacing.lg),
                decoration: BoxDecoration(
                  color: EGoColors.grey50,
                  borderRadius: BorderRadius.circular(EGoSpacing.radiusXLarge),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      icon: Icons.two_wheeler,
                      label: 'Vehicle',
                      value: vehicle?.name ?? ride?.vehicleName ?? '—',
                    ),
                    const Divider(height: EGoSpacing.xl),
                    _SummaryRow(
                      icon: Icons.circle,
                      iconColor: EGoColors.brandYellow,
                      label: 'From',
                      value:
                          appState.pickupLocation?.label ??
                          ride?.pickupLocation.label ??
                          '—',
                    ),
                    const Divider(height: EGoSpacing.xl),
                    _SummaryRow(
                      icon: Icons.location_on,
                      iconColor: EGoColors.brandPrimary,
                      label: 'To',
                      value:
                          appState.destinationLocation?.label ??
                          ride?.destinationLocation.label ??
                          '—',
                    ),
                    const Divider(height: EGoSpacing.xl),
                    _SummaryRow(
                      icon: Icons.person,
                      label: 'Driver',
                      value: driver?.name ?? ride?.driver.name ?? '—',
                    ),
                    const Divider(height: EGoSpacing.xl),
                    _SummaryRow(
                      icon: Icons.confirmation_number,
                      label: 'Trip ID',
                      value: ride?.tripId ?? '—',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: EGoSpacing.xxxl),
              // Rate button
              EGoPrimaryButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, EGoRouter.rideRating);
                },
                label: 'Rate your ride',
                icon: const Icon(
                  Icons.star_border,
                  color: EGoColors.brandBlack,
                ),
              ),
              const SizedBox(height: EGoSpacing.lg),
              EGoSecondaryButton(
                onPressed: () {
                  appState.skipRating();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    EGoRouter.home,
                    (_) => false,
                  );
                },
                label: 'Done',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor ?? EGoColors.grey500),
        const SizedBox(width: EGoSpacing.md),
        Expanded(
          child: Text(
            label,
            style: EGoTypography.bodySmall.copyWith(color: EGoColors.grey500),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: EGoTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
