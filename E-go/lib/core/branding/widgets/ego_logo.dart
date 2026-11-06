import 'package:flutter/material.dart';
import '../ego_brand_assets.dart';

/// Available variants for the official E-GO logo.
enum EgoLogoVariant {
  /// TOTO symbol together with the bold italic E-GO wordmark.
  primary,

  /// Isolated TOTO electric rickshaw symbol.
  icon,

  /// Isolated bold italic E-GO wordmark.
  wordmark,
}

/// Official E-GO Logo widget supporting primary, icon, and wordmark variants.
class EgoLogo extends StatelessWidget {
  const EgoLogo({
    super.key,
    this.variant = EgoLogoVariant.primary,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel,
  });

  /// Factory constructor for the primary logo (TOTO symbol + E-GO wordmark).
  const EgoLogo.primary({
    super.key,
    this.width,
    this.height = 48,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel = 'E-GO Logo',
  }) : variant = EgoLogoVariant.primary;

  /// Factory constructor for the isolated TOTO symbol.
  const EgoLogo.icon({
    super.key,
    this.width,
    this.height = 36,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel = 'E-GO Symbol',
  }) : variant = EgoLogoVariant.icon;

  /// Factory constructor for the isolated E-GO wordmark.
  const EgoLogo.wordmark({
    super.key,
    this.width,
    this.height = 24,
    this.fit = BoxFit.contain,
    this.color,
    this.semanticLabel = 'E-GO Wordmark',
  }) : variant = EgoLogoVariant.wordmark;

  final EgoLogoVariant variant;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final String? semanticLabel;

  String get _assetPath {
    switch (variant) {
      case EgoLogoVariant.primary:
        return EgoBrandAssets.logoPrimary;
      case EgoLogoVariant.icon:
        return EgoBrandAssets.logoIcon;
      case EgoLogoVariant.wordmark:
        return EgoBrandAssets.logoWordmark;
    }
  }

  String get _defaultLabel {
    switch (variant) {
      case EgoLogoVariant.primary:
        return 'E-GO Logo';
      case EgoLogoVariant.icon:
        return 'E-GO Symbol';
      case EgoLogoVariant.wordmark:
        return 'E-GO';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
      semanticLabel: semanticLabel ?? _defaultLabel,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: width ?? 48,
          height: height ?? 48,
          child: const Center(
            child: Icon(Icons.broken_image, size: 24, color: Colors.grey),
          ),
        );
      },
    );
  }
}
