import 'package:flutter/material.dart';
import 'package:e_go/app/theme/index.dart';

/// E-GO current location button.
/// Circular button with location icon for recenter action.
class EGoCurrentLocationButton extends StatelessWidget {
  const EGoCurrentLocationButton({
    super.key,
    required this.onPressed,
    this.tooltip = 'Current location',
    this.isActive = true,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: EGoColors.mapControlBackground,
        elevation: EGoSpacing.elevation2,
        shadowColor: EGoColors.mapControlShadow,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isActive ? onPressed : null,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(EGoSpacing.md),
            child: Icon(
              Icons.my_location,
              color: isActive ? EGoColors.brandPrimary : EGoColors.grey400,
              size: EGoSpacing.iconMedium,
            ),
          ),
        ),
      ),
    );
  }
}

/// E-GO map zoom controls.
/// Plus/minus buttons for map zoom.
class EGoMapZoomControls extends StatelessWidget {
  const EGoMapZoomControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    this.canZoomIn = true,
    this.canZoomOut = true,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final bool canZoomIn;
  final bool canZoomOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ZoomButton(
          icon: Icons.add,
          onPressed: canZoomIn ? onZoomIn : null,
          tooltip: 'Zoom in',
          enabled: canZoomIn,
        ),
        const SizedBox(height: EGoSpacing.xs),
        _ZoomButton(
          icon: Icons.remove,
          onPressed: canZoomOut ? onZoomOut : null,
          tooltip: 'Zoom out',
          enabled: canZoomOut,
        ),
      ],
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: EGoColors.mapControlBackground,
        elevation: EGoSpacing.elevation2,
        shadowColor: EGoColors.mapControlShadow,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(EGoSpacing.md),
            child: Icon(
              icon,
              color: enabled ? EGoColors.onSurface : EGoColors.grey400,
              size: EGoSpacing.iconMedium,
            ),
          ),
        ),
      ),
    );
  }
}

/// E-GO map marker for pickup location.
class EGoPickupMarker extends StatelessWidget {
  const EGoPickupMarker({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size * 0.7,
            height: size * 0.7,
            decoration: BoxDecoration(
              color: EGoColors.brandPrimary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
          // Middle ring
          Container(
            width: size * 0.45,
            height: size * 0.45,
            decoration: BoxDecoration(
              color: EGoColors.brandPrimary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
          ),
          // Core dot
          Container(
            width: size * 0.2,
            height: size * 0.2,
            decoration: const BoxDecoration(
              color: EGoColors.brandPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// E-GO map marker for destination.
class EGoDestinationMarker extends StatelessWidget {
  const EGoDestinationMarker({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DestinationMarkerPainter(
          color: EGoColors.brandPrimary,
          size: size,
        ),
      ),
    );
  }
}

class _DestinationMarkerPainter extends CustomPainter {
  _DestinationMarkerPainter({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Shadow
    final shadowPaint = Paint()
      ..color = EGoColors.mapControlShadow
      ..style = PaintingStyle.fill;
    final shadowPath = Path()
      ..moveTo(center.dx, center.dy + radius * 1.3)
      ..quadraticBezierTo(
        center.dx - radius * 0.8,
        center.dy + radius * 0.3,
        center.dx - radius,
        center.dy - radius * 0.2,
      )
      ..quadraticBezierTo(
        center.dx - radius * 0.3,
        center.dy - radius * 0.8,
        center.dx,
        center.dy - radius * 1.2,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.3,
        center.dy - radius * 0.8,
        center.dx + radius,
        center.dy - radius * 0.2,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.8,
        center.dy + radius * 0.3,
        center.dx,
        center.dy + radius * 1.3,
      )
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Main marker
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy + radius * 1.2)
      ..quadraticBezierTo(
        center.dx - radius * 0.7,
        center.dy + radius * 0.2,
        center.dx - radius,
        center.dy - radius * 0.3,
      )
      ..quadraticBezierTo(
        center.dx - radius * 0.2,
        center.dy - radius * 0.9,
        center.dx,
        center.dy - radius * 1.1,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.2,
        center.dy - radius * 0.9,
        center.dx + radius,
        center.dy - radius * 0.3,
      )
      ..quadraticBezierTo(
        center.dx + radius * 0.7,
        center.dy + radius * 0.2,
        center.dx,
        center.dy + radius * 1.2,
      )
      ..close();

    canvas.drawPath(path, paint);

    // Inner white circle
    final innerPaint = Paint()
      ..color = EGoColors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.15),
      radius * 0.35,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _DestinationMarkerPainter &&
        oldDelegate.color != color &&
        oldDelegate.size != size;
  }
}

/// E-GO current location marker.
class EGoCurrentLocationMarker extends StatelessWidget {
  const EGoCurrentLocationMarker({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing ring (handled by animation wrapper)
          // Core
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: const BoxDecoration(
              color: EGoColors.brandPrimary,
              shape: BoxShape.circle,
            ),
          ),
          // White center
          Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: const BoxDecoration(
              color: EGoColors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

/// E-GO animated current location marker with pulse.
class EGoAnimatedCurrentLocationMarker extends StatefulWidget {
  const EGoAnimatedCurrentLocationMarker({super.key, this.size = 24});

  final double size;

  @override
  State<EGoAnimatedCurrentLocationMarker> createState() =>
      _EGoAnimatedCurrentLocationMarkerState();
}

class _EGoAnimatedCurrentLocationMarkerState
    extends State<EGoAnimatedCurrentLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.6,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size * 2.5;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing rings
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _PulseRingPainter(
                  color: EGoColors.brandPrimary,
                  scale: _scaleAnimation.value,
                  opacity: _opacityAnimation.value,
                  baseSize: widget.size,
                ),
              );
            },
          ),
          // Core marker
          EGoCurrentLocationMarker(size: widget.size),
        ],
      ),
    );
  }
}

class _PulseRingPainter extends CustomPainter {
  _PulseRingPainter({
    required this.color,
    required this.scale,
    required this.opacity,
    required this.baseSize,
  });

  final Color color;
  final double scale;
  final double opacity;
  final double baseSize;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = baseSize * 0.6 * scale;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _PulseRingPainter &&
        oldDelegate.scale != scale &&
        oldDelegate.opacity != opacity;
  }
}
