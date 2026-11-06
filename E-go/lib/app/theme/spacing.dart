/// E-GO spacing and sizing tokens.
/// 4px base unit, consistent scale.
abstract class EGoSpacing {
  // Base unit
  static const double base = 4.0;

  // Scale
  static const double xs = base * 1; // 4
  static const double sm = base * 2; // 8
  static const double md = base * 3; // 12
  static const double lg = base * 4; // 16
  static const double xl = base * 5; // 20
  static const double xxl = base * 6; // 24
  static const double xxxl = base * 8; // 32
  static const double huge = base * 12; // 48

  // Component-specific
  static const double buttonHeight = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double inputHeight = 48.0;
  static const double chipHeight = 32.0;
  static const double avatarSmall = 32.0;
  static const double avatarMedium = 40.0;
  static const double avatarLarge = 56.0;
  static const double iconSmall = 18.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;

  // Border radius
  static const double radiusNone = 0.0;
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;
  static const double radiusRound = 9999.0;
  static const double radiusPill = 24.0;

  // Elevation/shadow
  static const double elevation0 = 0.0;
  static const double elevation1 = 1.0;
  static const double elevation2 = 3.0;
  static const double elevation3 = 6.0;
  static const double elevation4 = 10.0;

  // Map panel
  static const double mapBottomPanelPeek = 80.0;
  static const double mapBottomPanelHalf = 0.45;
  static const double mapBottomPanelFull = 0.85;
}
