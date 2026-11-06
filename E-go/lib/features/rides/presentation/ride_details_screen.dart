import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';

/// E-GO ride details screen.
class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key, required this.ride});
  final RideRecord ride;

  @override
  Widget build(BuildContext context) {
    final fare = ride.fareBreakdown;
    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(title: const Text('Ride details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(EGoSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + date
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trip ID',
                        style: EGoTypography.labelSmall.copyWith(
                          color: EGoColors.grey500,
                        ),
                      ),
                      Text(
                        ride.tripId ?? '—',
                        style: EGoTypography.labelMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: EGoTypography.labelSmall.copyWith(
                          color: EGoColors.grey500,
                        ),
                      ),
                      Text(
                        _formatDate(ride.bookedAt),
                        style: EGoTypography.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status',
                        style: EGoTypography.labelSmall.copyWith(
                          color: EGoColors.grey500,
                        ),
                      ),
                      _StatusText(status: ride.status),
                    ],
                  ),
                  if (ride.rating != null) ...[
                    const SizedBox(height: EGoSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your rating',
                          style: EGoTypography.labelSmall.copyWith(
                            color: EGoColors.grey500,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              i < ride.rating! ? Icons.star : Icons.star_border,
                              size: 16,
                              color: const Color(0xFFFBBC04),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: EGoSpacing.lg),
            // Route
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pickup',
                              style: EGoTypography.labelSmall.copyWith(
                                color: EGoColors.grey500,
                              ),
                            ),
                            Text(
                              ride.pickupLocation.label,
                              style: EGoTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: EGoColors.brandPrimary,
                      ),
                      const SizedBox(width: EGoSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Destination',
                              style: EGoTypography.labelSmall.copyWith(
                                color: EGoColors.grey500,
                              ),
                            ),
                            Text(
                              ride.destinationLocation.label,
                              style: EGoTypography.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: EGoSpacing.lg),
            // Fare
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fare breakdown',
                    style: EGoTypography.titleSmall.copyWith(
                      color: EGoColors.grey600,
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.md),
                  _Row('Base fare', '₹${fare.baseFare.toStringAsFixed(0)}'),
                  const SizedBox(height: EGoSpacing.sm),
                  _Row(
                    'Distance fare (${fare.distanceKm} km)',
                    '₹${fare.distanceFare.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: EGoSpacing.sm),
                  _Row(
                    'Platform fee',
                    '₹${fare.platformFee.toStringAsFixed(0)}',
                  ),
                  const Divider(height: EGoSpacing.xl),
                  _Row(
                    'Total',
                    '₹${fare.totalFare.toStringAsFixed(0)}',
                    bold: true,
                  ),
                  const SizedBox(height: EGoSpacing.sm),
                  _Row(
                    'Payment',
                    ride.paymentMethod == PaymentMethod.cash ? 'Cash' : 'UPI',
                  ),
                ],
              ),
            ),
            const SizedBox(height: EGoSpacing.lg),
            // Driver
            _SectionCard(
              child: Row(
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
                        Text(ride.driver.name, style: EGoTypography.titleSmall),
                        Text(
                          ride.vehicleName,
                          style: EGoTypography.bodySmall.copyWith(
                            color: EGoColors.grey500,
                          ),
                        ),
                        Text(
                          ride.driver.vehicleNumber,
                          style: EGoTypography.bodySmall.copyWith(
                            color: EGoColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFFBBC04),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${ride.driver.rating}',
                        style: EGoTypography.labelMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour > 12
        ? dt.hour - 12
        : dt.hour == 0
        ? 12
        : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month]} ${dt.year} · $hour:$min $ampm';
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: EGoTypography.bodyMedium.copyWith(color: EGoColors.grey700),
        ),
        Text(
          value,
          style: bold
              ? EGoTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)
              : EGoTypography.bodyMedium.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
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

class _StatusText extends StatelessWidget {
  const _StatusText({required this.status});
  final RideStatus status;
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      RideStatus.completed => ('Completed', EGoColors.success),
      RideStatus.cancelled => ('Cancelled', EGoColors.error),
      RideStatus.active => ('Active', EGoColors.info),
      RideStatus.upcoming => ('Upcoming', EGoColors.warning),
    };
    return Text(label, style: EGoTypography.labelMedium.copyWith(color: color));
  }
}
