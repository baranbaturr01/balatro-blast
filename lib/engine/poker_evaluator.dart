import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

/// Result of evaluating a poker hand.
class EvaluationResult {
  const EvaluationResult({
    required this.handType,
    required this.scoredCards,
  });

  final HandType handType;

  /// The subset of played cards that form the hand and contribute chips.
  final List<PlayingCard> scoredCards;
}

/// Evaluates poker hands from 1–5 played cards.
class PokerEvaluator {
  const PokerEvaluator();

  EvaluationResult evaluate(List<PlayingCard> cards) {
    assert(cards.isNotEmpty && cards.length <= 5);

    if (cards.length == 1) {
      return EvaluationResult(
        handType: HandType.highCard,
        scoredCards: cards,
      );
    }

    // Check hands from best to worst.
    return _checkRoyalFlush(cards) ??
        _checkStraightFlush(cards) ??
        _checkFourOfAKind(cards) ??
        _checkFullHouse(cards) ??
        _checkFlush(cards) ??
        _checkStraight(cards) ??
        _checkThreeOfAKind(cards) ??
        _checkTwoPair(cards) ??
        _checkPair(cards) ??
        _highCard(cards);
  }

  // ---------------------------------------------------------------------------
  // Hand checkers
  // ---------------------------------------------------------------------------

  EvaluationResult? _checkRoyalFlush(List<PlayingCard> cards) {
    if (cards.length < 5) return null;
    final sf = _checkStraightFlush(cards);
    if (sf == null) return null;
    final ranks = sf.scoredCards.map((c) => c.rank.value).toSet();
    if (ranks.containsAll({10, 11, 12, 13, 14})) {
      return EvaluationResult(
        handType: HandType.royalFlush,
        scoredCards: sf.scoredCards,
      );
    }
    return null;
  }

  EvaluationResult? _checkStraightFlush(List<PlayingCard> cards) {
    if (cards.length < 5) return null;
    final flush = _checkFlush(cards);
    if (flush == null) return null;
    final straight = _checkStraight(flush.scoredCards);
    if (straight == null) return null;
    return EvaluationResult(
      handType: HandType.straightFlush,
      scoredCards: straight.scoredCards,
    );
  }

  EvaluationResult? _checkFourOfAKind(List<PlayingCard> cards) {
    final groups = _groupByRank(cards);
    for (final entry in groups.entries) {
      if (entry.value.length >= 4) {
        return EvaluationResult(
          handType: HandType.fourOfAKind,
          scoredCards: entry.value.take(4).toList(),
        );
      }
    }
    return null;
  }

  EvaluationResult? _checkFullHouse(List<PlayingCard> cards) {
    if (cards.length < 5) return null;
    final groups = _groupByRank(cards);
    final threes = groups.entries
        .where((e) => e.value.length >= 3)
        .toList();
    final twos = groups.entries
        .where((e) => e.value.length >= 2)
        .toList();

    if (threes.isEmpty) return null;
    // Sort descending by rank to pick the best three.
    threes.sort((a, b) => b.key.compareTo(a.key));
    final three = threes.first;
    // Find a pair that is a different rank.
    final pairEntry = twos.firstWhere(
      (e) => e.key != three.key,
      orElse: () => const MapEntry(-1, []),
    );
    if (pairEntry.key == -1) return null;

    return EvaluationResult(
      handType: HandType.fullHouse,
      scoredCards: [
        ...three.value.take(3),
        ...pairEntry.value.take(2),
      ],
    );
  }

  EvaluationResult? _checkFlush(List<PlayingCard> cards) {
    if (cards.length < 5) return null;
    final bySuit = <Suit, List<PlayingCard>>{};
    for (final card in cards) {
      bySuit.putIfAbsent(card.suit, () => []).add(card);
    }
    for (final suitCards in bySuit.values) {
      if (suitCards.length >= 5) {
        // Use top 5 by rank.
        final sorted = [...suitCards]
          ..sort((a, b) => b.rank.value.compareTo(a.rank.value));
        return EvaluationResult(
          handType: HandType.flush,
          scoredCards: sorted.take(5).toList(),
        );
      }
    }
    return null;
  }

  EvaluationResult? _checkStraight(List<PlayingCard> cards) {
    if (cards.length < 5) return null;
    final sorted = [...cards]
      ..sort((a, b) => b.rank.value.compareTo(a.rank.value));
    final ranks = sorted.map((c) => c.rank.value).toSet().toList()
      ..sort((a, b) => b.compareTo(a));

    if (ranks.length < 5) return null;

    // Check for 5 consecutive ranks within the set.
    final straight = _findStraight(ranks, sorted);
    if (straight != null) return straight;

    // Check ace-low straight: A-2-3-4-5
    if (ranks.contains(14)) {
      final aceLowRanks = ranks.map((r) => r == 14 ? 1 : r).toList()
        ..sort((a, b) => b.compareTo(a));
      final aceLowCards = cards.map((c) {
        if (c.rank == Rank.ace) {
          // treat ace as 1 for this check
          return _AceLowCard(c);
        }
        return c;
      }).toList();
      return _findStraight(aceLowRanks, aceLowCards as List<PlayingCard>);
    }

    return null;
  }

  EvaluationResult? _findStraight(
      List<int> ranksDesc, List<PlayingCard> sortedCards) {
    for (int i = 0; i <= ranksDesc.length - 5; i++) {
      bool consecutive = true;
      for (int j = 0; j < 4; j++) {
        if (ranksDesc[i + j] - ranksDesc[i + j + 1] != 1) {
          consecutive = false;
          break;
        }
      }
      if (consecutive) {
        // Collect one card per rank in this straight window.
        final needed = ranksDesc.sublist(i, i + 5).toSet();
        final result = <PlayingCard>[];
        final usedRanks = <int>{};
        for (final card in sortedCards) {
          final v = card.rank == Rank.ace && needed.contains(1)
              ? 1
              : card.rank.value;
          if (needed.contains(v) && !usedRanks.contains(v)) {
            result.add(card);
            usedRanks.add(v);
          }
        }
        if (result.length == 5) {
          return EvaluationResult(
            handType: HandType.straight,
            scoredCards: result,
          );
        }
      }
    }
    return null;
  }

  EvaluationResult? _checkThreeOfAKind(List<PlayingCard> cards) {
    final groups = _groupByRank(cards);
    final threes =
        groups.entries.where((e) => e.value.length >= 3).toList();
    if (threes.isEmpty) return null;
    threes.sort((a, b) => b.key.compareTo(a.key));
    return EvaluationResult(
      handType: HandType.threeOfAKind,
      scoredCards: threes.first.value.take(3).toList(),
    );
  }

  EvaluationResult? _checkTwoPair(List<PlayingCard> cards) {
    final groups = _groupByRank(cards);
    final pairs =
        groups.entries.where((e) => e.value.length >= 2).toList();
    if (pairs.length < 2) return null;
    pairs.sort((a, b) => b.key.compareTo(a.key));
    return EvaluationResult(
      handType: HandType.twoPair,
      scoredCards: [
        ...pairs[0].value.take(2),
        ...pairs[1].value.take(2),
      ],
    );
  }

  EvaluationResult? _checkPair(List<PlayingCard> cards) {
    final groups = _groupByRank(cards);
    final pairs =
        groups.entries.where((e) => e.value.length >= 2).toList();
    if (pairs.isEmpty) return null;
    pairs.sort((a, b) => b.key.compareTo(a.key));
    return EvaluationResult(
      handType: HandType.pair,
      scoredCards: pairs.first.value.take(2).toList(),
    );
  }

  EvaluationResult _highCard(List<PlayingCard> cards) {
    final sorted = [...cards]
      ..sort((a, b) => b.rank.value.compareTo(a.rank.value));
    return EvaluationResult(
      handType: HandType.highCard,
      scoredCards: [sorted.first],
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<int, List<PlayingCard>> _groupByRank(List<PlayingCard> cards) {
    final groups = <int, List<PlayingCard>>{};
    for (final card in cards) {
      groups.putIfAbsent(card.rank.value, () => []).add(card);
    }
    return groups;
  }
}

/// Internal wrapper to treat an Ace as rank 1 for ace-low straights.
class _AceLowCard extends PlayingCard {
  _AceLowCard(PlayingCard original)
      : super(suit: original.suit, rank: original.rank);

  @override
  int get chipValue => super.chipValue;
}
