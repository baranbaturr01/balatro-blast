import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/painters/card_back_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

// ---------------------------------------------------------------------------
// Pip position definitions (x, y in 0..1 range, and whether to flip 180°).
// ---------------------------------------------------------------------------
class _Pip {
  const _Pip(this.x, this.y, {this.flip = false});
  final double x;
  final double y;
  final bool flip;
}

const Map<int, List<_Pip>> _kPipLayouts = {
  2: [
    _Pip(0.5, 0.27),
    _Pip(0.5, 0.73, flip: true),
  ],
  3: [
    _Pip(0.5, 0.22),
    _Pip(0.5, 0.50),
    _Pip(0.5, 0.78, flip: true),
  ],
  4: [
    _Pip(0.3, 0.25),
    _Pip(0.7, 0.25),
    _Pip(0.3, 0.75, flip: true),
    _Pip(0.7, 0.75, flip: true),
  ],
  5: [
    _Pip(0.3, 0.23),
    _Pip(0.7, 0.23),
    _Pip(0.5, 0.50),
    _Pip(0.3, 0.77, flip: true),
    _Pip(0.7, 0.77, flip: true),
  ],
  6: [
    _Pip(0.3, 0.22),
    _Pip(0.7, 0.22),
    _Pip(0.3, 0.50),
    _Pip(0.7, 0.50),
    _Pip(0.3, 0.78, flip: true),
    _Pip(0.7, 0.78, flip: true),
  ],
  7: [
    _Pip(0.3, 0.20),
    _Pip(0.7, 0.20),
    _Pip(0.5, 0.34),
    _Pip(0.3, 0.50),
    _Pip(0.7, 0.50),
    _Pip(0.3, 0.78, flip: true),
    _Pip(0.7, 0.78, flip: true),
  ],
  8: [
    _Pip(0.3, 0.20),
    _Pip(0.7, 0.20),
    _Pip(0.5, 0.33),
    _Pip(0.3, 0.50),
    _Pip(0.7, 0.50),
    _Pip(0.5, 0.67, flip: true),
    _Pip(0.3, 0.80, flip: true),
    _Pip(0.7, 0.80, flip: true),
  ],
  9: [
    _Pip(0.3, 0.17),
    _Pip(0.7, 0.17),
    _Pip(0.3, 0.37),
    _Pip(0.7, 0.37),
    _Pip(0.5, 0.50),
    _Pip(0.3, 0.63, flip: true),
    _Pip(0.7, 0.63, flip: true),
    _Pip(0.3, 0.83, flip: true),
    _Pip(0.7, 0.83, flip: true),
  ],
  10: [
    _Pip(0.3, 0.16),
    _Pip(0.7, 0.16),
    _Pip(0.5, 0.28),
    _Pip(0.3, 0.40),
    _Pip(0.7, 0.40),
    _Pip(0.3, 0.60, flip: true),
    _Pip(0.7, 0.60, flip: true),
    _Pip(0.5, 0.72, flip: true),
    _Pip(0.3, 0.84, flip: true),
    _Pip(0.7, 0.84, flip: true),
  ],
};

/// Paints a playing card face with rank and suit symbols.
class CardFacePainter extends CustomPainter {
  CardFacePainter({required this.card});

  final PlayingCard card;

  @override
  void paint(Canvas canvas, Size size) {
    _drawShadow(canvas, size);
    _drawBackground(canvas, size);
    _drawSelectedGlow(canvas, size);
    _drawScoredGlow(canvas, size);
    _drawBorder(canvas, size);
    _drawContent(canvas, size);
  }

  void _drawShadow(Canvas canvas, Size size) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final shadowRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(3, 4, size.width, size.height),
      const Radius.circular(kCardRadius),
    );
    canvas.drawRRect(shadowRect, shadowPaint);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final rect = _cardRect(size);
    final bgPaint = Paint()..color = AppColors.cardWhite;
    canvas.drawRRect(rect, bgPaint);
  }

  void _drawSelectedGlow(Canvas canvas, Size size) {
    if (!card.isSelected) return;
    final rect = _cardRect(size);
    // Outer glow
    for (int i = 3; i >= 1; i--) {
      final glowPaint = Paint()
        ..color = AppColors.neonBlue.withValues(alpha: 0.15 * i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = i * 3.0
        ..maskFilter = MaskFilter.blur(BlurStyle.outer, i * 4.0);
      canvas.drawRRect(rect, glowPaint);
    }
    // Solid neon border
    final borderPaint = Paint()
      ..color = AppColors.neonBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawRRect(rect, borderPaint);
  }

  void _drawScoredGlow(Canvas canvas, Size size) {
    if (!card.isScored) return;
    final rect = _cardRect(size);
    final glowPaint = Paint()
      ..color = AppColors.neonYellow.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
    canvas.drawRRect(rect, glowPaint);
  }

  void _drawBorder(Canvas canvas, Size size) {
    final rect = _cardRect(size);
    final borderPaint = Paint()
      ..color = const Color(0xFFbbbbbb)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawRRect(rect, borderPaint);
  }

  void _drawContent(Canvas canvas, Size size) {
    final suitColor = card.isRed ? AppColors.cardRed : AppColors.cardBlack;
    final rankStr = card.rank.displayName;
    final suitStr = card.suit.symbol;
    final rankValue = card.rank.value;

    // Corner rank text style
    final cornerRankStyle = TextStyle(
      color: suitColor,
      fontSize: 14,
      fontWeight: FontWeight.w900,
      height: 1.0,
    );
    final cornerSuitStyle = TextStyle(
      color: suitColor,
      fontSize: 11,
      height: 1.0,
    );

    // Top-left corner
    _drawText(canvas, rankStr, 5, 5, cornerRankStyle);
    _drawText(canvas, suitStr, 5, 21, cornerSuitStyle);

    // Bottom-right corner (rotated 180°)
    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.rotate(math.pi);
    _drawText(canvas, rankStr, 5, 5, cornerRankStyle);
    _drawText(canvas, suitStr, 5, 21, cornerSuitStyle);
    canvas.restore();

    // Center pips
    if (_isFaceOrAce(rankValue)) {
      _drawCenterSymbol(canvas, size, suitStr, suitColor, rankStr);
    } else {
      _drawPips(canvas, size, suitStr, suitColor, rankValue);
    }
  }

  bool _isFaceOrAce(int rankValue) =>
      rankValue == 1 || rankValue >= 11 || rankValue == 14;

  void _drawCenterSymbol(Canvas canvas, Size size, String suitStr,
      Color suitColor, String rankStr) {
    // Large center suit symbol for A/J/Q/K
    final pipStyle = TextStyle(
      color: suitColor,
      fontSize: 36,
      height: 1.0,
    );
    _drawTextCentered(
        canvas, suitStr, size.width / 2, size.height / 2 - 18, pipStyle);

    // For face cards, show the rank letter in the center below the symbol
    if (card.rank.value >= 11) {
      final faceStyle = TextStyle(
        color: suitColor.withValues(alpha: 0.6),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        height: 1.0,
      );
      _drawTextCentered(
          canvas, rankStr, size.width / 2, size.height / 2 + 22, faceStyle);
    }
  }

  void _drawPips(Canvas canvas, Size size, String suitStr, Color suitColor,
      int rankValue) {
    final pips = _kPipLayouts[rankValue];
    if (pips == null) return;

    // Pip drawing area: leave room for corners
    const marginX = 12.0;
    const marginTop = 36.0;
    const marginBot = 36.0;
    final areaW = size.width - marginX * 2;
    final areaH = size.height - marginTop - marginBot;

    final pipStyle = TextStyle(
      color: suitColor,
      fontSize: 14,
      height: 1.0,
    );

    for (final pip in pips) {
      final px = marginX + pip.x * areaW;
      final py = marginTop + pip.y * areaH;

      if (pip.flip) {
        canvas.save();
        canvas.translate(px, py);
        canvas.rotate(math.pi);
        _drawTextCentered(canvas, suitStr, 0, 0, pipStyle);
        canvas.restore();
      } else {
        _drawTextCentered(canvas, suitStr, px, py, pipStyle);
      }
    }
  }

  RRect _cardRect(Size size) => RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(kCardRadius),
      );

  void _drawText(
      Canvas canvas, String text, double x, double y, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(x, y));
  }

  void _drawTextCentered(Canvas canvas, String text, double cx, double cy,
      TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
        canvas, Offset(cx - painter.width / 2, cy - painter.height / 2));
  }

  @override
  bool shouldRepaint(CardFacePainter oldDelegate) =>
      oldDelegate.card.isSelected != card.isSelected ||
      oldDelegate.card.isScored != card.isScored ||
      oldDelegate.card != card;
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.card,
    required this.onTap,
    this.faceDown = false,
    this.width = kCardWidth,
    this.height = kCardHeight,
  });

  final PlayingCard card;
  final VoidCallback onTap;
  final bool faceDown;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.translationValues(
          0,
          card.isSelected ? -kCardSelectedOffset : 0,
          0,
        ),
        child: CustomPaint(
          size: Size(width, height),
          painter: faceDown
              ? CardBackPainter()
              : CardFacePainter(card: card),
        ),
      ),
    );
  }
}
