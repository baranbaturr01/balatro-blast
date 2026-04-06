import 'package:flutter_test/flutter_test.dart';
import 'package:balatro_blast/engine/joker_engine.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

void main() {
  const engine = JokerEngine();

  _JokerResult apply({
    required int chips,
    required int mult,
    required List<JokerCard> jokers,
    required HandType handType,
    List<PlayingCard>? scoredCards,
    int playedCardCount = 5,
  }) {
    final result = engine.apply(
      chips: chips,
      mult: mult,
      jokers: jokers,
      handType: handType,
      scoredCards: scoredCards ?? [],
      playedCardCount: playedCardCount,
    );
    return (chips: result.chips, mult: result.mult);
  }

  group('JokerEngine — suit jokers', () {
    test('Greedy Joker: +3 mult per Diamond scored', () {
      final diamonds = [
        PlayingCard(suit: Suit.diamonds, rank: Rank.ace),
        PlayingCard(suit: Suit.diamonds, rank: Rank.king),
      ];
      const greedy = JokerCard(
        type: JokerType.greedy,
        name: 'Greedy Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 10,
        mult: 2,
        jokers: [greedy],
        handType: HandType.pair,
        scoredCards: diamonds,
      );
      // 2 diamonds × 3 = +6 mult.
      expect(r.mult, 2 + 6);
    });

    test('Lusty Joker: +3 mult per Heart scored', () {
      final hearts = [
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
        PlayingCard(suit: Suit.spades, rank: Rank.queen),
      ];
      const lusty = JokerCard(
        type: JokerType.lusty,
        name: 'Lusty Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 10,
        mult: 2,
        jokers: [lusty],
        handType: HandType.pair,
        scoredCards: hearts,
      );
      // 2 hearts × 3 = +6 mult.
      expect(r.mult, 2 + 6);
    });

    test('Wrathful Joker: +3 mult per Spade scored', () {
      final spades = [
        PlayingCard(suit: Suit.spades, rank: Rank.five),
      ];
      const wrathful = JokerCard(
        type: JokerType.wrathful,
        name: 'Wrathful Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 10,
        mult: 3,
        jokers: [wrathful],
        handType: HandType.threeOfAKind,
        scoredCards: spades,
      );
      expect(r.mult, 3 + 3);
    });

    test('Gluttonous Joker: +3 mult per Club scored', () {
      final clubs = [
        PlayingCard(suit: Suit.clubs, rank: Rank.two),
        PlayingCard(suit: Suit.clubs, rank: Rank.three),
        PlayingCard(suit: Suit.clubs, rank: Rank.four),
      ];
      const gluttonous = JokerCard(
        type: JokerType.gluttonous,
        name: 'Gluttonous Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 10,
        mult: 2,
        jokers: [gluttonous],
        handType: HandType.pair,
        scoredCards: clubs,
      );
      expect(r.mult, 2 + 9); // 3 clubs × 3
    });
  });

  group('JokerEngine — hand-type addMult jokers', () {
    test('Jolly Joker: +8 mult for pair', () {
      const jolly = JokerCard(
        type: JokerType.jolly,
        name: 'Jolly Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 10,
        mult: 2,
        jokers: [jolly],
        handType: HandType.pair,
      );
      expect(r.mult, 2 + 8);
    });

    test('Jolly Joker: no effect on non-pair hand', () {
      const jolly = JokerCard(
        type: JokerType.jolly,
        name: 'Jolly Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 30,
        mult: 4,
        jokers: [jolly],
        handType: HandType.straight,
      );
      expect(r.mult, 4); // no change
    });

    test('Crazy Joker: +12 mult for straight', () {
      const crazy = JokerCard(
        type: JokerType.crazy,
        name: 'Crazy Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 30,
        mult: 4,
        jokers: [crazy],
        handType: HandType.straight,
      );
      expect(r.mult, 4 + 12);
    });

    test('Droll Joker: +10 mult for flush', () {
      const droll = JokerCard(
        type: JokerType.droll,
        name: 'Droll Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addMult,
      );
      final r = apply(
        chips: 35,
        mult: 4,
        jokers: [droll],
        handType: HandType.flush,
      );
      expect(r.mult, 4 + 10);
    });

    test('Half Joker: +20 mult for ≤3 cards', () {
      const half = JokerCard(
        type: JokerType.half,
        name: 'Half Joker',
        description: '',
        cost: 7,
        effectType: JokerEffectType.addMult,
      );
      final r3 = apply(
        chips: 10,
        mult: 2,
        jokers: [half],
        handType: HandType.pair,
        playedCardCount: 3,
      );
      expect(r3.mult, 2 + 20);

      final r5 = apply(
        chips: 10,
        mult: 2,
        jokers: [half],
        handType: HandType.pair,
        playedCardCount: 5,
      );
      expect(r5.mult, 2); // no effect
    });
  });

  group('JokerEngine — addChips jokers', () {
    test('Sly Joker: +50 chips for pair', () {
      const sly = JokerCard(
        type: JokerType.sly,
        name: 'Sly Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addChips,
      );
      final r = apply(
        chips: 30,
        mult: 2,
        jokers: [sly],
        handType: HandType.pair,
      );
      expect(r.chips, 30 + 50);
    });

    test('Wily Joker: +100 chips for three of a kind', () {
      const wily = JokerCard(
        type: JokerType.wily,
        name: 'Wily Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addChips,
      );
      final r = apply(
        chips: 45,
        mult: 3,
        jokers: [wily],
        handType: HandType.threeOfAKind,
      );
      expect(r.chips, 45 + 100);
    });

    test('Devious Joker: +100 chips for straight', () {
      const devious = JokerCard(
        type: JokerType.devious,
        name: 'Devious Joker',
        description: '',
        cost: 6,
        effectType: JokerEffectType.addChips,
      );
      final r = apply(
        chips: 70,
        mult: 4,
        jokers: [devious],
        handType: HandType.straight,
      );
      expect(r.chips, 70 + 100);
    });
  });

  group('JokerEngine — multiplyMult jokers', () {
    test('The Duo: ×2 mult for pair', () {
      const duo = JokerCard(
        type: JokerType.duo,
        name: 'The Duo',
        description: '',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final r = apply(
        chips: 10,
        mult: 2,
        jokers: [duo],
        handType: HandType.pair,
      );
      expect(r.mult, 4);
    });

    test('The Trio: ×3 mult for three of a kind', () {
      const trio = JokerCard(
        type: JokerType.trio,
        name: 'The Trio',
        description: '',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final r = apply(
        chips: 30,
        mult: 3,
        jokers: [trio],
        handType: HandType.threeOfAKind,
      );
      expect(r.mult, 9);
    });

    test('The Family: ×4 mult for four of a kind', () {
      const family = JokerCard(
        type: JokerType.family,
        name: 'The Family',
        description: '',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final r = apply(
        chips: 60,
        mult: 7,
        jokers: [family],
        handType: HandType.fourOfAKind,
      );
      expect(r.mult, 28);
    });

    test('The Order: ×3 mult for straight', () {
      const order = JokerCard(
        type: JokerType.order,
        name: 'The Order',
        description: '',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final r = apply(
        chips: 30,
        mult: 4,
        jokers: [order],
        handType: HandType.straight,
      );
      expect(r.mult, 12);
    });

    test('The Tribe: ×2 mult for flush', () {
      const tribe = JokerCard(
        type: JokerType.tribe,
        name: 'The Tribe',
        description: '',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final r = apply(
        chips: 35,
        mult: 4,
        jokers: [tribe],
        handType: HandType.flush,
      );
      expect(r.mult, 8);
    });

    test('Mult joker does not fire on wrong hand type', () {
      const duo = JokerCard(
        type: JokerType.duo,
        name: 'The Duo',
        description: '',
        cost: 8,
        effectType: JokerEffectType.multiplyMult,
      );
      final r = apply(
        chips: 30,
        mult: 4,
        jokers: [duo],
        handType: HandType.straight, // Duo needs pair
      );
      expect(r.mult, 4); // unchanged
    });
  });
}

typedef _JokerResult = ({int chips, int mult});
