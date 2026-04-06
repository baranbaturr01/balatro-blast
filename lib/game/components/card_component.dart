import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/painters/card_painter.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

/// A single playing card rendered on the Flame canvas.
class CardComponent extends PositionComponent with TapCallbacks {
  CardComponent({
    required this.card,
    required this.onTapped,
    super.position,
  }) : super(size: Vector2(kCardWidth, kCardHeight));

  final PlayingCard card;
  final void Function(PlayingCard) onTapped;

  @override
  void render(Canvas canvas) {
    final painter = CardFacePainter(card: card);
    painter.paint(canvas, Size(size.x, size.y));
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTapped(card);
  }
}
