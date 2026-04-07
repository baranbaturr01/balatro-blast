import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/painters/card_back_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

// ---------------------------------------------------------------------------
// Pip position definitions.
// x, y are in 0..1 range relative to the pip drawing area.
// flip=true rotates the symbol 180° (used for bottom-half pips on real cards).
// Positions follow traditional poker card pip layouts.
// ---------------------------------------------------------------------------
class _Pip {
  const _Pip(this.x, this.y, {this.flip = false});
  final double x;
  final double y;
  final bool flip;
}

/// Traditional pip layouts for number cards (rank value → pip list).
const Map<int, List<_Pip>> _kPipLayouts = {
  2: [
    _Pip(0.50, 0.19),
    _Pip(0.50, 0.81, flip: true),
  ],
  3: [
    _Pip(0.50, 0.14),
    _Pip(0.50, 0.50),
    _Pip(0.50, 0.86, flip: true),
  ],
  4: [
    _Pip(0.27, 0.20),
    _Pip(0.73, 0.20),
    _Pip(0.27, 0.80, flip: true),
    _Pip(0.73, 0.80, flip: true),
  ],
  5: [
    _Pip(0.27, 0.20),
    _Pip(0.73, 0.20),
    _Pip(0.50, 0.50),
    _Pip(0.27, 0.80, flip: true),
    _Pip(0.73, 0.80, flip: true),
  ],
  6: [
    _Pip(0.27, 0.20),
    _Pip(0.73, 0.20),
    _Pip(0.27, 0.50),
    _Pip(0.73, 0.50),
    _Pip(0.27, 0.80, flip: true),
    _Pip(0.73, 0.80, flip: true),
  ],
  7: [
    _Pip(0.27, 0.16),
    _Pip(0.73, 0.16),
    _Pip(0.50, 0.33),
    _Pip(0.27, 0.52),
    _Pip(0.73, 0.52),
    _Pip(0.27, 0.84, flip: true),
    _Pip(0.73, 0.84, flip: true),
  ],
  8: [
    _Pip(0.27, 0.14),
    _Pip(0.73, 0.14),
    _Pip(0.50, 0.31),
    _Pip(0.27, 0.50),
    _Pip(0.73, 0.50),
    _Pip(0.50, 0.69, flip: true),
    _Pip(0.27, 0.86, flip: true),
    _Pip(0.73, 0.86, flip: true),
  ],
  9: [
    _Pip(0.27, 0.13),
    _Pip(0.73, 0.13),
    _Pip(0.27, 0.36),
    _Pip(0.73, 0.36),
    _Pip(0.50, 0.50),
    _Pip(0.27, 0.64, flip: true),
    _Pip(0.73, 0.64, flip: true),
    _Pip(0.27, 0.87, flip: true),
    _Pip(0.73, 0.87, flip: true),
  ],
  10: [
    _Pip(0.27, 0.12),
    _Pip(0.73, 0.12),
    _Pip(0.50, 0.27),
    _Pip(0.27, 0.40),
    _Pip(0.73, 0.40),
    _Pip(0.27, 0.60, flip: true),
    _Pip(0.73, 0.60, flip: true),
    _Pip(0.50, 0.73, flip: true),
    _Pip(0.27, 0.88, flip: true),
    _Pip(0.73, 0.88, flip: true),
  ],
};

const Map<int, String> _kFaceNames = {11: 'JACK', 12: 'QUEEN', 13: 'KING'};

// ---------------------------------------------------------------------------
// CardFacePainter – renders a professional poker-style card face via Canvas.
// ---------------------------------------------------------------------------
class CardFacePainter extends CustomPainter {
  CardFacePainter({required this.card});

  final PlayingCard card;

  // Corner label geometry
  static const double _cPadX = 5.0;
  static const double _cPadY = 4.0;
  static const double _rankFontSize = 14.5;
  static const double _suitCornerFontSize = 11.5;

  // Height occupied by the corner block (rank + suit + padding above them)
  static const double _cornerBlockH = _cPadY + _rankFontSize + 2.0 + _suitCornerFontSize + 4.0;

  // Horizontal margin for pip/center area
  static const double _areaMarginX = 9.0;

  Color get _suitColor => card.isRed ? AppColors.cardRed : AppColors.cardBlack;

  @override
  void paint(Canvas canvas, Size size) {
    _drawShadow(canvas, size);
    _drawBackground(canvas, size);
    _drawScoredGlow(canvas, size);
    _drawSelectedGlow(canvas, size);
    _drawBorder(canvas, size);
    _drawContent(canvas, size);
  }

  // ── Shadow ──────────────────────────────────────────────────────────────

  void _drawShadow(Canvas canvas, Size size) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2.5, 4.0, size.width, size.height),
        const Radius.circular(kCardRadius),
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.48)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
  }

  // ── Card background with subtle gradient ────────────────────────────────

  void _drawBackground(Canvas canvas, Size size) {
    final rect = _cardRRect(size);
    canvas.drawRRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFEDEDEB)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  // ── Scored golden glow ──────────────────────────────────────────────────

  void _drawScoredGlow(Canvas canvas, Size size) {
    if (!card.isScored) return;
    final rect = _cardRRect(size);
    const c = AppColors.goldAccent;
    // 4-layer glow
    for (int i = 4; i >= 1; i--) {
      canvas.drawRRect(
        rect,
        Paint()
          ..color = c.withValues(alpha: 0.09 * i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = i * 2.5
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, i * 4.5),
      );
    }
    canvas.drawRRect(
      rect,
      Paint()
        ..color = c
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
  }

  // ── Selected neon-cyan glow (4-layer bloom) ─────────────────────────────

  void _drawSelectedGlow(Canvas canvas, Size size) {
    if (!card.isSelected) return;
    final rect = _cardRRect(size);
    const c = AppColors.neonBlue;

    // Layer 1 – wide diffuse bloom
    canvas.drawRRect(rect,
        Paint()
          ..color = c.withValues(alpha: 0.07)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 14));
    // Layer 2
    canvas.drawRRect(rect,
        Paint()
          ..color = c.withValues(alpha: 0.14)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8));
    // Layer 3
    canvas.drawRRect(rect,
        Paint()
          ..color = c.withValues(alpha: 0.28)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4));
    // Layer 4 – tight inner glow
    canvas.drawRRect(rect,
        Paint()
          ..color = c.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2));
    // Solid bright border on top of glow
    canvas.drawRRect(rect,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0);
  }

  // ── Card border (only when no special state) ────────────────────────────

  void _drawBorder(Canvas canvas, Size size) {
    if (card.isSelected || card.isScored) return;
    canvas.drawRRect(
      _cardRRect(size),
      Paint()
        ..color = const Color(0xFF9A9A9A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  // ── Content dispatcher ──────────────────────────────────────────────────

  void _drawContent(Canvas canvas, Size size) {
    final color = _suitColor;
    final rankStr = card.rank.displayName;
    final suitStr = card.suit.symbol;
    final rankValue = card.rank.value;

    _drawCornerLabels(canvas, size, rankStr, suitStr, color);

    if (rankValue == 14) {
      _drawAce(canvas, size, suitStr, color);
    } else if (rankValue >= 11) {
      _drawFaceCard(canvas, size, suitStr, color, rankValue);
    } else {
      _drawPips(canvas, size, suitStr, color, rankValue);
    }
  }

  // ── Corner rank + suit labels ───────────────────────────────────────────

  void _drawCornerLabels(Canvas canvas, Size size, String rankStr,
      String suitStr, Color color) {
    final rankStyle = TextStyle(
      color: color,
      fontSize: _rankFontSize,
      fontWeight: FontWeight.w900,
      height: 1.0,
    );
    final suitStyle = TextStyle(
      color: color,
      fontSize: _suitCornerFontSize,
      height: 1.0,
    );

    // Top-left
    _drawText(canvas, rankStr, _cPadX, _cPadY, rankStyle);
    _drawText(canvas, suitStr, _cPadX + 1, _cPadY + _rankFontSize + 2, suitStyle);

    // Bottom-right (rotated 180°)
    canvas.save();
    canvas.translate(size.width, size.height);
    canvas.rotate(math.pi);
    _drawText(canvas, rankStr, _cPadX, _cPadY, rankStyle);
    _drawText(canvas, suitStr, _cPadX + 1, _cPadY + _rankFontSize + 2, suitStyle);
    canvas.restore();
  }

  // ── Ace: single large ornate symbol ────────────────────────────────────

  void _drawAce(Canvas canvas, Size size, String suitStr, Color color) {
    _drawDecorativeInnerFrame(canvas, size, color);
    _drawTextCentered(
      canvas,
      suitStr,
      size.width / 2,
      size.height / 2,
      TextStyle(color: color, fontSize: 44.0, height: 1.0),
    );
  }

  // ── Face cards (J/Q/K): large suit + full name + corner accents ─────────

  void _drawFaceCard(Canvas canvas, Size size, String suitStr, Color color,
      int rankValue) {
    _drawDecorativeInnerFrame(canvas, size, color);
    _drawFaceCornerAccents(canvas, size, suitStr, color);

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Large central suit symbol
    _drawTextCentered(
      canvas,
      suitStr,
      cx,
      cy - 11,
      TextStyle(color: color, fontSize: 34.0, height: 1.0),
    );

    // Full face name below symbol
    final faceLabel = _kFaceNames[rankValue] ?? '';
    _drawTextCentered(
      canvas,
      faceLabel,
      cx,
      cy + 21,
      TextStyle(
        color: color,
        fontSize: 7.5,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.0,
        height: 1.0,
      ),
    );
  }

  /// Subtle suit symbols in the four inner corners for face cards and aces.
  void _drawFaceCornerAccents(Canvas canvas, Size size, String suitStr,
      Color color) {
    const accentFontSize = 9.0;
    final style = TextStyle(
      color: color.withValues(alpha: 0.32),
      fontSize: accentFontSize,
      height: 1.0,
    );
    const insetX = 15.0;
    final topY = _cornerBlockH + 4;
    final bottomY = size.height - _cornerBlockH - 4;

    _drawTextCentered(canvas, suitStr, insetX, topY, style);
    _drawTextCentered(canvas, suitStr, size.width - insetX, topY, style);

    canvas.save();
    canvas.translate(size.width - insetX, bottomY);
    canvas.rotate(math.pi);
    _drawTextCentered(canvas, suitStr, 0, 0, style);
    canvas.restore();

    canvas.save();
    canvas.translate(insetX, bottomY);
    canvas.rotate(math.pi);
    _drawTextCentered(canvas, suitStr, 0, 0, style);
    canvas.restore();
  }

  /// Thin decorative inner border for face/ace cards.
  void _drawDecorativeInnerFrame(Canvas canvas, Size size, Color color) {
    const inset = 5.0;
    final top = _cornerBlockH - 4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(inset, top, size.width - inset, size.height - top),
        const Radius.circular(4),
      ),
      Paint()
        ..color = color.withValues(alpha: 0.13)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );
  }

  // ── Number card pips (2-10) ──────────────────────────────────────────────

  void _drawPips(Canvas canvas, Size size, String suitStr, Color color,
      int rankValue) {
    final pips = _kPipLayouts[rankValue];
    if (pips == null) return;

    // Pip drawing area (between the two corner blocks)
    const marginTop = _cornerBlockH + 1.0;
    const marginBot = _cornerBlockH + 1.0;
    final areaW = size.width - _areaMarginX * 2;
    final areaH = size.height - marginTop - marginBot;

    const pipFontSize = 13.0;
    final pipStyle = TextStyle(color: color, fontSize: pipFontSize, height: 1.0);

    for (final pip in pips) {
      final px = _areaMarginX + pip.x * areaW;
      final py = marginTop + pip.y * areaH;

      if (pip.flip) {
        canvas.save();
        canvas.translate(px, py);
        canvas.rotate(math.pi);
        _drawTextCentered(canvas, suitStr, 0, 0, pipStyle);
        canvas.restore();
      } else {
        _drawTextCentered(canvas, suitStr, px, py, pipStyle);
      }
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  RRect _cardRRect(Size size) => RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(kCardRadius),
      );

  void _drawText(Canvas canvas, String text, double x, double y,
      TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x, y));
  }

  void _drawTextCentered(Canvas canvas, String text, double cx, double cy,
      TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  @override
  bool shouldRepaint(CardFacePainter oldDelegate) =>
      oldDelegate.card.isSelected != card.isSelected ||
      oldDelegate.card.isScored != card.isScored ||
      oldDelegate.card != card;
}

// ---------------------------------------------------------------------------
// CardWidget – tap-enabled card with smooth selection lift animation.
// ---------------------------------------------------------------------------
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
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
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
