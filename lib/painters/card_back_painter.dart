import 'package:flutter/material.dart';
import 'package:balatro_blast/utils/theme.dart';
import 'package:balatro_blast/utils/constants.dart';

/// Paints the back face of a playing card.
class CardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(kCardRadius),
    );

    // Background gradient.
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1e0a5e), Color(0xFF0a1a4e)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRRect(rect, bgPaint);

    // Diamond lattice pattern.
    final patternPaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const spacing = 10.0;
    canvas.save();
    canvas.clipRRect(rect);
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        patternPaint,
      );
      canvas.drawLine(
        Offset(x + size.height, 0),
        Offset(x, size.height),
        patternPaint,
      );
    }
    canvas.restore();

    // Border with neon glow.
    final glowPaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
    canvas.drawRRect(rect, glowPaint);

    final borderPaint = Paint()
      ..color = AppColors.mutedPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rect, borderPaint);
  }

  @override
  bool shouldRepaint(CardBackPainter oldDelegate) => false;
}
