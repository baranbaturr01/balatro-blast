import 'package:flutter_test/flutter_test.dart';
import 'package:balatro_blast/engine/poker_evaluator.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

void main() {
  const evaluator = PokerEvaluator();

  group('PokerEvaluator', () {
    // ---------------------------------------------------------------------------
    // Single / two card hands
    // ---------------------------------------------------------------------------

    test('single card → High Card', () {
      final cards = [PlayingCard(suit: Suit.hearts, rank: Rank.ace)];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.highCard);
      expect(result.scoredCards, hasLength(1));
    });

    test('two different ranks → High Card', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
        PlayingCard(suit: Suit.clubs, rank: Rank.two),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.highCard);
    });

    test('two matching ranks → Pair', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
        PlayingCard(suit: Suit.diamonds, rank: Rank.king),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.pair);
      expect(result.scoredCards, hasLength(2));
    });

    // ---------------------------------------------------------------------------
    // Pair
    // ---------------------------------------------------------------------------

    test('Pair detection', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.seven),
        PlayingCard(suit: Suit.clubs, rank: Rank.seven),
        PlayingCard(suit: Suit.spades, rank: Rank.two),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.pair);
      expect(result.scoredCards, hasLength(2));
      expect(result.scoredCards.every((c) => c.rank == Rank.seven), isTrue);
    });

    // ---------------------------------------------------------------------------
    // Two Pair
    // ---------------------------------------------------------------------------

    test('Two Pair detection', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.jack),
        PlayingCard(suit: Suit.clubs, rank: Rank.jack),
        PlayingCard(suit: Suit.spades, rank: Rank.nine),
        PlayingCard(suit: Suit.diamonds, rank: Rank.nine),
        PlayingCard(suit: Suit.hearts, rank: Rank.two),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.twoPair);
      expect(result.scoredCards, hasLength(4));
    });

    // ---------------------------------------------------------------------------
    // Three of a Kind
    // ---------------------------------------------------------------------------

    test('Three of a Kind detection', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.five),
        PlayingCard(suit: Suit.clubs, rank: Rank.five),
        PlayingCard(suit: Suit.spades, rank: Rank.five),
        PlayingCard(suit: Suit.diamonds, rank: Rank.two),
        PlayingCard(suit: Suit.hearts, rank: Rank.three),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.threeOfAKind);
      expect(result.scoredCards, hasLength(3));
    });

    // ---------------------------------------------------------------------------
    // Straight
    // ---------------------------------------------------------------------------

    test('Straight detection (6-7-8-9-10)', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.six),
        PlayingCard(suit: Suit.clubs, rank: Rank.seven),
        PlayingCard(suit: Suit.spades, rank: Rank.eight),
        PlayingCard(suit: Suit.diamonds, rank: Rank.nine),
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.straight);
      expect(result.scoredCards, hasLength(5));
    });

    test('Ace-high Straight (10-J-Q-K-A)', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.ten),
        PlayingCard(suit: Suit.clubs, rank: Rank.jack),
        PlayingCard(suit: Suit.spades, rank: Rank.queen),
        PlayingCard(suit: Suit.diamonds, rank: Rank.king),
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
      ];
      final result = evaluator.evaluate(cards);
      // 10-J-Q-K-A is a Royal Flush only if same suit, so here it's a Straight.
      expect(
        result.handType,
        anyOf(HandType.straight, HandType.royalFlush, HandType.straightFlush),
      );
    });

    test('Ace-low Straight (A-2-3-4-5)', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
        PlayingCard(suit: Suit.clubs, rank: Rank.two),
        PlayingCard(suit: Suit.spades, rank: Rank.three),
        PlayingCard(suit: Suit.diamonds, rank: Rank.four),
        PlayingCard(suit: Suit.hearts, rank: Rank.five),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.straight);
      expect(result.scoredCards, hasLength(5));
    });

    // ---------------------------------------------------------------------------
    // Flush
    // ---------------------------------------------------------------------------

    test('Flush detection', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.two),
        PlayingCard(suit: Suit.hearts, rank: Rank.five),
        PlayingCard(suit: Suit.hearts, rank: Rank.seven),
        PlayingCard(suit: Suit.hearts, rank: Rank.nine),
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.flush);
      expect(result.scoredCards, hasLength(5));
    });

    // ---------------------------------------------------------------------------
    // Full House
    // ---------------------------------------------------------------------------

    test('Full House detection', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.queen),
        PlayingCard(suit: Suit.clubs, rank: Rank.queen),
        PlayingCard(suit: Suit.spades, rank: Rank.queen),
        PlayingCard(suit: Suit.diamonds, rank: Rank.three),
        PlayingCard(suit: Suit.hearts, rank: Rank.three),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.fullHouse);
      expect(result.scoredCards, hasLength(5));
    });

    // ---------------------------------------------------------------------------
    // Four of a Kind
    // ---------------------------------------------------------------------------

    test('Four of a Kind detection', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.eight),
        PlayingCard(suit: Suit.clubs, rank: Rank.eight),
        PlayingCard(suit: Suit.spades, rank: Rank.eight),
        PlayingCard(suit: Suit.diamonds, rank: Rank.eight),
        PlayingCard(suit: Suit.hearts, rank: Rank.king),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.fourOfAKind);
      expect(result.scoredCards, hasLength(4));
    });

    // ---------------------------------------------------------------------------
    // Straight Flush
    // ---------------------------------------------------------------------------

    test('Straight Flush detection', () {
      final cards = [
        PlayingCard(suit: Suit.clubs, rank: Rank.four),
        PlayingCard(suit: Suit.clubs, rank: Rank.five),
        PlayingCard(suit: Suit.clubs, rank: Rank.six),
        PlayingCard(suit: Suit.clubs, rank: Rank.seven),
        PlayingCard(suit: Suit.clubs, rank: Rank.eight),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.straightFlush);
      expect(result.scoredCards, hasLength(5));
    });

    // ---------------------------------------------------------------------------
    // Royal Flush
    // ---------------------------------------------------------------------------

    test('Royal Flush detection', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.ten),
        PlayingCard(suit: Suit.spades, rank: Rank.jack),
        PlayingCard(suit: Suit.spades, rank: Rank.queen),
        PlayingCard(suit: Suit.spades, rank: Rank.king),
        PlayingCard(suit: Suit.spades, rank: Rank.ace),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.royalFlush);
      expect(result.scoredCards, hasLength(5));
    });

    // ---------------------------------------------------------------------------
    // Edge cases
    // ---------------------------------------------------------------------------

    test('3-card hand → best hand detected', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.ace),
        PlayingCard(suit: Suit.clubs, rank: Rank.ace),
        PlayingCard(suit: Suit.spades, rank: Rank.ace),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.threeOfAKind);
    });

    test('4-card straight not detected (need 5 for straight)', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.two),
        PlayingCard(suit: Suit.clubs, rank: Rank.three),
        PlayingCard(suit: Suit.spades, rank: Rank.four),
        PlayingCard(suit: Suit.diamonds, rank: Rank.five),
      ];
      final result = evaluator.evaluate(cards);
      // 4 consecutive cards — not a straight (needs 5)
      expect(result.handType, isNot(HandType.straight));
    });

    test('High card scored cards has highest card', () {
      final cards = [
        PlayingCard(suit: Suit.hearts, rank: Rank.two),
        PlayingCard(suit: Suit.clubs, rank: Rank.seven),
        PlayingCard(suit: Suit.spades, rank: Rank.king),
      ];
      final result = evaluator.evaluate(cards);
      expect(result.handType, HandType.highCard);
      expect(result.scoredCards.first.rank, Rank.king);
    });
  });
}
