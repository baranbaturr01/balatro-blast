import 'package:balatro_blast/engine/poker_evaluator.dart';
import 'package:balatro_blast/engine/joker_engine.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

class ScoringResult {
  const ScoringResult({
    required this.chips,
    required this.mult,
    required this.handType,
    required this.scoredCards,
  });

  final int chips;
  final int mult;
  final HandType handType;
  final List<PlayingCard> scoredCards;

  int get score => chips * mult;

  @override
  String toString() =>
      '${handType.name}: $chips chips × $mult mult = $score';
}

class ScoringEngine {
  ScoringEngine({
    PokerEvaluator? evaluator,
    JokerEngine? jokerEngine,
  })  : _evaluator = evaluator ?? const PokerEvaluator(),
        _jokerEngine = jokerEngine ?? const JokerEngine();

  final PokerEvaluator _evaluator;
  final JokerEngine _jokerEngine;

  /// Calculates the full scoring result for the played cards and active jokers.
  ScoringResult calculate(
    List<PlayingCard> playedCards,
    List<JokerCard> jokers, {
    Map<String, int> handLevels = const {},
  }) {
    final evalResult = _evaluator.evaluate(playedCards);
    final handInfo = HandTypeInfo.forType(evalResult.handType);

    final levelBonus = _getLevelBonus(evalResult.handType, handLevels);

    int chips = handInfo.baseChips + levelBonus.chips;
    int mult = handInfo.baseMult + levelBonus.mult;

    // Add chip values from scored cards.
    for (final card in evalResult.scoredCards) {
      chips += card.chipValue;
    }

    // Apply joker effects.
    final afterJokers = _jokerEngine.apply(
      chips: chips,
      mult: mult,
      jokers: jokers,
      handType: evalResult.handType,
      scoredCards: evalResult.scoredCards,
      playedCardCount: playedCards.length,
    );

    return ScoringResult(
      chips: afterJokers.chips,
      mult: afterJokers.mult,
      handType: evalResult.handType,
      scoredCards: evalResult.scoredCards,
    );
  }

  ({int chips, int mult}) _getLevelBonus(
      HandType type, Map<String, int> handLevels) {
    final level = handLevels[type.name] ?? 0;
    return (
      chips: level * 15,
      mult: level,
    );
  }
}
