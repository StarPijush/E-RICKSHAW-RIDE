import 'package:flutter/material.dart';
import 'ego_logo.dart';

/// Reusable isolated E-GO wordmark.
class EgoWordmark extends StatelessWidget {
  const EgoWordmark({
    super.key,
    this.height = 24,
    this.width,
    this.color,
    this.semanticLabel,
  });

  final double height;
  final double? width;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return EgoLogo.wordmark(
      height: height,
      width: width,
      color: color,
      semanticLabel: semanticLabel,
    );
  }
}
