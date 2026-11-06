import 'package:flutter/material.dart';
import 'package:e_go/app/theme/colors.dart';
import 'package:e_go/core/branding/ego_brand.dart';

/// E-GO shared bottom navigation component.
/// Official Brand Identity: Yellow active capsule pill with Brand Black text & icons.
class EGoBottomNavBar extends StatelessWidget {
  const EGoBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onTap,
    this.profileLabel = 'Profile',
    this.showGestureIndicator = true,
  });

  final int selectedIndex;
  final ValueChanged<int>? onTap;
  final String profileLabel;
  final bool showGestureIndicator;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: EGoColors.white,
        border: Border(top: BorderSide(color: EGoColors.divider, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  _buildTabItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                  ),
                  _buildTabItem(
                    index: 1,
                    icon: Icons.electric_rickshaw_outlined,
                    activeIcon: Icons.electric_rickshaw,
                    label: 'Rides',
                    isRidesTab: true,
                  ),
                  _buildTabItem(
                    index: 2,
                    icon: Icons.shield_outlined,
                    activeIcon: Icons.shield,
                    label: 'Safety',
                  ),
                  _buildTabItem(
                    index: 3,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: profileLabel,
                  ),
                ],
              ),
            ),
            if (showGestureIndicator)
              Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 8),
                child: Container(
                  width: 128,
                  height: 4,
                  decoration: BoxDecoration(
                    color: EGoColors.grey300,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    bool isRidesTab = false,
  }) {
    final isSelected = selectedIndex == index;

    return Expanded(
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap?.call(index),
            borderRadius: BorderRadius.circular(9999),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16 : 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected ? EGoColors.brandYellow : Colors.transparent,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  isRidesTab
                      ? EgoLogo.icon(
                          height: 20,
                          color: isSelected
                              ? EGoColors.brandBlack
                              : EGoColors.grey500,
                        )
                      : Icon(
                          isSelected ? activeIcon : icon,
                          size: 22,
                          color: isSelected
                              ? EGoColors.brandBlack
                              : EGoColors.grey500,
                        ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      letterSpacing: 0.2,
                      color: isSelected
                          ? EGoColors.brandBlack
                          : EGoColors.grey500,
                      height: 1.27,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
