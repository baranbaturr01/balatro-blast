import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/hand_type.dart';
import 'package:balatro_blast/utils/theme.dart';

/// Displays the top HUD bar: blind info, score target, hands/discards, money, ante.
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
    final isBoss = state.currentBlind.name.startsWith('The');

    // ── Background panel with subtle gradient effect ──
    final bgPaint = Paint()
      ..color = const Color(0xFF1e0f38).withValues(alpha: 0.97);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    // Boss blind: red glow on left edge
    if (isBoss) {
      final glow = Paint()
        ..shader = const LinearGradient(
          colors: [Color(0x55FF2222), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, 120, size.y));
      canvas.drawRect(Rect.fromLTWH(0, 0, 120, size.y), glow);
    }

    // Top border line (accent)
    final topBorder = Paint()
      ..color = isBoss
          ? const Color(0xFFFF4444).withValues(alpha: 0.8)
          : AppColors.mutedPurple.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(size.x, 0), topBorder);

    // Bottom separator
    final bottomBorder = Paint()
      ..color = AppColors.mutedPurple.withValues(alpha: 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.y - 1), Offset(size.x, size.y - 1), bottomBorder);

    // ── LEFT SECTION: Blind name + target label ──
    final blindColor = isBoss ? const Color(0xFFFF6B6B) : AppColors.neonGreen;
    _drawText(
      canvas,
      state.currentBlind.name.toUpperCase(),
      12,
      8,
      TextStyle(
        color: blindColor,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
        shadows: [Shadow(color: blindColor.withValues(alpha: 0.6), blurRadius: 8)],
      ),
    );
    _drawText(
      canvas,
      'Target: ${_fmt(state.currentBlindTarget)}',
      12,
      27,
      TextStyle(
        color: AppColors.neonYellow.withValues(alpha: 0.85),
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );

    // ── CENTER SECTION: Score / Target ──
    final cx = size.x / 2;
    final scoreStr = _fmt(state.runningScore);
    final targetStr = _fmt(state.currentBlindTarget);
    final isComplete = state.runningScore >= state.currentBlindTarget;
    final scoreColor = isComplete ? AppColors.neonGreen : AppColors.neonYellow;

    _drawTextCentered(
      canvas,
      scoreStr,
      cx - 18,
      4,
      TextStyle(
        color: scoreColor,
        fontSize: 24,
        fontWeight: FontWeight.w900,
        shadows: [
          Shadow(color: scoreColor.withValues(alpha: 0.9), blurRadius: 14),
          Shadow(color: scoreColor.withValues(alpha: 0.5), blurRadius: 28),
        ],
      ),
    );
    _drawTextCentered(
      canvas,
      '/',
      cx,
      10,
      TextStyle(
        color: AppColors.textMuted.withValues(alpha: 0.7),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
    _drawTextCentered(
      canvas,
      targetStr,
      cx + 18,
      8,
      const TextStyle(
        color: AppColors.textMuted,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    // Progress bar
    _drawProgressBar(canvas, state.runningScore, state.currentBlindTarget, cx);

    // ── RIGHT SECTION: Money + Ante ──
    _drawTextRight(
      canvas,
      '\$${state.money}',
      size.x - 12,
      6,
      const TextStyle(
        color: AppColors.goldAccent,
        fontSize: 16,
        fontWeight: FontWeight.w900,
        shadows: [Shadow(color: Color(0xFFffd700), blurRadius: 10)],
      ),
    );
    _drawTextRight(
      canvas,
      'ANTE  ${state.ante}',
      size.x - 12,
      27,
      TextStyle(
        color: AppColors.textMuted.withValues(alpha: 0.9),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );

    // ── BOTTOM ROW: Hands + Discards + Hand Preview ──
    const rowY = 50.0;

    // Hands badge
    _drawBadge(
      canvas,
      '♥  Hands: ${state.handsLeft}',
      12,
      rowY,
      AppColors.neonGreen,
      const Color(0xFF0a2e0a),
    );

    // Discards badge
    _drawBadge(
      canvas,
      '✕  Discards: ${state.discardsLeft}',
      120,
      rowY,
      const Color(0xFFFF6B6B),
      const Color(0xFF2e0a0a),
    );

    // Hand preview (right)
    final preview = state.previewHandType;
    if (preview != null) {
      final handName = HandTypeInfo.forType(preview).name;
      _drawBadge(
        canvas,
        handName.toUpperCase(),
        size.x - 12,
        rowY,
        AppColors.neonBlue,
        const Color(0xFF0a1e2e),
        rightAlign: true,
      );
    }
  }

  void _drawProgressBar(Canvas canvas, int current, int target, double cx) {
    const barH = 5.0;
    const barW = 220.0;
    final barY = size.y - barH - 9;
    final barX = cx - barW / 2;
    final ratio = (current / target).clamp(0.0, 1.0);
    final isComplete = ratio >= 1.0;
    final fillColor = isComplete ? AppColors.neonGreen : AppColors.neonYellow;

    // Track
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(barX, barY, barW, barH),
        const Radius.circular(3),
      ),
      Paint()..color = AppColors.mutedPurple.withValues(alpha: 0.35),
    );

    if (ratio > 0) {
      // Glow layer
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barX - 1, barY - 1, barW * ratio + 2, barH + 2),
          const Radius.circular(4),
        ),
        Paint()..color = fillColor.withValues(alpha: 0.25),
      );
      // Fill
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(barX, barY, barW * ratio, barH),
          const Radius.circular(3),
        ),
        Paint()..color = fillColor,
      );
    }
  }

  void _drawBadge(
    Canvas canvas,
    String text,
    double x,
    double y,
    Color accent,
    Color bg, {
    bool rightAlign = false,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: accent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    const padH = 6.0;
    const padV = 3.0;
    final bw = tp.width + padH * 2;
    final bh = tp.height + padV * 2;
    final bx = rightAlign ? x - bw : x;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(bx, y, bw, bh),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, Paint()..color = bg);
    canvas.drawRRect(
      rect,
      Paint()
        ..color = accent.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    tp.paint(canvas, Offset(bx + padH, y + padV));
  }

  String _fmt(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style) {
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

/// Draws the Chips × Mult = Score formula in a prominent pill layout.
class ScoreFormulaComponent extends PositionComponent {
  ScoreFormulaComponent({
    required this.gameManager,
    super.position,
    super.size,
  });

  final GameManager gameManager;
  int displayChips = 0;
  int displayMult = 0;

  // Pill dimensions
  static const double _pillW = 110.0;
  static const double _pillH = 44.0;

  @override
  void render(Canvas canvas) {
    // Subtle background
    final bgPaint = Paint()
      ..color = AppColors.background.withValues(alpha: 0.75);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    // Thin top separator
    canvas.drawLine(
      Offset.zero,
      Offset(size.x, 0),
      Paint()
        ..color = AppColors.mutedPurple.withValues(alpha: 0.4)
        ..strokeWidth = 1,
    );

    final cx = size.x / 2;
    final cy = size.y / 2;

    if (displayChips > 0 || displayMult > 0) {
      // Operator symbol width for layout
      const opW = 24.0;
      const eqW = 18.0;
      const spacing = 8.0;

      // Layout: [CHIPS pill] × [MULT pill] = [RESULT]
      final totalContentW = _pillW + opW + _pillW + eqW + spacing * 3 + 80;
      double x = cx - totalContentW / 2;

      // Chips pill
      _drawPill(
        canvas,
        'CHIPS',
        '$displayChips',
        Offset(x, cy - _pillH / 2),
        AppColors.neonBlue,
        const Color(0xFF041828),
      );
      x += _pillW + spacing;

      // × operator
      _drawTextCentered(
        canvas,
        '×',
        x + opW / 2,
        cy - 13,
        const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      );
      x += opW + spacing;

      // Mult pill
      _drawPill(
        canvas,
        'MULT',
        '$displayMult',
        Offset(x, cy - _pillH / 2),
        const Color(0xFFFF4444),
        const Color(0xFF280404),
      );
      x += _pillW + spacing;

      // = operator
      _drawTextCentered(
        canvas,
        '=',
        x + eqW / 2,
        cy - 12,
        TextStyle(
          color: AppColors.textMuted.withValues(alpha: 0.8),
          fontSize: 20,
          fontWeight: FontWeight.w900,
        ),
      );
      x += eqW + spacing;

      // Result (large gold text)
      final result = displayChips * displayMult;
      final resultStr = _fmt(result);
      _drawText(
        canvas,
        resultStr,
        x,
        cy - 17,
        const TextStyle(
          color: AppColors.neonYellow,
          fontSize: 28,
          fontWeight: FontWeight.w900,
          shadows: [
            Shadow(color: AppColors.neonYellow, blurRadius: 16),
            Shadow(color: Color(0xFFffd700), blurRadius: 32),
          ],
        ),
      );
    } else {
      // No active play – show hand preview or prompt
      final preview = gameManager.state.previewHandType;
      if (preview != null) {
        final info = HandTypeInfo.forType(preview);
        // Hand type name (center, large)
        _drawTextCentered(
          canvas,
          info.name.toUpperCase(),
          cx,
          cy - 16,
          const TextStyle(
            color: AppColors.neonBlue,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        );
        // Base chips × mult hint
        _drawTextCentered(
          canvas,
          '${info.baseChips} chips  ×  ${info.baseMult} mult',
          cx,
          cy + 2,
          TextStyle(
            color: AppColors.textMuted.withValues(alpha: 0.75),
            fontSize: 11,
          ),
        );
      } else {
        _drawTextCentered(
          canvas,
          'Select up to 5 cards to play',
          cx,
          cy - 8,
          TextStyle(
            color: AppColors.textMuted.withValues(alpha: 0.6),
            fontSize: 11,
            fontStyle: FontStyle.italic,
          ),
        );
      }
    }
  }

  void _drawPill(
    Canvas canvas,
    String label,
    String value,
    Offset origin,
    Color accent,
    Color bg,
  ) {
    // Shadow / glow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(origin.dx - 2, origin.dy - 2, _pillW + 4, _pillH + 4),
        const Radius.circular(9),
      ),
      Paint()..color = accent.withValues(alpha: 0.2),
    );

    // Background
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(origin.dx, origin.dy, _pillW, _pillH),
      const Radius.circular(7),
    );
    canvas.drawRRect(rect, Paint()..color = bg);

    // Border
    canvas.drawRRect(
      rect,
      Paint()
        ..color = accent.withValues(alpha: 0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Label (small, top)
    final labelPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: accent.withValues(alpha: 0.85),
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      Offset(origin.dx + (_pillW - labelPainter.width) / 2, origin.dy + 5),
    );

    // Value (large, center)
    final valuePainter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: accent,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          shadows: [Shadow(color: accent.withValues(alpha: 0.7), blurRadius: 8)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    valuePainter.paint(
      canvas,
      Offset(
        origin.dx + (_pillW - valuePainter.width) / 2,
        origin.dy + 18,
      ),
    );
  }

  String _fmt(int value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}K';
    return '$value';
  }

  void _drawText(Canvas canvas, String text, double x, double y, TextStyle style) {
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

  void refresh() {}
}
