import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/painters/joker_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays the player's joker cards in a row of evenly-spaced slots.
class JokerSlotComponent extends PositionComponent {
  JokerSlotComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;

  static const double _labelH = 16.0;
  static const double _slotPadH = 10.0; // horizontal padding total
  static const double _slotGap = 6.0;   // gap between slots

  @override
  void render(Canvas canvas) {
    final jokers = gameManager.state.jokers;

    // ── "JOKERS" label ──
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'JOKERS',
        style: TextStyle(
          color: AppColors.mutedPurple,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      Offset((size.x - labelPainter.width) / 2, 2),
    );

    // ── Compute slot geometry ──
    final slotAreaW = size.x - _slotPadH;
    final slotW = (slotAreaW - _slotGap * (kMaxJokers - 1)) / kMaxJokers;
    final slotH = size.y - _labelH - 6;
    final startX = _slotPadH / 2;
    const slotY = _labelH;

    for (int i = 0; i < kMaxJokers; i++) {
      final slotX = startX + i * (slotW + _slotGap);
      final slotRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(slotX, slotY, slotW, slotH),
        const Radius.circular(kCardRadius),
      );

      if (i < jokers.length) {
        // Filled slot: bright tint bg + joker card
        canvas.drawRRect(
          slotRect,
          Paint()..color = const Color(0xFF1a0f30).withValues(alpha: 0.9),
        );
        canvas.drawRRect(
          slotRect,
          Paint()
            ..color = AppColors.mutedPurple.withValues(alpha: 0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
        // Paint joker inside the slot bounds
        canvas.save();
        canvas.translate(slotX, slotY);
        final painter = JokerPainter(joker: jokers[i]);
        painter.paint(canvas, Size(slotW, slotH));
        canvas.restore();
      } else {
        // Empty slot
        canvas.drawRRect(
          slotRect,
          Paint()..color = AppColors.surface.withValues(alpha: 0.3),
        );
        _drawDashedBorder(canvas, slotRect);

        // "?" ghost
        final ghostPainter = TextPainter(
          text: TextSpan(
            text: '?',
            style: TextStyle(
              color: AppColors.mutedPurple.withValues(alpha: 0.5),
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        ghostPainter.paint(
          canvas,
          Offset(
            slotX + (slotW - ghostPainter.width) / 2,
            slotY + (slotH - ghostPainter.height) / 2,
          ),
        );
      }
    }
  }

  void _drawDashedBorder(Canvas canvas, RRect rect) {
    final paint = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashLen = 5.0;
    const gapLen = 4.0;
    final path = Path()..addRRect(rect);
    final metrics = path.computeMetrics().first;
    final totalLen = metrics.length;
    double pos = 0;
    final dashedPath = Path();
    while (pos < totalLen) {
      final end = (pos + dashLen).clamp(0.0, totalLen);
      dashedPath.addPath(metrics.extractPath(pos, end), Offset.zero);
      pos += dashLen + gapLen;
    }
    canvas.drawPath(dashedPath, paint);
  }

  void refresh() {
    // Triggers re-render via parent.
  }
}
