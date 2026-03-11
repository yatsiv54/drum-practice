import 'dart:math' as math;
import 'package:flutter/material.dart';




class GradientCupertinoSpinner extends StatefulWidget {
  const GradientCupertinoSpinner({
    super.key,
    this.radius = 16,
    this.lineLength = 14,
    this.lineWidth = 6,
    this.ticks = 12,
    this.duration = const Duration(seconds: 1),
    this.light = const Color(0xFFE7FFBF), 
    this.dark = const Color(0xFF80AB3A), 
    this.minScale = .35, 
    this.minOpacity = .25, 
  });

  final double radius;
  final double lineLength;
  final double lineWidth;
  final int ticks;
  final Duration duration;
  final Color light;
  final Color dark;

  
  final double minScale;

  
  final double minOpacity;

  @override
  State<GradientCupertinoSpinner> createState() =>
      _GradientCupertinoSpinnerState();
}

class _GradientCupertinoSpinnerState extends State<GradientCupertinoSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = (widget.radius + widget.lineLength) * 2;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => CustomPaint(
          painter: _SpinnerPainter(
            progress: _c.value,
            radius: widget.radius,
            lineLen: widget.lineLength,
            lineW: widget.lineWidth,
            ticks: widget.ticks,
            light: widget.light,
            dark: widget.dark,
            minScale: widget.minScale,
            minOpacity: widget.minOpacity,
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  _SpinnerPainter({
    required this.progress,
    required this.radius,
    required this.lineLen,
    required this.lineW,
    required this.ticks,
    required this.light,
    required this.dark,
    required this.minScale,
    required this.minOpacity,
  });

  final double progress;
  final double radius, lineLen, lineW;
  final int ticks;
  final Color light, dark;
  final double minScale, minOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.translate(center.dx, center.dy);

    
    final H = (radius + lineLen) * 2;
    final top = -H / 2;
    final bottom = H / 2;

    final step = 2 * math.pi / ticks;
    final leader = progress * ticks; 

    for (int i = 0; i < ticks; i++) {
      final a = i * step;

      
      double dist = (i - leader) % ticks;
      if (dist < 0) dist += ticks;
      final m = dist / ticks; 

      
      final weight = _easeOutCubic(1 - m); 
      final scale = minScale + (1 - minScale) * weight;
      final alpha = minOpacity + (1 - minOpacity) * weight;

      final L = lineLen * scale;
      
      final rMid = radius + L / 2;
      final yMid = -(rMid) * math.cos(a);

      
      final rect = Rect.fromLTWH(
        -lineW / 2,
        -(radius + L), 
        lineW,
        L, 
      );

      
      double t = (yMid - top) / (bottom - top); 
      t = t.clamp(0.0, 1.0);
      final baseColor = Color.lerp(light, dark, t)!;

      final paint = Paint()..color = baseColor.withOpacity(alpha);

      canvas.save();
      canvas.rotate(a);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(lineW / 2));
      canvas.drawRRect(rrect, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter old) =>
      old.progress != progress ||
      old.radius != radius ||
      old.lineLen != lineLen ||
      old.lineW != lineW ||
      old.ticks != ticks ||
      old.light != light ||
      old.dark != dark ||
      old.minScale != minScale ||
      old.minOpacity != minOpacity;

  double _easeOutCubic(double x) => 1 - math.pow(1 - x, 3).toDouble();
}
