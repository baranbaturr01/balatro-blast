import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/painters/joker_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays the player's joker cards in a row of slots.
class JokerSlotComponent extends PositionComponent {
  JokerSlotComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;

  @override
  void render(Canvas canvas) {
    final jokers = gameManager.state.jokers;

    // "JOKERS" label
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'JOKERS',
        style: TextStyle(
          color: AppColors.mutedPurple,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, const Offset(4, 2));

    const slotTop = 14.0;
    final slotW = kJokerWidth + 6.0;

    // Draw slots
    for (int i = 0; i < kMaxJokers; i++) {
      final slotX = i * slotW;
      final slotRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(slotX, slotTop, kJokerWidth, size.y - slotTop - 4),
        const Radius.circular(kCardRadius),
      );

      if (i < jokers.length) {
        // Filled joker slot – paint joker card
        canvas.save();
        canvas.translate(slotX, slotTop);
        final painter = JokerPainter(joker: jokers[i]);
        painter.paint(canvas, Size(kJokerWidth, size.y - slotTop - 4));
        canvas.restore();
      } else {
        // Empty slot – draw dashed border
        final bgPaint = Paint()
          ..color = AppColors.surface.withValues(alpha: 0.5);
        canvas.drawRRect(slotRect, bgPaint);
        _drawDashedBorder(canvas, slotRect);

        // Ghost icon
        final ghostPainter = TextPainter(
          text: const TextSpan(
            text: '?',
            style: TextStyle(
              color: AppColors.mutedPurple,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        ghostPainter.paint(
          canvas,
          Offset(
            slotX + (kJokerWidth - ghostPainter.width) / 2,
            slotTop + (size.y - slotTop - 4 - ghostPainter.height) / 2,
          ),
        );
      }
    }
  }

  void _drawDashedBorder(Canvas canvas, RRect rect) {
    final paint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashLen = 4.0;
    const gapLen = 3.0;
    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics().first;
    final totalLen = metrics.length;
    double pos = 0;
    final dashedPath = Path();
    while (pos < totalLen) {
      final end = (pos + dashLen).clamp(0.0, totalLen);
      dashedPath.addPath(
        metrics.extractPath(pos, end),
        Offset.zero,
      );
      pos += dashLen + gapLen;
    }
    canvas.drawPath(dashedPath, paint);
  }

  void refresh() {
    // Triggers re-render via parent.
  }
}
