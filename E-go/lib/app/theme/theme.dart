import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';
import 'spacing.dart';

/// E-GO application theme.
/// Official Yellow-and-Black brand identity.
/// Light theme with clean white surfaces, light grey backgrounds, dark typography.
abstract class EGoTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: EGoColors.brandPrimary,
      onPrimary: EGoColors.brandBlack,
      primaryContainer: EGoColors.brandPrimaryLight,
      onPrimaryContainer: EGoColors.brandBlack,
      secondary: EGoColors.brandBlack,
      onSecondary: EGoColors.white,
      secondaryContainer: EGoColors.brandPrimaryLight,
      onSecondaryContainer: EGoColors.brandBlack,
      tertiary: EGoColors.info,
      onTertiary: EGoColors.white,
      surface: EGoColors.surface,
      onSurface: EGoColors.onSurface,
      surfaceContainerHighest: EGoColors.surfaceVariant,
      onSurfaceVariant: EGoColors.onSurfaceVariant,
      outline: EGoColors.outline,
      outlineVariant: EGoColors.outlineVariant,
      error: EGoColors.error,
      onError: EGoColors.white,
      errorContainer: EGoColors.errorLight,
      onErrorContainer: EGoColors.error,
      shadow: EGoColors.mapControlShadow,
    ),

    scaffoldBackgroundColor: EGoColors.grey50,

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: EGoColors.white,
      foregroundColor: EGoColors.onSurface,
      elevation: 0,
      scrolledUnderElevation: EGoSpacing.elevation1,
      surfaceTintColor: EGoColors.white,
      centerTitle: false,
      titleTextStyle: EGoTypography.headlineSmall,
      iconTheme: IconThemeData(
        color: EGoColors.onSurface,
        size: EGoSpacing.iconMedium,
      ),
      actionsIconTheme: IconThemeData(
        color: EGoColors.onSurface,
        size: EGoSpacing.iconMedium,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: EGoColors.surface,
      surfaceTintColor: EGoColors.surface,
      elevation: EGoSpacing.elevation1,
      shadowColor: EGoColors.mapControlShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
      ),
      margin: EdgeInsets.zero,
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: EGoColors.brandPrimary,
        foregroundColor: EGoColors.brandBlack,
        disabledBackgroundColor: EGoColors.grey300,
        disabledForegroundColor: EGoColors.grey500,
        elevation: EGoSpacing.elevation1,
        shadowColor: EGoColors.mapControlShadow,
        minimumSize: Size(double.infinity, EGoSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.xl,
          vertical: EGoSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusPill),
        ),
        textStyle: EGoTypography.labelLarge.copyWith(
          color: EGoColors.brandBlack,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // FilledButton
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: EGoColors.brandPrimary,
        foregroundColor: EGoColors.brandBlack,
        disabledBackgroundColor: EGoColors.grey300,
        disabledForegroundColor: EGoColors.grey500,
        minimumSize: Size(double.infinity, EGoSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.xl,
          vertical: EGoSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusPill),
        ),
        textStyle: EGoTypography.labelLarge.copyWith(
          color: EGoColors.brandBlack,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // OutlinedButton
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: EGoColors.brandBlack,
        disabledForegroundColor: EGoColors.grey400,
        side: const BorderSide(color: EGoColors.brandBlack, width: 1.5),
        minimumSize: Size(double.infinity, EGoSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.xl,
          vertical: EGoSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusPill),
        ),
        textStyle: EGoTypography.labelLarge.copyWith(
          color: EGoColors.brandBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: EGoColors.brandBlack,
        disabledForegroundColor: EGoColors.grey400,
        minimumSize: const Size(64, EGoSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.lg,
          vertical: EGoSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusPill),
        ),
        textStyle: EGoTypography.labelLarge.copyWith(
          color: EGoColors.brandBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // TextField
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: EGoColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: EGoSpacing.lg,
        vertical: EGoSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.outline, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.brandBlack, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.error, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
        borderSide: const BorderSide(color: EGoColors.outlineVariant, width: 1),
      ),
      labelStyle: EGoTypography.bodyMedium.copyWith(
        color: EGoColors.onSurfaceVariant,
      ),
      hintStyle: EGoTypography.bodyMedium.copyWith(color: EGoColors.grey400),
      floatingLabelStyle: EGoTypography.bodySmall.copyWith(
        color: EGoColors.brandBlack,
      ),
      errorStyle: EGoTypography.bodySmall.copyWith(color: EGoColors.error),
      prefixIconColor: EGoColors.grey500,
      suffixIconColor: EGoColors.grey500,
    ),
  );
}
