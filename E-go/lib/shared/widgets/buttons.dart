import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';

/// E-GO primary action button.
/// Filled, pill-shaped, brand primary color.
class EGoPrimaryButton extends StatelessWidget {
  const EGoPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.expanded = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: EGoSpacing.iconMedium,
            height: EGoSpacing.iconMedium,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(EGoColors.brandBlack),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: EGoSpacing.sm),
              ],
              Text(
                label,
                style: EGoTypography.labelLarge.copyWith(
                  color: EGoColors.brandBlack,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: EGoColors.brandPrimary,
        foregroundColor: EGoColors.brandBlack,
        minimumSize: Size(
          isFullWidth && expanded ? double.infinity : 0,
          height ?? EGoSpacing.buttonHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.xl,
          vertical: EGoSpacing.md,
        ),
      ),
      child: child,
    );

    if (isFullWidth && expanded) {
      return button;
    }
    return SizedBox(width: isFullWidth ? double.infinity : null, child: button);
  }
}

/// E-GO secondary action button.
/// Outlined, pill-shaped, brand primary border.
class EGoSecondaryButton extends StatelessWidget {
  const EGoSecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isFullWidth = true,
    this.height,
    this.expanded = true,
  });

  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final bool isFullWidth;
  final double? height;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: EGoSpacing.sm)],
        Text(
          label,
          style: EGoTypography.labelLarge.copyWith(
            color: EGoColors.brandBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: EGoColors.brandBlack,
        side: const BorderSide(color: EGoColors.brandBlack, width: 1.5),
        minimumSize: Size(
          isFullWidth && expanded ? double.infinity : 0,
          height ?? EGoSpacing.buttonHeight,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.xl,
          vertical: EGoSpacing.md,
        ),
      ),
      child: child,
    );

    if (isFullWidth && expanded) {
      return button;
    }
    return SizedBox(width: isFullWidth ? double.infinity : null, child: button);
  }
}

/// E-GO text button.
/// No background, brand primary text.
class EGoTextButton extends StatelessWidget {
  const EGoTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
  });

  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(64, EGoSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.lg,
          vertical: EGoSpacing.sm,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: EGoSpacing.xs)],
          Text(label),
        ],
      ),
    );
  }
}

/// E-GO icon button with circular tap area.
class EGoIconButton extends StatelessWidget {
  const EGoIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.size = EGoSpacing.iconMedium,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: size,
      color: foregroundColor ?? EGoColors.onSurface,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor ?? EGoColors.surface,
        elevation: elevation ?? EGoSpacing.elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusRound),
        ),
        padding: EdgeInsets.all(EGoSpacing.sm),
      ),
      tooltip: tooltip,
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}

/// E-GO floating action button.
class EGoFloatingActionButton extends StatelessWidget {
  const EGoFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.mini = false,
    this.extended = false,
    this.label,
  });

  final VoidCallback? onPressed;
  final Widget icon;
  final String? tooltip;
  final bool mini;
  final bool extended;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: icon,
        label: Text(label!, style: EGoTypography.labelLarge),
        tooltip: tooltip,
        elevation: EGoSpacing.elevation3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(EGoSpacing.radiusRound),
        ),
      );
    }
    return FloatingActionButton(
      onPressed: onPressed,
      mini: mini,
      tooltip: tooltip,
      elevation: EGoSpacing.elevation3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(EGoSpacing.radiusRound),
      ),
      child: icon,
    );
  }
}
