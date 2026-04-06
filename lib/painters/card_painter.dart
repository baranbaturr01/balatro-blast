import 'package:flutter/material.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/painters/card_back_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Paints a playing card face with rank and suit symbols.
class CardFacePainter extends CustomPainter {
  CardFacePainter({required this.card});

  final PlayingCard card;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(kCardRadius),
    );

    // Card background
    final bgPaint = Paint()..color = AppColors.cardWhite;
    canvas.drawRRect(rect, bgPaint);

    // Selected highlight glow
    if (card.isSelected) {
      final glowPaint = Paint()
        ..color = AppColors.neonGreen.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
      canvas.drawRRect(rect, glowPaint);
    }

    // Scored highlight
    if (card.isScored) {
      final scorePaint = Paint()
        ..color = AppColors.neonYellow.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6);
      canvas.drawRRect(rect, scorePaint);
    }

    // Border
    final borderPaint = Paint()
      ..color = const Color(0xFFcccccc)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rect, borderPaint);

    final suitColor = card.isRed ? AppColors.cardRed : AppColors.cardBlack;
    final rankText = card.rank.displayName;
    final suitText = card.suit.symbol;

    final cornerStyle = TextStyle(
      color: suitColor,
      fontSize: 11,
      fontWeight: FontWeight.bold,
    );

    // Top-left rank
    _drawText(canvas, rankText, 4, 2, cornerStyle);
    // Top-left suit
    _drawText(canvas, suitText, 4, 13, cornerStyle.copyWith(fontSize: 9));

    // Center large suit symbol
    final centerStyle = TextStyle(
      color: suitColor,
      fontSize: 28,
    );
    _drawTextCentered(
        canvas, suitText, size.width / 2, size.height / 2 - 14, centerStyle);

    // Bottom-right (rotated 180°)
    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.rotate(3.14159);
    _drawText(canvas, rankText, 4, 2, cornerStyle);
    _drawText(canvas, suitText, 4, 13, cornerStyle.copyWith(fontSize: 9));
    canvas.restore();
  }

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
      oldDelegate.card.isScored != card.isScored;
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
