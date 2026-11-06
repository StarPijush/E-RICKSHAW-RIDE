import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/index.dart';
import 'package:e_go/features/home/presentation/widgets/home_map_painter.dart';
import 'package:e_go/features/home/presentation/widgets/home_location_marker.dart';
import 'package:e_go/features/location/data/location_repository.dart';
import 'package:e_go/features/location/domain/location_model.dart';
import 'package:e_go/mock_data/mock_data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// E-GO Home Screen — Official Brand Identity (Yellow & Black)
// Map-first layout with CustomPainter cartographic illustration,
// Rapido-inspired booking bottom sheet and 4-item bottom navigation.
// ─────────────────────────────────────────────────────────────────────────────

// ── Design tokens (Official E-GO Brand System) ──────────────────────────────
const Color _kBrandYellow = Color(0xFFF5C928);
const Color _kBrandBlack = Color(0xFF171717);
const Color _kMainText = Color(0xFF171717);
const Color _kSecondText = Color(0xFF6B7280);
const Color _kInputBg = Color(0xFFF5F5F0);
const Color _kBorder = Color(0xFFE5E5E5);
const Color _kDivider = Color(0xFFEBEBEB);
const Color _kSurface = Color(0xFFFFFFFF);

class EGoHomeScreen extends StatefulWidget {
  const EGoHomeScreen({super.key});

  @override
  State<EGoHomeScreen> createState() => _EGoHomeScreenState();
}

class _EGoHomeScreenState extends State<EGoHomeScreen> {
  final LocationRepository _locationRepository = LocationRepository();

  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      final loc = await _locationRepository.getCurrentLocation();
      if (!mounted) return;
      final appState = context.read<AppState>();
      if (appState.pickupLocation == null && loc != null) {
        appState.setPickupLocation(
          SavedLocation(
            id: 'current-loc',
            label: 'Jhargram Railway Station (Plat. 1)',
            subtitle: 'Station Road, Jhargram',
            coordinate: loc,
            icon: Icons.my_location,
          ),
        );
      }
    } catch (_) {
      // Fallback
    }
  }

  // ── Navigation handlers ───────────────────────────────────────────────────

  void _onRecenterMap() {
    _loadLocation();
  }

  void _onDestinationTap() async {
    final appState = context.read<AppState>();
    final result = await Navigator.pushNamed(
      context,
      EGoRouter.destinationSelection,
    );
    if (result != null && result is SavedLocation && mounted) {
      appState.setDestinationLocation(result);
    }
  }

  void _onPickupChangeTap() async {
    final result = await Navigator.pushNamed(
      context,
      EGoRouter.pickupSelection,
    );
    if (result != null && result is SavedLocation && mounted) {
      context.read<AppState>().setPickupLocation(result);
    }
  }

  void _onChooseLocation() async {
    final appState = context.read<AppState>();
    if (appState.destinationLocation != null) {
      if (appState.pickupLocation == null) {
        appState.setPickupLocation(
          const SavedLocation(
            id: 'pickup-default',
            label: 'Jhargram Railway Station (Plat. 1)',
            subtitle: 'Station Road, Jhargram',
            coordinate: MockData.mockCurrentLocation,
          ),
        );
      }
      await appState.proceedToVehicleSelection();
      if (mounted) {
        Navigator.pushNamed(context, EGoRouter.vehicleSelection);
      }
    } else {
      _onDestinationTap();
    }
  }

  void _onBottomNavTap(int index) {
    if (index == _selectedNavIndex && index == 0) return;
    setState(() => _selectedNavIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(
          context,
          EGoRouter.myRides,
        ).then((_) => setState(() => _selectedNavIndex = 0));
        break;
      case 2:
        Navigator.pushNamed(
          context,
          EGoRouter.helpSupport,
        ).then((_) => setState(() => _selectedNavIndex = 0));
        break;
      case 3:
        Navigator.pushNamed(
          context,
          EGoRouter.profile,
        ).then((_) => setState(() => _selectedNavIndex = 0));
        break;
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Lock status bar to light icons on dark map area
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: _kSurface,
      body: Column(
        children: [
          // ── Map Section ───────────────────────────────────────────────────
          Expanded(child: _buildMapSection()),

          // ── Booking Bottom Sheet ──────────────────────────────────────────
          _buildBookingPanel(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Map Section ──────────────────────────────────────────────────────────

  Widget _buildMapSection() {
    return Stack(
      children: [
        // Map illustration
        Positioned.fill(child: CustomPaint(painter: const HomeMapPainter())),

        // Current location marker — centred at ~47% x, 55% y of map
        Positioned.fill(
          child: LayoutBuilder(
            builder: (_, constraints) {
              final mw = constraints.maxWidth;
              final mh = constraints.maxHeight;
              return Stack(
                children: [
                  Positioned(
                    left: mw * 0.47 - 24,
                    top: mh * 0.52 - 24,
                    child: const HomeCurrentLocationMarker(),
                  ),
                ],
              );
            },
          ),
        ),

        // ── Top overlay: E-GO logo pill only ──────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: _buildLogoPill(),
            ),
          ),
        ),

        // ── Recenter button (bottom-right of map) ─────────────────────────
        Positioned(right: 20, bottom: 20, child: _buildRecenterButton()),
      ],
    );
  }

  Widget _buildLogoPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _kBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          EgoLogo.icon(height: 20),
          SizedBox(width: 8),
          EgoLogo.wordmark(height: 15),
        ],
      ),
    );
  }

  Widget _buildRecenterButton() {
    return Semantics(
      label: 'Recenter map to current location',
      button: true,
      child: SizedBox(
        width: 56,
        height: 56,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _onRecenterMap,
            customBorder: const CircleBorder(),
            splashColor: _kBrandYellow.withValues(alpha: 0.2),
            highlightColor: _kBrandYellow.withValues(alpha: 0.1),
            child: Ink(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _kSurface,
                shape: BoxShape.circle,
                border: Border.all(color: _kBorder, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.my_location_rounded,
                  size: 24,
                  color: _kBrandBlack,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Booking Panel ─────────────────────────────────────────────────────────

  Widget _buildBookingPanel() {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final pickup = appState.pickupLocation;
        final destination = appState.destinationLocation;

        return Container(
          decoration: const BoxDecoration(
            color: _kSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 24,
                spreadRadius: 0,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 2),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE3DD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── "Where to?" heading ───────────────────────────────
                    const Text(
                      'Where to?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _kMainText,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ── Destination search button ─────────────────────────
                    _buildDestinationButton(destination),

                    const SizedBox(height: 12),

                    // ── Pickup location row ───────────────────────────────
                    _buildPickupRow(pickup),

                    const SizedBox(height: 14),

                    // ── "Add saved place" pill ────────────────────────────
                    _buildSavedPlacePill(),

                    const SizedBox(height: 16),

                    // ── CHOOSE LOCATION CTA ───────────────────────────────
                    _buildCTAButton(destination),
                  ],
                ),
              ),

              // Bottom safe area
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDestinationButton(SavedLocation? destination) {
    return GestureDetector(
      onTap: _onDestinationTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _kInputBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kBorder, width: 1),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 20,
              color: destination != null ? _kBrandBlack : _kSecondText,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                destination?.label ?? 'Choose your destination',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: destination != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: destination != null ? _kMainText : _kSecondText,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: _kSecondText),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupRow(SavedLocation? pickup) {
    return Row(
      children: [
        // Dark dot ring indicator
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _kBrandBlack, width: 2.5),
          ),
          child: Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: _kBrandBlack,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        // Label + location text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PICKUP LOCATION',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _kSecondText,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                pickup?.label ?? 'Jhargram Railway Station (Plat. 1)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _kMainText,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),

        // "Change" button
        GestureDetector(
          onTap: _onPickupChangeTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _kBrandYellow.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Change',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _kBrandBlack,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSavedPlacePill() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, EGoRouter.savedPlaces),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9F7),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _kBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add, size: 15, color: _kBrandBlack),
            SizedBox(width: 6),
            Text(
              'Add saved place',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _kBrandBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton(SavedLocation? destination) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _onChooseLocation,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kBrandYellow,
          foregroundColor: _kBrandBlack,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          destination != null ? 'SELECT VEHICLE' : 'CHOOSE LOCATION',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: _kBrandBlack,
          ),
        ),
      ),
    );
  }

  // ── Bottom Navigation ─────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: _kSurface,
        border: Border(top: BorderSide(color: _kDivider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _navItem(0, Icons.home_outlined, Icons.home_rounded, 'Home'),
              _navItem(
                1,
                Icons.electric_rickshaw_outlined,
                Icons.electric_rickshaw,
                'Rides',
                isRidesTab: true,
              ),
              _navItem(
                2,
                Icons.shield_outlined,
                Icons.shield_rounded,
                'Safety',
              ),
              _navItem(
                3,
                Icons.person_outline,
                Icons.person_rounded,
                'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    int index,
    IconData unselectedIcon,
    IconData selectedIcon,
    String label, {
    bool isRidesTab = false,
  }) {
    final selected = _selectedNavIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onBottomNavTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: selected
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 5)
                  : const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: selected ? _kBrandYellow : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              child: isRidesTab
                  ? EgoLogo.icon(
                      height: 20,
                      color: selected ? _kBrandBlack : _kSecondText,
                    )
                  : Icon(
                      selected ? selectedIcon : unselectedIcon,
                      size: 22,
                      color: selected ? _kBrandBlack : _kSecondText,
                    ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? _kBrandBlack : _kSecondText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
