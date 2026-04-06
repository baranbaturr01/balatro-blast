import 'package:flutter/material.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/utils/theme.dart';
import 'package:balatro_blast/utils/constants.dart';

class JokerCardWidget extends StatelessWidget {
  const JokerCardWidget({
    super.key,
    required this.joker,
    this.onTap,
    this.width = kJokerWidth,
    this.height = kJokerHeight,
  });

  final JokerCard joker;
  final VoidCallback? onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        size: Size(width, height),
        painter: JokerPainter(joker: joker),
      ),
    );
  }
}

class JokerPainter extends CustomPainter {
  JokerPainter({required this.joker});

  final JokerCard joker;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(kCardRadius),
    );

    // Background
    final bgPaint = Paint()..color = AppColors.surface;
    canvas.drawRRect(rect, bgPaint);

    // Border with glow
    final borderColor = _borderColor();
    final glowPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);
    canvas.drawRRect(rect, glowPaint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(rect, borderPaint);

    // "JOKER" label at top
    final labelStyle = TextStyle(
      color: borderColor,
      fontSize: 7,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );
    _drawText(canvas, 'JOKER', size.width / 2, 8, labelStyle, size.width - 8);

    // Joker name
    final nameStyle = const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 7,
      fontWeight: FontWeight.bold,
    );
    _drawText(canvas, joker.name, size.width / 2, 22, nameStyle, size.width - 6);

    // Effect icon area
    _drawEffectSymbol(canvas, size);

    // Description text
    final descStyle = const TextStyle(
      color: AppColors.textMuted,
      fontSize: 5.5,
    );
    _drawText(canvas, joker.description, size.width / 2,
        size.height - 18, descStyle, size.width - 6);
  }

  void _drawEffectSymbol(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final paint = Paint()..color = _borderColor().withValues(alpha: 0.3);
    canvas.drawCircle(Offset(cx, cy), 14, paint);

    final symbol = joker.effectType == JokerEffectType.multiplyMult
        ? '×'
        : joker.effectType == JokerEffectType.addMult
            ? '+M'
            : '+C';
    final symbolStyle = TextStyle(
      color: _borderColor(),
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    _drawText(canvas, symbol, cx, cy - 8, symbolStyle, 30);
  }

  Color _borderColor() {
    switch (joker.effectType) {
      case JokerEffectType.addChips:
        return AppColors.neonBlue;
      case JokerEffectType.addMult:
        return AppColors.neonGreen;
      case JokerEffectType.multiplyMult:
        return AppColors.neonMagenta;
    }
  }

  void _drawText(Canvas canvas, String text, double cx, double cy,
      TextStyle style, double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    painter.paint(
      canvas,
      Offset(cx - painter.width / 2, cy),
    );
  }

  @override
  bool shouldRepaint(JokerPainter oldDelegate) =>
      oldDelegate.joker != joker;
}
