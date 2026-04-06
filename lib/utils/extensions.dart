import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/hand_type.dart';

extension PlayingCardListExtensions on List<PlayingCard> {
  /// Returns cards sorted by rank value descending.
  List<PlayingCard> sortedByRankDesc() {
    final copy = [...this];
    copy.sort((a, b) => b.rank.value.compareTo(a.rank.value));
    return copy;
  }

  /// Returns cards sorted by rank value ascending.
  List<PlayingCard> sortedByRankAsc() {
    final copy = [...this];
    copy.sort((a, b) => a.rank.value.compareTo(b.rank.value));
    return copy;
  }

  /// Groups cards by rank. Returns a map of rank value → list of cards.
  Map<int, List<PlayingCard>> groupByRank() {
    final Map<int, List<PlayingCard>> groups = {};
    for (final card in this) {
      groups.putIfAbsent(card.rank.value, () => []).add(card);
    }
    return groups;
  }

  /// Groups cards by suit.
  Map<Suit, List<PlayingCard>> groupBySuit() {
    final Map<Suit, List<PlayingCard>> groups = {};
    for (final card in this) {
      groups.putIfAbsent(card.suit, () => []).add(card);
    }
    return groups;
  }

  /// Total chip value of all cards in the list.
  int get totalChips =>
      fold(0, (sum, card) => sum + card.chipValue);

  /// Returns all selected cards.
  List<PlayingCard> get selected =>
      where((c) => c.isSelected).toList();

  /// Returns all non-selected cards.
  List<PlayingCard> get unselected =>
      where((c) => !c.isSelected).toList();
}

extension HandTypeExtension on HandType {
  /// Display-friendly name.
  String get displayName => HandTypeInfo.forType(this).name;

  /// Base chips for this hand type.
  int get baseChips => HandTypeInfo.forType(this).baseChips;

  /// Base mult for this hand type.
  int get baseMult => HandTypeInfo.forType(this).baseMult;
}

extension IntExtension on int {
  /// Format number with commas for display (e.g. 12000 → "12,000").
  String get formatted {
    final s = toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join();
  }
}
