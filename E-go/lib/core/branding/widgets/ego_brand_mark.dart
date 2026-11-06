import 'package:flutter/material.dart';
import 'ego_logo.dart';
import '../ego_brand_colors.dart';

/// Reusable E-GO brand mark, with optional badge container or circular background.
class EgoBrandMark extends StatelessWidget {
  const EgoBrandMark({
    super.key,
    this.size = 40,
    this.showBackground = false,
    this.backgroundColor,
    this.iconColor,
  });

  final double size;
  final bool showBackground;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    if (!showBackground) {
      return EgoLogo.icon(height: size, color: iconColor);
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? EgoBrandColors.yellow,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.2),
      child: Center(
        child: EgoLogo.icon(
          height: size * 0.6,
          color: iconColor ?? EgoBrandColors.black,
        ),
      ),
    );
  }
}
