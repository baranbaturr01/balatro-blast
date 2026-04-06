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
    final painter = CardBackPainter();
    // Slight shadow layers to suggest a pile.
    for (int i = 2; i >= 0; i--) {
      canvas.save();
      canvas.translate(i * 1.0, i * 1.0);
      painter.paint(canvas, Size(kCardWidth * 0.8, kCardHeight * 0.8));
      canvas.restore();
    }

    // Deck count label.
    final count = gameManager.state.deckCount;
    final tp = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(
        kCardWidth * 0.4 - tp.width / 2,
        kCardHeight * 0.4 - tp.height / 2,
      ),
    );
  }
}
