import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// E-GO — Animated Current Location Marker
// White ring + inner green dot + outer pulsing halo (like HTML animate-ping).
// ─────────────────────────────────────────────────────────────────────────────

class HomeCurrentLocationMarker extends StatefulWidget {
  const HomeCurrentLocationMarker({super.key});

  @override
  State<HomeCurrentLocationMarker> createState() =>
      _HomeCurrentLocationMarkerState();
}

class _HomeCurrentLocationMarkerState extends State<HomeCurrentLocationMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  static const Color _brandBlack = Color(0xFF171717);
  static const Color _brandYellow = Color(0xFFF5C928);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _scaleAnim = Tween<double>(
      begin: 0.5,
      end: 2.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnim = Tween<double>(
      begin: 0.5,
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
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing halo
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Transform.scale(
                scale: _scaleAnim.value,
                child: Opacity(
                  opacity: _opacityAnim.value,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _brandYellow.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),

          // White outer ring with shadow
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: _brandBlack,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
