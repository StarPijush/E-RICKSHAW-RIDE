import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';
import 'buttons.dart';

/// E-GO section header.
class EGoSectionHeader extends StatelessWidget {
  const EGoSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.actionLabel,
  });

  final String title;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: EGoTypography.titleMedium),
        if (action != null && actionLabel != null)
          TextButton(onPressed: action, child: Text(actionLabel!)),
      ],
    );
  }
}

/// E-GO divider with optional label.
class EGoLabeledDivider extends StatelessWidget {
  const EGoLabeledDivider({super.key, this.label, this.labelStyle});

  final String? label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return const Divider(height: 1, thickness: 1);
    }
    return Row(
      children: [
        const Expanded(child: Divider(height: 1, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: EGoSpacing.md),
          child: Text(
            label!,
            style:
                labelStyle ??
                EGoTypography.labelSmall.copyWith(color: EGoColors.grey500),
          ),
        ),
        const Expanded(child: Divider(height: 1, thickness: 1)),
      ],
    );
  }
}

/// E-GO empty state widget.
class EGoEmptyState extends StatelessWidget {
  const EGoEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final Widget icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(EGoSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: EGoColors.grey400,
                size: EGoSpacing.iconLarge * 2,
              ),
              child: icon,
            ),
            const SizedBox(height: EGoSpacing.lg),
            Text(
              title,
              style: EGoTypography.titleLarge.copyWith(
                color: EGoColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: EGoSpacing.sm),
              Text(
                subtitle!,
                style: EGoTypography.bodyMedium.copyWith(
                  color: EGoColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: EGoSpacing.xl),
              EGoPrimaryButton(
                onPressed: onAction,
                label: actionLabel!,
                isFullWidth: false,
                expanded: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// E-GO loading overlay.
class EGoLoadingOverlay extends StatelessWidget {
  const EGoLoadingOverlay({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EGoColors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(EGoSpacing.xxxl),
          decoration: BoxDecoration(
            color: EGoColors.surface,
            borderRadius: BorderRadius.circular(EGoSpacing.radiusXLarge),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  EGoColors.brandPrimary,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: EGoSpacing.lg),
                Text(
                  message!,
                  style: EGoTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// E-GO banner for important messages.
class EGoBanner extends StatelessWidget {
  const EGoBanner({
    super.key,
    required this.message,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  });

  final String message;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? EGoColors.infoLight;
    final txtColor = textColor ?? EGoColors.info;

    return Container(
      padding: const EdgeInsets.all(EGoSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(EGoSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(color: txtColor, size: EGoSpacing.iconMedium),
              child: icon!,
            ),
            const SizedBox(width: EGoSpacing.md),
          ],
          Expanded(
            child: Text(
              message,
              style: EGoTypography.bodyMedium.copyWith(color: txtColor),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: txtColor,
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
              ),
              child: Text(actionLabel!),
            ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                color: txtColor,
                size: EGoSpacing.iconSmall,
              ),
              onPressed: onDismiss,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
        ],
      ),
    );
  }
}
