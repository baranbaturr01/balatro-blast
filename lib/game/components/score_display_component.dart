import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays current score, blind target, hands, and discards remaining.
class ScoreDisplayComponent extends PositionComponent {
  ScoreDisplayComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;

  @override
  void render(Canvas canvas) {
    final state = gameManager.state;

    // Background panel.
    final bgPaint = Paint()..color = AppColors.surface;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final bottomBorder = Paint()
      ..color = AppColors.mutedPurple
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.y), Offset(size.x, size.y), bottomBorder);

    // Blind name and target.
    _drawText(
      canvas,
      state.currentBlind.name,
      8,
      8,
      const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );

    _drawText(
      canvas,
      'Target: ${state.currentBlindTarget}',
      8,
      22,
      const TextStyle(color: AppColors.neonYellow, fontSize: 9),
    );

    // Running score (large).
    _drawTextRight(
      canvas,
      '${state.runningScore}',
      size.x - 8,
      8,
      const TextStyle(
        color: AppColors.neonYellow,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    // Hands and discards.
    _drawText(
      canvas,
      'Hands: ${state.handsLeft}',
      8,
      46,
      const TextStyle(color: AppColors.neonGreen, fontSize: 9),
    );

    _drawText(
      canvas,
      'Discards: ${state.discardsLeft}',
      8,
      58,
      const TextStyle(color: AppColors.neonBlue, fontSize: 9),
    );

    // Money.
    _drawTextRight(
      canvas,
      '\$${state.money}',
      size.x - 8,
      46,
      const TextStyle(color: AppColors.goldAccent, fontSize: 12),
    );

    // Ante.
    _drawTextRight(
      canvas,
      'Ante ${state.ante}',
      size.x - 8,
      60,
      const TextStyle(color: AppColors.textMuted, fontSize: 8),
    );
  }

  void _drawText(
      Canvas canvas, String text, double x, double y, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(x, y));
  }

  void _drawTextRight(
      Canvas canvas, String text, double rightX, double y, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(rightX - painter.width, y));
  }

  void refresh() {
    // Triggers re-render.
  }
}
