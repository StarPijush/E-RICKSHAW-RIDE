import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/core/booking_state.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/shared/widgets/buttons.dart';

/// E-GO driver search screen.
/// Animated search with simulated driver matching.
class SearchingDriverScreen extends StatefulWidget {
  const SearchingDriverScreen({super.key});

  @override
  State<SearchingDriverScreen> createState() => _SearchingDriverScreenState();
}

class _SearchingDriverScreenState extends State<SearchingDriverScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  Timer? _watchdogTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Safety timeout — if driver is not found within 10s, show failure
    _watchdogTimer = Timer(const Duration(seconds: 12), () {
      final appState = _appState;
      if (appState != null &&
          appState.bookingStatus == BookingStatus.searchingDriver) {
        appState.handleSearchFailure();
      }
    });
  }

  AppState? _appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appState == null) {
      _appState = context.read<AppState>();
      _appState!.addListener(_onStateChange);
    }
  }

  void _onStateChange() {
    if (!mounted) return;
    final appState = _appState;
    if (appState == null) return;
    switch (appState.bookingStatus) {
      case BookingStatus.driverAssigned:
        _watchdogTimer?.cancel();
        Navigator.pushReplacementNamed(context, EGoRouter.driverAssigned);
        break;
      case BookingStatus.failed:
        _watchdogTimer?.cancel();
        // Stay on screen and show retry UI
        setState(() {});
        break;
      case BookingStatus.cancelled:
      case BookingStatus.idle:
        _watchdogTimer?.cancel();
        Navigator.pushNamedAndRemoveUntil(
          context,
          EGoRouter.home,
          (_) => false,
        );
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _watchdogTimer?.cancel();
    _appState?.removeListener(_onStateChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final vehicle = appState.selectedVehicle;
    final isFailed = appState.bookingStatus == BookingStatus.failed;

    return Scaffold(
      backgroundColor: EGoColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(EGoSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isFailed) ...[
                // Pulsing animation
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (_, __) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: EGoColors.brandYellowLight,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: EGoColors.brandYellow.withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: vehicle?.type == VehicleType.toto
                            ? const EgoLogo.icon(height: 52)
                            : Icon(
                                vehicle?.iconData ?? Icons.two_wheeler,
                                size: 52,
                                color: EGoColors.brandBlack,
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                Text(
                  'Finding your driver',
                  style: EGoTypography.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: EGoSpacing.md),
                Text(
                  'Searching nearby ${vehicle?.name ?? 'vehicle'} drivers...',
                  style: EGoTypography.bodyMedium.copyWith(
                    color: EGoColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                // Route summary
                _SearchRouteSummary(appState: appState),
                const SizedBox(height: EGoSpacing.xxxl),
                EGoSecondaryButton(
                  onPressed: () async {
                    await appState.cancelRide();
                  },
                  label: 'Cancel search',
                ),
              ] else ...[
                const Icon(
                  Icons.search_off,
                  size: 72,
                  color: EGoColors.grey400,
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                Text(
                  'No drivers found',
                  style: EGoTypography.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: EGoSpacing.md),
                Text(
                  'No drivers are available right now. Please try again.',
                  style: EGoTypography.bodyMedium.copyWith(
                    color: EGoColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: EGoSpacing.xxxl),
                EGoPrimaryButton(
                  onPressed: () {
                    appState.retrySearch();
                    setState(() {});
                  },
                  label: 'Retry',
                  icon: const Icon(Icons.refresh, color: EGoColors.white),
                ),
                const SizedBox(height: EGoSpacing.md),
                EGoSecondaryButton(
                  onPressed: () {
                    appState.resetToIdle();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      EGoRouter.home,
                      (_) => false,
                    );
                  },
                  label: 'Back to home',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchRouteSummary extends StatelessWidget {
  const _SearchRouteSummary({required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(EGoSpacing.lg),
      decoration: BoxDecoration(
        color: EGoColors.grey50,
        borderRadius: BorderRadius.circular(EGoSpacing.radiusXLarge),
      ),
      child: Column(
        children: [
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
                  appState.pickupLocation?.label ?? 'Pickup',
                  style: EGoTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
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
                color: EGoColors.brandPrimary,
              ),
              const SizedBox(width: EGoSpacing.md),
              Expanded(
                child: Text(
                  appState.destinationLocation?.label ?? 'Destination',
                  style: EGoTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
