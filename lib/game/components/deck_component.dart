import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/painters/card_back_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays the remaining deck as a face-down pile with count.
class DeckComponent extends PositionComponent {
  DeckComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;

  @override
  void render(Canvas canvas) {
    // "DECK" label
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'DECK',
        style: TextStyle(
          color: AppColors.mutedPurple,
          fontSize: 8,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      Offset((size.x - labelPainter.width) / 2, 2),
    );

    const cardW = kCardWidth * 0.75;
    const cardH = kCardHeight * 0.75;
    final startX = (size.x - cardW) / 2;
    const startY = 16.0;

    final painter = CardBackPainter();

    // Draw stacked layers (shadow effect)
    for (int i = 4; i >= 1; i--) {
      canvas.save();
      canvas.translate(startX + i * 1.5, startY + i * 1.0);
      // Dimmer layers
      final opacity = 0.3 + i * 0.1;
      final shadowPaint = Paint()
        ..color = AppColors.mutedPurple.withValues(alpha: opacity);
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, cardW, cardH),
        const Radius.circular(kCardRadius * 0.75),
      );
      canvas.drawRRect(r, shadowPaint);
      canvas.restore();
    }

    // Top card (actual back)
    canvas.save();
    canvas.translate(startX, startY);
    painter.paint(canvas, const Size(cardW, cardH));
    canvas.restore();

    // Count overlay
    final count = gameManager.state.deckCount;
    final countPainter = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 4),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    countPainter.paint(
      canvas,
      Offset(
        startX + (cardW - countPainter.width) / 2,
        startY + (cardH - countPainter.height) / 2,
      ),
    );

    // Remaining label
    final remainPainter = TextPainter(
      text: const TextSpan(
        text: 'left',
        style: TextStyle(
          color: AppColors.textMuted,
          fontSize: 7,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    remainPainter.paint(
      canvas,
      Offset(
        (size.x - remainPainter.width) / 2,
        startY + cardH + 4,
      ),
    );
  }
}
