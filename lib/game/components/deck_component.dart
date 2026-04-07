import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/painters/card_back_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays the remaining deck as a stacked face-down pile with count badge.
class DeckComponent extends PositionComponent {
  DeckComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;

  static const double _labelH = 14.0;
  static const double _cardW = kCardWidth * 0.72;
  static const double _cardH = kCardHeight * 0.72;
  static const int _stackLayers = 4;
  static const double _layerOffsetX = 1.8;
  static const double _layerOffsetY = 1.2;

  @override
  void render(Canvas canvas) {
    final count = gameManager.state.deckCount;

    // ── "DECK" label ──
    final labelPainter = TextPainter(
      text: const TextSpan(
        text: 'DECK',
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

    final startX = (size.x - _cardW) / 2;
    const startY = _labelH + 2;

    // ── Stacked shadow layers (back to front) ──
    for (int i = _stackLayers; i >= 1; i--) {
      final ox = startX + i * _layerOffsetX;
      final oy = startY + i * _layerOffsetY;
      final alpha = 0.15 + i * 0.06;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(ox, oy, _cardW, _cardH),
          const Radius.circular(kCardRadius * 0.75),
        ),
        Paint()..color = AppColors.mutedPurple.withValues(alpha: alpha),
      );
    }

    // Drop shadow behind top card
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX + 2, startY + 4, _cardW, _cardH),
        const Radius.circular(kCardRadius * 0.75),
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.45),
    );

    // ── Top card (card back) ──
    canvas.save();
    canvas.translate(startX, startY);
    CardBackPainter().paint(canvas, const Size(_cardW, _cardH));
    canvas.restore();

    // ── Count badge (centered on top card) ──
    final countPainter = TextPainter(
      text: TextSpan(
        text: '$count',
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 6),
            Shadow(color: Colors.black, blurRadius: 12),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    countPainter.paint(
      canvas,
      Offset(
        startX + (_cardW - countPainter.width) / 2,
        startY + (_cardH - countPainter.height) / 2,
      ),
    );

    // ── "X left" label below ──
    final remainPainter = TextPainter(
      text: TextSpan(
        text: '$count left',
        style: TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.75),
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    remainPainter.paint(
      canvas,
      Offset(
        (size.x - remainPainter.width) / 2,
        startY + _cardH + 5,
      ),
    );
  }
}
