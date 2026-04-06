import 'package:flutter_test/flutter_test.dart';
import 'package:balatro_blast/engine/scoring_engine.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

void main() {
  final engine = ScoringEngine();

  group('ScoringEngine', () {
    // ---------------------------------------------------------------------------
    // Base hand scoring (no jokers)
    // ---------------------------------------------------------------------------

    test('High Card base score', () {
      final cards = [PlayingCard(suit: Suit.hearts, rank: Rank.ace)];
      final result = engine.calculate(cards, []);
      // Base: 5 chips, 1 mult. Ace = 11 chips.
      expect(result.chips, 5 + 11);
      expect(result.mult, 1);
      expect(result.score, (5 + 11) * 1);
    });

    test('Pair base score', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
        PlayingCard(suit: Suit.clubs, rank: Rank.king),
        PlayingCard(suit: Suit.spades, rank: Rank.two),
      ];
      final result = engine.calculate(cards, []);
      expect(result.handType, HandType.pair);
      // Base: 10 chips, mult 2. Scored: K+K = 10+10=20 chips.
      expect(result.chips, 10 + 20);
      expect(result.mult, 2);
    });

    test('Three of a Kind base score', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.five),
        PlayingCard(suit: Suit.clubs, rank: Rank.five),
        PlayingCard(suit: Suit.spades, rank: Rank.five),
      ];
      final result = engine.calculate(cards, []);
      expect(result.handType, HandType.threeOfAKind);
      // Base: 30 chips, 3 mult. 5+5+5=15 chips from cards.
      expect(result.chips, 30 + 15);
      expect(result.mult, 3);
    });

    test('Flush base score', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.two),
        PlayingCard(suit: Suit.hearts, rank: Rank.four),
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.hearts, rank: Rank.eight),
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
      ];
      final result = engine.calculate(cards, []);
      expect(result.handType, HandType.flush);
      // Base: 35 chips, 4 mult. Card chips: 2+4+6+8+10=30.
      expect(result.chips, 35 + 30);
      expect(result.mult, 4);
    });

    // ---------------------------------------------------------------------------
    // Card chip contributions
    // ---------------------------------------------------------------------------

    test('Ace contributes 11 chips', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.ace),
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
      ];
      final result = engine.calculate(cards, []);
      // Pair base = 10. Aces = 11+11 = 22. Total = 32 chips.
      expect(result.chips, 10 + 22);
    });

    test('Face cards contribute 10 chips each', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.jack),
        PlayingCard(suit: Suit.clubs, rank: Rank.jack),
      ];
      final result = engine.calculate(cards, []);
      expect(result.chips, 10 + 10 + 10); // base + J + J
    });

    // ---------------------------------------------------------------------------
    // Joker effects stacking
    // ---------------------------------------------------------------------------

    test('Additive mult jokers stack', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.seven),
        PlayingCard(suit: Suit.clubs, rank: Rank.seven),
        PlayingCard(suit: Suit.spades, rank: Rank.two),
      ];
      const jolly = JokerCard(
        type: JokerType.jolly,
        name: 'Jolly Joker',
        description: '+8 Mult if pair',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final result = engine.calculate(cards, [jolly]);
      expect(result.handType, HandType.pair);
      // Base mult: 2. Jolly: +8. Total: 10.
      expect(result.mult, 2 + 8);
    });

    test('Multiple additive mult jokers stack correctly', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.three),
        PlayingCard(suit: Suit.clubs, rank: Rank.three),
        PlayingCard(suit: Suit.spades, rank: Rank.two),
      ];
      const jolly = JokerCard(
        type: JokerType.jolly,
        name: 'Jolly Joker',
        description: '+8 Mult if pair',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      // Two Jolly Jokers (hypothetical duplicate).
      final result = engine.calculate(cards, [jolly, jolly]);
      expect(result.mult, 2 + 8 + 8);
    });

    test('Additive chip joker (Sly Joker)', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.jack),
        PlayingCard(suit: Suit.clubs, rank: Rank.jack),
        PlayingCard(suit: Suit.spades, rank: Rank.five),
      ];
      const sly = JokerCard(
        type: JokerType.sly,
        name: 'Sly Joker',
        description: '+50 Chips if pair',
        cost: 6,
        effectType: JokerEffectType.addChips,
      );
      final result = engine.calculate(cards, [sly]);
      // Chips: 10 (base pair) + 10 + 10 (jacks) + 50 (sly) = 80.
      expect(result.chips, 10 + 20 + 50);
    });

    test('Multiplicative mult joker (The Duo)', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
        PlayingCard(suit: Suit.clubs, rank: Rank.ace),
        PlayingCard(suit: Suit.spades, rank: Rank.two),
      ];
      const duo = JokerCard(
        type: JokerType.duo,
        name: 'The Duo',
        description: '×2 Mult if pair',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final result = engine.calculate(cards, [duo]);
      // Base mult: 2. Duo ×2 → 4.
      expect(result.mult, 4);
    });

    test('Additive then multiplicative jokers combine correctly', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.nine),
        PlayingCard(suit: Suit.clubs, rank: Rank.nine),
        PlayingCard(suit: Suit.spades, rank: Rank.five),
      ];
      const jolly = JokerCard(
        type: JokerType.jolly,
        name: 'Jolly Joker',
        description: '+8 Mult if pair',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      const duo = JokerCard(
        type: JokerType.duo,
        name: 'The Duo',
        description: '×2 Mult if pair',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final result = engine.calculate(cards, [jolly, duo]);
      // Base mult: 2. +8 = 10. ×2 = 20.
      expect(result.mult, 20);
    });

    // ---------------------------------------------------------------------------
    // Score formula
    // ---------------------------------------------------------------------------

    test('score = chips × mult', () {
      final cards = [PlayingCard(suit: Suit.hearts, rank: Rank.ace)];
      final result = engine.calculate(cards, []);
      expect(result.score, result.chips * result.mult);
    });

    // ---------------------------------------------------------------------------
    // Hand level upgrades
    // ---------------------------------------------------------------------------

    test('Planet card level bonuses apply', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
        PlayingCard(suit: Suit.clubs, rank: Rank.king),
      ];
      final resultBase = engine.calculate(cards, []);
      final resultUpgraded = engine.calculate(
        cards,
        [],
        handLevels: {'pair': 2},
      );
      // Level 2 = +30 chips, +2 mult over base.
      expect(resultUpgraded.chips, resultBase.chips + 30);
      expect(resultUpgraded.mult, resultBase.mult + 2);
    });
  });
}
