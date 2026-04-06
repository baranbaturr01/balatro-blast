import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

class _JokerResult {
  const _JokerResult({required this.chips, required this.mult});
  final int chips;
  final int mult;
}

/// Applies all joker effects to a base chips+mult pair.
class JokerEngine {
  const JokerEngine();

  _JokerResult apply({
    required int chips,
    required int mult,
    required List<JokerCard> jokers,
    required HandType handType,
    required List<PlayingCard> scoredCards,
    required int playedCardCount,
  }) {
    int c = chips;
    int m = mult;

    // Pass 1: addChips jokers
    for (final joker in jokers) {
      c += _getChipBonus(
        joker,
        handType: handType,
        scoredCards: scoredCards,
      );
    }

    // Pass 2: addMult jokers
    for (final joker in jokers) {
      m += _getAddMult(
        joker,
        handType: handType,
        scoredCards: scoredCards,
        playedCardCount: playedCardCount,
      );
    }

    // Pass 3: multiplyMult jokers
    for (final joker in jokers) {
      m = (m * _getMultMultiplier(joker, handType: handType)).round();
    }

    return _JokerResult(chips: c, mult: m);
  }

  int _getChipBonus(
    JokerCard joker, {
    required HandType handType,
    required List<PlayingCard> scoredCards,
  }) {
    switch (joker.type) {
      case JokerType.sly:
        return _handContains(handType, [HandType.pair, HandType.twoPair,
            HandType.fullHouse]) ? 50 : 0;
      case JokerType.wily:
        return _handContains(handType, [HandType.threeOfAKind,
            HandType.fullHouse]) ? 100 : 0;
      case JokerType.clever:
        return handType == HandType.twoPair ? 80 : 0;
      case JokerType.devious:
        return _isStraightType(handType) ? 100 : 0;
      case JokerType.crafty:
        return _isFlushType(handType) ? 80 : 0;
      default:
        return 0;
    }
  }

  int _getAddMult(
    JokerCard joker, {
    required HandType handType,
    required List<PlayingCard> scoredCards,
    required int playedCardCount,
  }) {
    switch (joker.type) {
      case JokerType.greedy:
        return scoredCards
            .where((c) => c.suit == Suit.diamonds)
            .length * 3;
      case JokerType.lusty:
        return scoredCards
            .where((c) => c.suit == Suit.hearts)
            .length * 3;
      case JokerType.wrathful:
        return scoredCards
            .where((c) => c.suit == Suit.spades)
            .length * 3;
      case JokerType.gluttonous:
        return scoredCards
            .where((c) => c.suit == Suit.clubs)
            .length * 3;
      case JokerType.jolly:
        return _handContains(handType, [HandType.pair, HandType.twoPair,
            HandType.fullHouse]) ? 8 : 0;
      case JokerType.zany:
        return _handContains(handType, [HandType.threeOfAKind,
            HandType.fullHouse]) ? 12 : 0;
      case JokerType.mad:
        return handType == HandType.twoPair ? 10 : 0;
      case JokerType.crazy:
        return _isStraightType(handType) ? 12 : 0;
      case JokerType.droll:
        return _isFlushType(handType) ? 10 : 0;
      case JokerType.half:
        return playedCardCount <= 3 ? 20 : 0;
      default:
        return 0;
    }
  }

  double _getMultMultiplier(
    JokerCard joker, {
    required HandType handType,
  }) {
    switch (joker.type) {
      case JokerType.duo:
        return _handContains(handType, [HandType.pair, HandType.twoPair,
            HandType.fullHouse]) ? 2.0 : 1.0;
      case JokerType.trio:
        return _handContains(handType, [HandType.threeOfAKind,
            HandType.fullHouse]) ? 3.0 : 1.0;
      case JokerType.family:
        return handType == HandType.fourOfAKind ? 4.0 : 1.0;
      case JokerType.order:
        return _isStraightType(handType) ? 3.0 : 1.0;
      case JokerType.tribe:
        return _isFlushType(handType) ? 2.0 : 1.0;
      default:
        return 1.0;
    }
  }

  bool _handContains(HandType handType, List<HandType> types) =>
      types.contains(handType);

  bool _isStraightType(HandType t) =>
      t == HandType.straight ||
      t == HandType.straightFlush ||
      t == HandType.royalFlush;

  bool _isFlushType(HandType t) =>
      t == HandType.flush ||
      t == HandType.straightFlush ||
      t == HandType.royalFlush;
}
