import 'dart:math' as math;
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// E-GO Home Screen — Cartographic Map Illustration
// CustomPainter recreation of the HTML SVG reference design.
// Colours are cartographic / geographic — intentionally neutral and NOT brand
// colours. Brand identity (yellow/black) is applied via UI overlays, not the
// map canvas itself.
// ─────────────────────────────────────────────────────────────────────────────

class HomeMapPainter extends CustomPainter {
  const HomeMapPainter();

  // ── Color tokens (from HTML reference) ──────────────────────────────────
  static const Color _mapBg = Color(0xFFF4F6F3);
  static const Color _land1 = Color(0xFFE8EFE8);
  static const Color _land2 = Color(0xFFE4ECE4);
  static const Color _land3 = Color(0xFFEAF0EA);
  static const Color _block = Color(0xFFECEEE9);
  static const Color _minorRoad = Color(0xFFDFE4DF);
  static const Color _roadCasing = Color(0xFFD1D9D2);
  static const Color _roadSurface = Color(0xFFFFFFFF);
  static const Color _railway = Color(0xFFB8C4BC);
  static const Color _labelColor = Color(0xFFAFBDB6);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── 1. Background ───────────────────────────────────────────────────────
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = _mapBg);

    // ── 2. Green vegetation / land parcels ──────────────────────────────────
    _drawLandParcels(canvas, w, h);

    // ── 3. Urban blocks (grey rectangles) ───────────────────────────────────
    _drawUrbanBlocks(canvas, w, h);

    // ── 4. Minor connector roads ─────────────────────────────────────────────
    _drawMinorRoads(canvas, w, h);

    // ── 5. Arterial roads (casing + surface) ─────────────────────────────────
    _drawArterialRoads(canvas, w, h);

    // ── 6. Railway line (dashed) ─────────────────────────────────────────────
    _drawRailway(canvas, w, h);

    // ── 7. Place labels ───────────────────────────────────────────────────────
    _drawLabels(canvas, w, h);
  }

  // ── Land Parcels ──────────────────────────────────────────────────────────
  void _drawLandParcels(Canvas canvas, double w, double h) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Parcel 1 — top-left organic shape
    paint.color = _land1.withValues(alpha: 0.9);
    final p1 = Path()
      ..moveTo(w * -0.076, h * -0.048)
      ..cubicTo(
        w * 0.153,
        h * 0.048,
        w * 0.280,
        h * -0.024,
        w * 0.433,
        h * 0.083,
      )
      ..cubicTo(
        w * 0.382,
        h * 0.333,
        w * 0.102,
        h * 0.310,
        w * -0.076,
        h * 0.357,
      )
      ..close();
    canvas.drawPath(p1, paint);

    // Parcel 2 — top-right organic shape
    paint.color = _land2.withValues(alpha: 0.8);
    final p2 = Path()
      ..moveTo(w * 0.661, h * -0.048)
      ..cubicTo(w * 0.814, h * 0.048, w * 0.941, h * 0.0, w * 1.095, h * 0.095)
      ..lineTo(w * 1.095, h * 0.452)
      ..cubicTo(
        w * 0.865,
        h * 0.429,
        w * 0.738,
        h * 0.333,
        w * 0.611,
        h * 0.286,
      )
      ..close();
    canvas.drawPath(p2, paint);

    // Parcel 3 — bottom-left organic shape
    paint.color = _land3.withValues(alpha: 0.7);
    final p3 = Path()
      ..moveTo(w * -0.051, h * 0.690)
      ..cubicTo(
        w * 0.153,
        h * 0.643,
        w * 0.306,
        h * 0.738,
        w * 0.357,
        h * 1.024,
      )
      ..lineTo(w * -0.051, h * 1.024)
      ..close();
    canvas.drawPath(p3, paint);
  }

  // ── Urban Blocks ──────────────────────────────────────────────────────────
  void _drawUrbanBlocks(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..color = _block.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    // Block 1
    _roundRect(canvas, paint, w * 0.165, h * 0.202, w * 0.242, h * 0.167, 6);
    // Block 2
    _roundRect(canvas, paint, w * 0.535, h * 0.190, w * 0.306, h * 0.202, 8);
    // Block 3
    _roundRect(canvas, paint, w * 0.636, h * 0.571, w * 0.204, h * 0.214, 8);
    // Block 4 — small mid-left
    paint.color = _block.withValues(alpha: 0.4);
    _roundRect(canvas, paint, w * 0.064, h * 0.405, w * 0.153, h * 0.143, 5);
  }

  void _roundRect(
    Canvas canvas,
    Paint paint,
    double x,
    double y,
    double width,
    double height,
    double radius,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, width, height),
        Radius.circular(radius),
      ),
      paint,
    );
  }

  // ── Minor Roads ───────────────────────────────────────────────────────────
  void _drawMinorRoads(Canvas canvas, double w, double h) {
    final paint = Paint()
      ..color = _minorRoad
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Road 1 — gentle horizontal connector
    final r1 = Path()
      ..moveTo(w * -0.051, h * 0.429)
      ..lineTo(w * 1.070, h * 0.381);
    canvas.drawPath(r1, paint);

    // Road 2 — vertical side connector
    final r2 = Path()
      ..moveTo(w * 0.433, h * 0.0)
      ..lineTo(w * 0.408, h * 1.0);
    canvas.drawPath(r2, paint);
  }

  // ── Arterial Roads ────────────────────────────────────────────────────────
  void _drawArterialRoads(Canvas canvas, double w, double h) {
    // Road A — main curved horizontal arterial
    _drawRoad(
      canvas,
      _buildArterialA(w, h),
      casingWidth: 9.0,
      surfaceWidth: 5.0,
    );

    // Road B — diagonal curved arterial
    _drawRoad(
      canvas,
      _buildArterialB(w, h),
      casingWidth: 8.0,
      surfaceWidth: 4.5,
    );
  }

  Path _buildArterialA(double w, double h) {
    return Path()
      ..moveTo(w * -0.076, h * 0.571)
      ..cubicTo(
        w * 0.204,
        h * 0.524,
        w * 0.433,
        h * 0.595,
        w * 0.688,
        h * 0.548,
      )
      ..cubicTo(
        w * 0.841,
        h * 0.524,
        w * 0.967,
        h * 0.571,
        w * 1.095,
        h * 0.548,
      );
  }

  Path _buildArterialB(double w, double h) {
    return Path()
      ..moveTo(w * 0.280, h * -0.024)
      ..cubicTo(
        w * 0.255,
        h * 0.238,
        w * 0.331,
        h * 0.452,
        w * 0.280,
        h * 0.690,
      )
      ..cubicTo(
        w * 0.255,
        h * 0.833,
        w * 0.229,
        h * 0.929,
        w * 0.255,
        h * 1.048,
      );
  }

  void _drawRoad(
    Canvas canvas,
    Path path, {
    required double casingWidth,
    required double surfaceWidth,
  }) {
    // Casing (outline)
    canvas.drawPath(
      path,
      Paint()
        ..color = _roadCasing
        ..strokeWidth = casingWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    // Surface (white centre)
    canvas.drawPath(
      path,
      Paint()
        ..color = _roadSurface
        ..strokeWidth = surfaceWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  // ── Railway Line (dashed) ─────────────────────────────────────────────────
  void _drawRailway(Canvas canvas, double w, double h) {
    final path = Path()
      ..moveTo(w * 0.688, h * -0.024)
      ..cubicTo(
        w * 0.738,
        h * 0.333,
        w * 0.700,
        h * 0.619,
        w * 0.738,
        h * 1.024,
      );

    // Dash pattern — solid base
    canvas.drawPath(
      path,
      Paint()
        ..color = _railway.withValues(alpha: 0.5)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt,
    );

    // Dash ticks — approximate using short line segments
    _drawDashedPath(
      canvas,
      path,
      _railway.withValues(alpha: 0.7),
      2.0,
      6.0,
      4.0,
    );
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Color color,
    double strokeWidth,
    double dashLength,
    double gapLength,
  ) {
    final metrics = path.computeMetrics();
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    for (final metric in metrics) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final segmentLength = draw ? dashLength : gapLength;
        if (draw) {
          final start = distance.clamp(0.0, metric.length);
          final end = (distance + segmentLength).clamp(0.0, metric.length);
          final extracted = metric.extractPath(start, end);
          canvas.drawPath(extracted, paint);
        }
        distance += segmentLength;
        draw = !draw;
      }
    }
  }

  // ── Place Labels ───────────────────────────────────────────────────────────
  void _drawLabels(Canvas canvas, double w, double h) {
    _paintLabel(canvas, 'JHARGRAM', w * 0.14, h * 0.52, 9.5, 1.5);
    _paintLabel(canvas, 'GHORADHARA', w * 0.52, h * 0.65, 8.5, 1.5);
  }

  void _paintLabel(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    double letterSpacing,
  ) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: _labelColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          letterSpacing: letterSpacing,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant HomeMapPainter oldDelegate) => false;
}

// ignore: unused_element
double _deg2Rad(double degrees) => degrees * math.pi / 180;
