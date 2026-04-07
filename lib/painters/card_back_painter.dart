import 'package:flutter/material.dart';
import 'package:balatro_blast/utils/theme.dart';
import 'package:balatro_blast/utils/constants.dart';

/// Paints the back face of a playing card with a premium Balatro-style look.
class CardBackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cardRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(
      cardRect,
      const Radius.circular(kCardRadius),
    );

    // 1. Background gradient – deep purple to dark navy.
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1e0a5e), Color(0xFF0a1a4e)],
      ).createShader(cardRect);
    canvas.drawRRect(rrect, bgPaint);

    // 2. Diamond crosshatch pattern clipped to card shape.
    final patternPaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;
    const spacing = 10.0;
    canvas.save();
    canvas.clipRRect(rrect);
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

    // 3. Inset inner frame – mimics the border-inside-border look of real cards.
    const inset = 5.0;
    final innerRRect = RRect.fromRectAndRadius(
      cardRect.deflate(inset),
      const Radius.circular(kCardRadius - 2),
    );
    final innerFramePaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(innerRRect, innerFramePaint);

    // 4. "BB" monogram emblem – glowing circle with centred text.
    final cx = size.width / 2;
    final cy = size.height / 2;
    const radius = 18.0;

    // Soft glow ring behind the circle.
    final circleGlowPaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);
    canvas.drawCircle(Offset(cx, cy), radius, circleGlowPaint);

    // Filled circle background.
    final circleFillPaint = Paint()
      ..shader = RadialGradient(
        colors: [const Color(0xFF3a1a7e), const Color(0xFF1e0a5e)],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius));
    canvas.drawCircle(Offset(cx, cy), radius, circleFillPaint);

    // Circle outline.
    final circleStrokePaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(Offset(cx, cy), radius, circleStrokePaint);

    // "BB" text via TextPainter.
    const bbStyle = TextStyle(
      color: Color(0xFFd0b8ff),
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    );
    final tp = TextPainter(
      text: const TextSpan(text: 'BB', style: bbStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));

    // 5. Outer glow border.
    final glowPaint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5);
    canvas.drawRRect(rrect, glowPaint);

    // 6. Crisp outer border on top.
    final borderPaint = Paint()
      ..color = AppColors.mutedPurple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(CardBackPainter oldDelegate) => false;
}
