import 'package:flutter/material.dart';
import '../../core/branding/ego_brand_colors.dart';

/// E-GO color tokens.
/// Official Brand Identity: Yellow & Black.
/// Light theme, clean white surfaces, warm light backgrounds, dark high-contrast typography.
abstract class EGoColors {
  // Official Brand Tokens
  static const Color brandPrimary = EgoBrandColors.yellow;
  static const Color brandPrimaryDark = EgoBrandColors.yellowDark;
  static const Color brandPrimaryLight = EgoBrandColors.yellowLight;
  static const Color brandYellow = EgoBrandColors.yellow;
  static const Color brandYellowLight = EgoBrandColors.yellowLight;
  static const Color brandYellowDark = EgoBrandColors.yellowDark;
  static const Color brandBlack = EgoBrandColors.black;
  static const Color brandCharcoal = EgoBrandColors.charcoal;

  // Secondary brand accent
  static const Color brandSecondary = EgoBrandColors.black;
  static const Color brandSecondaryDark = Color(0xFF000000);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAF7);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF171717);
  static const Color black = Color(0xFF171717);

  // Semantic (Preserved functional status colors)
  static const Color success = EgoBrandColors.success;
  static const Color successLight = EgoBrandColors.successLight;
  static const Color warning = EgoBrandColors.warning;
  static const Color warningLight = EgoBrandColors.warningLight;
  static const Color error = EgoBrandColors.error;
  static const Color errorLight = EgoBrandColors.errorLight;
  static const Color info = EgoBrandColors.info;
  static const Color infoLight = EgoBrandColors.infoLight;

  // Surface
  static const Color surface = white;
  static const Color surfaceVariant = grey50;
  static const Color surfaceElevated = white;
  static const Color onSurface = grey900;
  static const Color onSurfaceVariant = grey500;
  static const Color outline = grey300;
  static const Color outlineVariant = grey200;
  static const Color divider = Color(0xFFE5E5E5);

  // Common aliases
  static const Color transparent = Color(0x00000000);

  // Migrated Design System Tokens (Formerly green system, now yellow/black)
  static const Color surfaceGreen = Color(0xFFFAFAF7);
  static const Color surfaceBright = Color(0xFFFFFBEA);
  static const Color surfaceContainer = Color(0xFFFFF9DB);
  static const Color surfaceContainerLow = Color(0xFFFFFDEE);
  static const Color primaryDark = EgoBrandColors.black;
  static const Color primaryContainer = EgoBrandColors.yellow;
  static const Color onPrimary = EgoBrandColors.black;
  static const Color onPrimaryContainer = EgoBrandColors.black;
  static const Color onSurfaceText = EgoBrandColors.black;
  static const Color onSurfaceVariantText = EgoBrandColors.textSecondary;
  static const Color outlineGreen = EgoBrandColors.yellowDark;
  static const Color outlineVariantGreen = Color(0xFFE5E5E5);

  // Map-specific
  static const Color mapMarkerPrimary = brandYellow;
  static const Color mapMarkerSecondary = brandBlack;
  static const Color mapControlBackground = white;
  static const Color mapControlShadow = Color(0x1A000000); // 10% black
}
