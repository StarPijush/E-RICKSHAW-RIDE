import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';

/// E-GO location input field.
/// Designed for pickup/destination with icon, label, and trailing action.
class EGoLocationInput extends StatelessWidget {
  const EGoLocationInput({
    super.key,
    required this.label,
    required this.hint,
    this.value,
    this.icon,
    this.trailingIcon,
    this.onTap,
    this.onChanged,
    this.controller,
    this.readOnly = true,
    this.enabled = true,
    this.errorText,
    this.filled = true,
    this.fillColor,
    this.contentPadding,
  });

  final String label;
  final String hint;
  final String? value;
  final Widget? icon;
  final Widget? trailingIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final String? errorText;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: EGoTypography.titleSmall),
        const SizedBox(height: EGoSpacing.xs),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: EGoTypography.bodyMedium.copyWith(
              color: value != null && value!.isNotEmpty
                  ? EGoColors.grey400
                  : EGoColors.grey500,
            ),
            prefixIcon: icon != null
                ? Padding(
                    padding: const EdgeInsets.all(EGoSpacing.md),
                    child: icon,
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: EGoSpacing.iconMedium + EGoSpacing.md * 2,
              minHeight: EGoSpacing.iconMedium + EGoSpacing.md * 2,
            ),
            suffixIcon: trailingIcon != null
                ? Padding(
                    padding: const EdgeInsets.all(EGoSpacing.md),
                    child: trailingIcon,
                  )
                : null,
            filled: filled,
            fillColor: fillColor ?? EGoColors.surface,
            contentPadding:
                contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: EGoSpacing.lg,
                  vertical: EGoSpacing.md,
                ),
            errorText: errorText,
          ),
          style: EGoTypography.bodyLarge.copyWith(
            color: value != null && value!.isNotEmpty
                ? EGoColors.onSurface
                : EGoColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// E-GO search input field.
/// Designed for destination search with clear action.
class EGoSearchInput extends StatefulWidget {
  const EGoSearchInput({
    super.key,
    required this.hint,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.controller,
    this.autofocus = false,
    this.prefixIcon,
  });

  final String hint;
  final String? value;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;
  final Widget? prefixIcon;

  @override
  State<EGoSearchInput> createState() => _EGoSearchInputState();
}

class _EGoSearchInputState extends State<EGoSearchInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value ?? '');
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.isNotEmpty;

    return TextFormField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (hasText != value.isNotEmpty) {
          setState(() {});
        }
      },
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: EGoTypography.bodyMedium.copyWith(color: EGoColors.grey500),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.all(EGoSpacing.md),
                child: widget.prefixIcon,
              )
            : Padding(
                padding: const EdgeInsets.all(EGoSpacing.md),
                child: Icon(
                  Icons.search,
                  color: EGoColors.grey500,
                  size: EGoSpacing.iconMedium,
                ),
              ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: EGoSpacing.iconMedium + EGoSpacing.md * 2,
          minHeight: EGoSpacing.iconMedium + EGoSpacing.md * 2,
        ),
        suffixIcon: hasText
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: EGoColors.grey500,
                  size: EGoSpacing.iconMedium,
                ),
                onPressed: () {
                  _controller.clear();
                  widget.onClear?.call();
                  widget.onChanged?.call('');
                  setState(() {});
                },
                tooltip: 'Clear',
              )
            : null,
        filled: true,
        fillColor: EGoColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.lg,
          vertical: EGoSpacing.md,
        ),
      ),
      style: EGoTypography.bodyLarge,
    );
  }
}

/// E-GO recent destination chip.
class EGoRecentDestinationChip extends StatelessWidget {
  const EGoRecentDestinationChip({
    super.key,
    required this.label,
    this.subtitle,
    this.icon,
    this.onTap,
    this.onLongPress,
    this.selected = false,
  });

  final String label;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: EGoSpacing.lg,
          vertical: EGoSpacing.md,
        ),
        decoration: BoxDecoration(
          color: selected ? EGoColors.brandPrimaryLight : EGoColors.surface,
          borderRadius: BorderRadius.circular(EGoSpacing.radiusLarge),
          border: Border.all(
            color: selected ? EGoColors.brandPrimary : EGoColors.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: selected ? EGoColors.brandPrimary : EGoColors.grey500,
                  size: EGoSpacing.iconMedium,
                ),
                child: icon!,
              ),
              const SizedBox(width: EGoSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: EGoTypography.bodyMedium.copyWith(
                      color: selected
                          ? EGoColors.brandPrimary
                          : EGoColors.onSurface,
                      fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: EGoSpacing.xs / 2),
                    Text(
                      subtitle!,
                      style: EGoTypography.bodySmall.copyWith(
                        color: selected
                            ? EGoColors.brandPrimary.withValues(alpha: 0.7)
                            : EGoColors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle,
                color: EGoColors.brandPrimary,
                size: EGoSpacing.iconSmall,
              ),
          ],
        ),
      ),
    );
  }
}
