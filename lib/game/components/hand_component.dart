import 'package:flame/components.dart';

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
    removeAll(_cardComponents);
    _cardComponents.clear();

    final hand = gameManager.state.hand;
    if (hand.isEmpty) return;

    final totalWidth = size.x;
    // Ensure cards fit within the component width with padding.
    const padding = 8.0;
    final available = totalWidth - padding * 2;
    // Spacing between card left edges: spread them evenly.
    final spacing = hand.length <= 1
        ? 0.0
        : (available - kCardWidth) / (hand.length - 1);
    final clampedSpacing = spacing.clamp(0.0, kCardWidth + 12.0);
    final totalCardWidth = kCardWidth + clampedSpacing * (hand.length - 1);
    final startX = (totalWidth - totalCardWidth) / 2;

    for (int i = 0; i < hand.length; i++) {
      final card = hand[i];
      final cardX = startX + i * clampedSpacing;
      // Unselected cards are pushed down; selected cards float up.
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
}
