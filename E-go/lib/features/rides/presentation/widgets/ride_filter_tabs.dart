import 'package:flutter/material.dart';
import 'package:e_go/app/theme/colors.dart';

/// Filter options for E-GO Rides screen.
enum RideFilter { all, electricTotos, shared }

/// Tactile filter pills for transit category selection.
class RideFilterTabs extends StatelessWidget {
  const RideFilterTabs({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final RideFilter selectedFilter;
  final ValueChanged<RideFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          _buildFilterPill(filter: RideFilter.all, label: 'All'),
          const SizedBox(width: 8),
          _buildFilterPill(
            filter: RideFilter.electricTotos,
            label: 'Electric TOTOs',
          ),
          const SizedBox(width: 8),
          _buildFilterPill(filter: RideFilter.shared, label: 'Shared'),
        ],
      ),
    );
  }

  Widget _buildFilterPill({required RideFilter filter, required String label}) {
    final isSelected = selectedFilter == filter;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onFilterSelected(filter),
        borderRadius: BorderRadius.circular(9999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? EGoColors.brandYellow : EGoColors.grey100,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: isSelected ? EGoColors.brandYellowDark : EGoColors.outline,
              width: 1,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 0.44,
              color: isSelected ? EGoColors.brandBlack : EGoColors.grey600,
              height: 1.27,
            ),
          ),
        ),
      ),
    );
  }
}
