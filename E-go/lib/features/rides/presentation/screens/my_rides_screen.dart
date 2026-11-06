import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_go/app/app_state.dart';
import 'package:e_go/app/router.dart';
import 'package:e_go/app/theme/colors.dart';
import 'package:e_go/features/booking/data/booking_repository.dart';
import 'package:e_go/core/mock_pricing.dart';
import 'package:e_go/shared/widgets/bottom_nav_bar.dart';
import '../widgets/rides_header.dart';
import '../widgets/ride_filter_tabs.dart';
import '../widgets/rides_empty_state.dart';
import '../widgets/ride_card.dart';

/// E-GO Rides screen.
/// Pixel-perfect native Flutter implementation matching code(6).html and DESIGN(8).md.
class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  RideFilter _selectedFilter = RideFilter.all;

  void _onFilterSelected(RideFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onHistoryTap() {
    // Preserve ride history action: switch filter back to all to view entire history
    if (_selectedFilter != RideFilter.all) {
      setState(() {
        _selectedFilter = RideFilter.all;
      });
    }
  }

  void _onBookToto() {
    // Opens the existing customer booking flow (destination selection)
    Navigator.pushNamed(context, EGoRouter.destinationSelection);
  }

  void _onBottomNavTap(int index) {
    if (index == 1) return; // Already on Rides tab

    switch (index) {
      case 0:
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, EGoRouter.home);
        }
        break;
      case 2:
        Navigator.pushNamed(context, EGoRouter.helpSupport);
        break;
      case 3:
        Navigator.pushNamed(context, EGoRouter.profile);
        break;
    }
  }

  List<RideRecord> _getFilteredRides(List<RideRecord> allRides) {
    switch (_selectedFilter) {
      case RideFilter.all:
        return allRides;
      case RideFilter.electricTotos:
        return allRides
            .where((ride) => ride.vehicleType == VehicleType.toto)
            .toList();
      case RideFilter.shared:
        // Shared rides are not currently supported by the booking model.
        // Return an honest empty result rather than fabricating rides.
        return const <RideRecord>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Status bar & nav bar styling matching #F0FCF5 surface with dark icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: EGoColors.grey50,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final allRides = context.watch<AppState>().allRides;
    final filteredRides = _getFilteredRides(allRides);

    return Scaffold(
      backgroundColor: EGoColors.grey50,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header with "Your rides" and 40x40 circular history button
            RidesHeader(onHistoryTap: _onHistoryTap),

            // 2. Filter Pills: All, Electric TOTOs, Shared
            RideFilterTabs(
              selectedFilter: _selectedFilter,
              onFilterSelected: _onFilterSelected,
            ),

            // 3. Main Area: Empty State or Populated List
            Expanded(
              child: filteredRides.isEmpty
                  ? RidesEmptyState(onBookPressed: _onBookToto)
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      itemCount: filteredRides.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          RideCard(ride: filteredRides[index]),
                    ),
            ),

            // 4. Shared E-GO Bottom Navigation Bar
            EGoBottomNavBar(
              selectedIndex: 1,
              onTap: _onBottomNavTap,
              profileLabel: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
