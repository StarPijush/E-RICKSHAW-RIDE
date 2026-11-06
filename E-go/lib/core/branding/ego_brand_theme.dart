import 'package:flutter/material.dart';
import 'ego_brand_colors.dart';

/// Design tokens and helpers for E-GO brand styling.
abstract class EgoBrandTheme {
  /// Primary elevated button style with brand yellow and high-contrast dark text.
  static ButtonStyle primaryButtonStyle({
    double height = 52,
    double borderRadius = 26,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: EgoBrandColors.yellow,
      foregroundColor: EgoBrandColors.textOnYellow,
      elevation: 0,
      minimumSize: Size(double.infinity, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  /// Dark button style with brand black and white text.
  static ButtonStyle darkButtonStyle({
    double height = 52,
    double borderRadius = 26,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: EgoBrandColors.black,
      foregroundColor: EgoBrandColors.textOnBlack,
      elevation: 0,
      minimumSize: Size(double.infinity, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  /// Subtle card decoration with border and soft shadow.
  static BoxDecoration cardDecoration({
    Color backgroundColor = EgoBrandColors.cardBackground,
    double borderRadius = 16,
    Color borderColor = EgoBrandColors.border,
  }) {
    return BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
