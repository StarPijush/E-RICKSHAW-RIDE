import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/features/booking/data/vehicle_repository.dart';
import 'package:e_go/shared/widgets/buttons.dart';
import 'package:e_go/shared/widgets/common.dart';

/// E-GO vehicle selection screen.
/// Shows Bike and Toto options with fare estimates.
class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  VehicleOption? _selected;

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    _selected = appState.selectedVehicle;
    // Auto-select first if none selected
    if (_selected == null && appState.availableVehicles.isNotEmpty) {
      _selected = appState.availableVehicles.first;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selected != null) {
          context.read<AppState>().selectVehicle(_selected!);
        }
      });
    }
  }

  void _selectVehicle(VehicleOption v) {
    setState(() => _selected = v);
    context.read<AppState>().selectVehicle(v);
  }

  void _proceed() {
    context.read<AppState>().proceedToFareReview();
    Navigator.pushNamed(context, EGoRouter.fareDetails);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final pickup = appState.pickupLocation;
    final dest = appState.destinationLocation;
    final vehicles = appState.availableVehicles;
    final isLoading = appState.vehiclesLoading;

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      appBar: AppBar(
        title: const Text('Choose vehicle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Route summary
          Container(
            color: EGoColors.surface,
            padding: const EdgeInsets.all(EGoSpacing.lg),
            child: _RouteSummaryCard(
              pickup: pickup?.label ?? 'Current location',
              destination: dest?.label ?? '',
              pickupSubtitle: pickup?.subtitle,
              destinationSubtitle: dest?.subtitle,
            ),
          ),
          const Divider(height: 1),
          // Vehicle list
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        EGoColors.brandPrimary,
                      ),
                    ),
                  )
                : vehicles.isEmpty
                ? EGoEmptyState(
                    icon: const Icon(Icons.two_wheeler),
                    title: 'No vehicles available',
                    subtitle: 'Please try again later',
                    actionLabel: 'Go back',
                    onAction: () => Navigator.pop(context),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(EGoSpacing.lg),
                    itemCount: vehicles.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: EGoSpacing.md),
                    itemBuilder: (_, i) => _VehicleCard(
                      vehicle: vehicles[i],
                      isSelected: _selected?.type == vehicles[i].type,
                      onTap: () => _selectVehicle(vehicles[i]),
                    ),
                  ),
          ),
          // Bottom action
          Container(
            color: EGoColors.surface,
            padding: const EdgeInsets.fromLTRB(
              EGoSpacing.lg,
              EGoSpacing.lg,
              EGoSpacing.lg,
              EGoSpacing.xxl,
            ),
            child: Column(
              children: [
                if (_selected != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimated fare',
                        style: EGoTypography.bodyMedium.copyWith(
                          color: EGoColors.grey600,
                        ),
                      ),
                      Text(
                        '₹${_selected!.fareBreakdown.totalFare.toStringAsFixed(0)}',
                        style: EGoTypography.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: EGoColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: EGoSpacing.md),
                ],
                EGoPrimaryButton(
                  onPressed: _selected != null ? _proceed : null,
                  label: 'Continue',
                  icon: const Icon(Icons.arrow_forward, color: EGoColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  final VehicleOption vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(EGoSpacing.lg),
        decoration: BoxDecoration(
          color: EGoColors.surface,
          borderRadius: BorderRadius.circular(EGoSpacing.radiusXLarge),
          border: Border.all(
            color: isSelected ? EGoColors.brandPrimary : EGoColors.outline,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: EGoColors.brandPrimary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: EGoColors.mapControlShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Vehicle icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? EGoColors.brandYellowLight
                    : EGoColors.grey100,
                borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
              ),
              child: Center(
                child: vehicle.type == VehicleType.toto
                    ? const EgoLogo.icon(height: 28)
                    : Icon(
                        vehicle.iconData,
                        size: 30,
                        color: isSelected
                            ? EGoColors.brandBlack
                            : EGoColors.grey600,
                      ),
              ),
            ),
            const SizedBox(width: EGoSpacing.lg),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        vehicle.name,
                        style: EGoTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (vehicle.capacity > 1) ...[
                        const SizedBox(width: EGoSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: EGoSpacing.sm,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: EGoColors.grey100,
                            borderRadius: BorderRadius.circular(
                              EGoSpacing.radiusSmall,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.person,
                                size: 10,
                                color: EGoColors.grey500,
                              ),
                              Text(
                                ' ${vehicle.capacity}',
                                style: EGoTypography.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    vehicle.subtitle,
                    style: EGoTypography.bodySmall.copyWith(
                      color: EGoColors.grey500,
                    ),
                  ),
                  const SizedBox(height: EGoSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: EGoColors.grey500,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${vehicle.fareBreakdown.estimatedArrivalMinutes} min arrival · '
                        '${vehicle.fareBreakdown.estimatedMinutes} min trip',
                        style: EGoTypography.labelSmall.copyWith(
                          color: EGoColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Fare
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${vehicle.fareBreakdown.totalFare.toStringAsFixed(0)}',
                  style: EGoTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? EGoColors.brandBlack
                        : EGoColors.onSurface,
                  ),
                ),
                Text(
                  '${vehicle.fareBreakdown.distanceKm} km',
                  style: EGoTypography.labelSmall.copyWith(
                    color: EGoColors.grey500,
                  ),
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(top: EGoSpacing.xs),
                    child: Icon(
                      Icons.check_circle,
                      color: EGoColors.brandBlack,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteSummaryCard extends StatelessWidget {
  const _RouteSummaryCard({
    required this.pickup,
    required this.destination,
    this.pickupSubtitle,
    this.destinationSubtitle,
  });

  final String pickup;
  final String destination;
  final String? pickupSubtitle;
  final String? destinationSubtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            const Icon(Icons.circle, size: 10, color: EGoColors.brandSecondary),
            Container(width: 1, height: 32, color: EGoColors.grey300),
            const Icon(
              Icons.location_on,
              size: 14,
              color: EGoColors.brandPrimary,
            ),
          ],
        ),
        const SizedBox(width: EGoSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickup,
                style: EGoTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (pickupSubtitle != null)
                Text(
                  pickupSubtitle!,
                  style: EGoTypography.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: EGoSpacing.xl),
              Text(
                destination,
                style: EGoTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (destinationSubtitle != null)
                Text(
                  destinationSubtitle!,
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
