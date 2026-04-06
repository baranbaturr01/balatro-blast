import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/components/card_component.dart';
import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/utils/constants.dart';

/// Manages and displays the player's hand of cards in a horizontal layout.
class HandComponent extends PositionComponent {
  HandComponent({
    required this.gameManager,
    required this.onCardTapped,
    super.position,
    super.size,
  });

  final GameManager gameManager;
  final void Function(PlayingCard) onCardTapped;

  final List<CardComponent> _cardComponents = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await refresh();
  }

  Future<void> refresh() async {
    // Remove all existing card components.
    removeAll(_cardComponents);
    _cardComponents.clear();

    final hand = gameManager.state.hand;
    if (hand.isEmpty) return;

    final totalWidth = size.x;
    final cardSpacing = hand.length <= 5
        ? (kCardWidth + 8.0)
        : (totalWidth - kCardWidth) / (hand.length - 1);

    final startX = hand.length <= 5
        ? (totalWidth - hand.length * (kCardWidth + 8)) / 2
        : 4.0;

    for (int i = 0; i < hand.length; i++) {
      final card = hand[i];
      final cardX = startX + i * cardSpacing;
      final cardY = card.isSelected ? 0.0 : kCardSelectedOffset;

      final component = CardComponent(
        card: card,
        onTapped: onCardTapped,
        position: Vector2(cardX, cardY),
      );
      _cardComponents.add(component);
    }

    await addAll(_cardComponents);
  }

  @override
  void render(Canvas canvas) {
    // Draw action buttons below the hand.
    _drawActionButtons(canvas);
    super.render(canvas);
  }

  void _drawActionButtons(Canvas canvas) {
    // These are rendered as overlapping Flutter widgets in GameScreen;
    // this stub exists for layout reference only.
  }
}
