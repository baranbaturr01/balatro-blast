import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/hand_type.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays the HUD: blind info, score target, hands/discards, money, ante.
/// Also renders the Chips × Mult formula and current hand preview below.
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

    // ── Background panel ──
    final bgPaint = Paint()
      ..color = AppColors.surface.withValues(alpha: 0.95);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final bottomBorder = Paint()
      ..color = AppColors.mutedPurple
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.y), Offset(size.x, size.y), bottomBorder);

    // ── Left: Blind name + target ──
    _drawText(
      canvas,
      state.currentBlind.name,
      10,
      8,
      const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
    );
    _drawText(
      canvas,
      'Target: ${_fmt(state.currentBlindTarget)}',
      10,
      26,
      const TextStyle(color: AppColors.neonYellow, fontSize: 11),
    );

    // ── Center: Score progress ──
    final scoreStr = _fmt(state.runningScore);
    final targetStr = _fmt(state.currentBlindTarget);
    final cx = size.x / 2;
    _drawTextCentered(
      canvas,
      '$scoreStr / $targetStr',
      cx,
      12,
      const TextStyle(
        color: AppColors.neonYellow,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );

    // Progress bar below score
    _drawProgressBar(canvas, state.runningScore, state.currentBlindTarget, cx);

    // ── Right: Money + Ante ──
    _drawTextRight(
      canvas,
      '\$${state.money}',
      size.x - 10,
      8,
      const TextStyle(
        color: AppColors.goldAccent,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    _drawTextRight(
      canvas,
      'Ante ${state.ante}',
      size.x - 10,
      26,
      const TextStyle(color: AppColors.textMuted, fontSize: 10),
    );

    // ── Bottom row: Hands + Discards ──
    _drawText(
      canvas,
      '♦ Hands: ${state.handsLeft}',
      10,
      50,
      const TextStyle(color: AppColors.neonGreen, fontSize: 10),
    );
    _drawText(
      canvas,
      '✕ Discards: ${state.discardsLeft}',
      130,
      50,
      const TextStyle(color: Color(0xFFFF6B6B), fontSize: 10),
    );

    // ── Hand preview (right side of bottom row) ──
    final preview = state.previewHandType;
    if (preview != null) {
      final handName = HandTypeInfo.forType(preview).name;
      _drawTextRight(
        canvas,
        handName.toUpperCase(),
        size.x - 10,
        50,
        const TextStyle(
          color: AppColors.neonBlue,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  void _drawProgressBar(Canvas canvas, int current, int target, double cx) {
    const barH = 4.0;
    const barW = 200.0;
    final barY = size.y - barH - 4;
    final barX = cx - barW / 2;
    final ratio = (current / target).clamp(0.0, 1.0);

    final bgBar = Paint()..color = AppColors.mutedPurple.withValues(alpha: 0.4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barW, barH),
        const Radius.circular(2),
      ),
      bgBar,
    );

    if (ratio > 0) {
      final fillBar = Paint()..color = AppColors.neonGreen;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, barY, barW * ratio, barH),
          const Radius.circular(2),
        ),
        fillBar,
      );
    }
  }

  String _fmt(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }

  void _drawText(
      Canvas canvas, String text, double x, double y, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(x, y));
  }

  void _drawTextCentered(
      Canvas canvas, String text, double cx, double y, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(cx - painter.width / 2, y));
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
    // Triggers re-render via parent.
  }
}

/// Draws the Chips × Mult = Score formula below the joker/deck area.
class ScoreFormulaComponent extends PositionComponent {
  ScoreFormulaComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;
  int displayChips = 0;
  int displayMult = 0;

  @override
  void render(Canvas canvas) {
    // Background
    final bgPaint = Paint()
      ..color = AppColors.background.withValues(alpha: 0.6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    final cx = size.x / 2;
    final cy = size.y / 2;

    if (displayChips > 0 || displayMult > 0) {
      // Chips pill
      _drawPill(canvas, 'Chips', '$displayChips',
          Offset(cx - 110, cy - 12), AppColors.neonBlue, const Color(0xFF0a1a3e));

      // × symbol
      _drawTextCentered(canvas, '×', cx, cy - 10,
          const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold));

      // Mult pill
      _drawPill(canvas, 'Mult', '$displayMult',
          Offset(cx + 50, cy - 12), const Color(0xFFFF4444), const Color(0xFF3e0a0a));

      // = and total
      _drawTextCentered(canvas, '= ${displayChips * displayMult}', cx, cy + 14,
          const TextStyle(color: AppColors.neonYellow, fontSize: 14, fontWeight: FontWeight.bold));
    } else {
      // Show current hand type hint
      final preview = gameManager.state.previewHandType;
      if (preview != null) {
        final info = HandTypeInfo.forType(preview);
        _drawTextCentered(
          canvas,
          '${info.name}  •  ${info.baseChips} chips × ${info.baseMult} mult',
          cx, cy - 8,
          const TextStyle(color: AppColors.textMuted, fontSize: 11),
        );
      } else {
        _drawTextCentered(
          canvas,
          'Select cards to play',
          cx, cy - 8,
          const TextStyle(color: AppColors.textMuted, fontSize: 10),
        );
      }
    }
  }

  void _drawPill(Canvas canvas, String label, String value, Offset origin,
      Color accent, Color bg) {
    const w = 80.0;
    const h = 32.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(origin.dx, origin.dy, w, h),
      const Radius.circular(6),
    );
    canvas.drawRRect(rect, Paint()..color = bg);
    final border = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(rect, border);

    final labelPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(color: accent, fontSize: 8, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(canvas, Offset(origin.dx + (w - labelPainter.width) / 2, origin.dy + 3));

    final valuePainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(color: accent, fontSize: 14, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    valuePainter.paint(canvas, Offset(origin.dx + (w - valuePainter.width) / 2, origin.dy + 14));
  }

  void _drawTextCentered(
      Canvas canvas, String text, double cx, double y, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(cx - painter.width / 2, y));
  }

  void refresh() {}
}
