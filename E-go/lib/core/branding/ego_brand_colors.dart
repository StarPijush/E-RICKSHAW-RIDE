import 'package:flutter/material.dart';

/// Official E-GO Brand Palette
/// Derived from the official brand logo: bold black mark on warm golden yellow card.
abstract class EgoBrandColors {
  // Brand Yellow
  static const Color yellow = Color(0xFFF5C928);
  static const Color yellowLight = Color(0xFFFFF4C2);
  static const Color yellowDark = Color(0xFFD9A900);
  static const Color yellowMuted = Color(0xFFFDEBB4);

  // Brand Dark
  static const Color black = Color(0xFF171717);
  static const Color charcoal = Color(0xFF292929);

  // Surfaces & Backgrounds
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFAFAF7);
  static const Color surfaceVariant = Color(0xFFF5F5F0);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Typography
  static const Color textPrimary = Color(0xFF171717);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textOnYellow = Color(0xFF171717);
  static const Color textOnBlack = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFE5E5E5);
  static const Color borderLight = Color(0xFFF0F0EE);
  static const Color divider = Color(0xFFEBEBEB);

  // Semantic Status (Preserved functional colors)
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);
}
