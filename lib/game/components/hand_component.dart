import 'package:flame/components.dart';

import 'package:balatro_blast/game/components/card_component.dart';
import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/utils/constants.dart';

/// Manages and displays the player's hand of cards in a horizontal layout.
///
/// Selected cards float to the top (y = 0) while unselected cards sit
/// at [kCardSelectedOffset] lower.
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

    // Compute inter-card spacing so all cards fit within the component width.
    const padding = 8.0;
    final available = size.x - padding * 2;
    final rawSpacing = hand.length <= 1
        ? 0.0
        : (available - kCardWidth) / (hand.length - 1);
    // Clamp spacing: minimum 30% of card width keeps cards readable and
    // avoids overlapping suit/rank text even at maximum hand size (8 cards).
    final spacing = rawSpacing.clamp(kCardWidth * 0.3, kCardWidth + kMaxCardSpacing);

    // Center the spread within the component.
    final spreadW = kCardWidth + spacing * (hand.length - 1);
    final startX = (size.x - spreadW) / 2;

    for (int i = 0; i < hand.length; i++) {
      final card = hand[i];
      // Selected cards float upward; unselected rest at the lower baseline.
      final cardY = card.isSelected ? 0.0 : kCardSelectedOffset;

      _cardComponents.add(
        CardComponent(
          card: card,
          onTapped: onCardTapped,
          position: Vector2(startX + i * spacing, cardY),
        ),
      );
    }

    await addAll(_cardComponents);
  }
}
