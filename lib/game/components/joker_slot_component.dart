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
    const slotW = kJokerWidth + 4.0;
    const startX = 4.0;

    // Draw empty slots.
    for (int i = 0; i < kMaxJokers; i++) {
      final slotRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(startX + i * slotW, 4, kJokerWidth, kJokerHeight),
        const Radius.circular(kCardRadius),
      );
      final slotPaint = Paint()
        ..color = AppColors.surface
        ..style = PaintingStyle.fill;
      canvas.drawRRect(slotRect, slotPaint);

      final slotBorder = Paint()
        ..color = AppColors.mutedPurple.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRRect(slotRect, slotBorder);
    }

    // Draw filled joker cards.
    for (int i = 0; i < jokers.length; i++) {
      final joker = jokers[i];
      canvas.save();
      canvas.translate(startX + i * slotW, 4);
      final painter = JokerPainter(joker: joker);
      painter.paint(canvas, const Size(kJokerWidth, kJokerHeight));
      canvas.restore();
    }
  }

  void refresh() {
    // Triggers re-render via parent.
  }
}
