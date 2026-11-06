import 'package:flutter/material.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';

/// Clean transit ride card conforming to E-GO design tokens.
class RideCard extends StatelessWidget {
  const RideCard({super.key, required this.ride});

  final RideRecord ride;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          EGoRouter.rideDetails,
          arguments: ride,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: EGoColors.divider, width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: vehicle icon, vehicle name, status chip
              Row(
                children: [
                  ride.vehicleType == VehicleType.bike
                      ? const Icon(
                          Icons.two_wheeler_rounded,
                          size: 20,
                          color: EGoColors.brandBlack,
                        )
                      : const EgoLogo.icon(height: 18),
                  const SizedBox(width: 8),
                  Text(
                    ride.vehicleName,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: EGoColors.brandBlack,
                    ),
                  ),
                  const Spacer(),
                  _buildStatusChip(ride.status),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: EGoColors.divider,
                ),
              ),
              // Route
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.circle,
                      size: 8,
                      color: EGoColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      ride.pickupLocation.label,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: EGoColors.onSurfaceText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.location_on,
                      size: 11,
                      color: EGoColors.primaryContainer,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ride.destinationLocation.label,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: EGoColors.onSurfaceText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: EGoColors.surfaceContainer,
                ),
              ),
              // Footer: Date, rating, price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(ride.bookedAt),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: EGoColors.onSurfaceVariantText,
                    ),
                  ),
                  Row(
                    children: [
                      if (ride.rating != null) ...[
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: Color(0xFFF5B33B),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${ride.rating}',
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: EGoColors.onSurfaceText,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Text(
                        '₹${ride.fareBreakdown.totalFare.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: EGoColors.onSurfaceText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(RideStatus status) {
    final (label, bg, fg) = switch (status) {
      RideStatus.completed => (
        'Completed',
        const Color(0xFFD1FAE5),
        const Color(0xFF059669),
      ),
      RideStatus.cancelled => (
        'Cancelled',
        const Color(0xFFFEE2E2),
        const Color(0xFFDC2626),
      ),
      RideStatus.active => (
        'Active',
        const Color(0xFFE0F2FE),
        const Color(0xFF0284C7),
      ),
      RideStatus.upcoming => (
        'Upcoming',
        const Color(0xFFFEF3C7),
        const Color(0xFFD97706),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
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
    return '${dt.day} ${months[dt.month]} · $hour:$min $ampm';
  }
}
