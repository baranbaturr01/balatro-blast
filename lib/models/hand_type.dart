enum HandType {
  highCard,
  pair,
  twoPair,
  threeOfAKind,
  straight,
  flush,
  fullHouse,
  fourOfAKind,
  straightFlush,
  royalFlush,
}

class HandTypeInfo {
  const HandTypeInfo({
    required this.type,
    required this.name,
    required this.baseChips,
    required this.baseMult,
  });

  final HandType type;
  final String name;
  final int baseChips;
  final int baseMult;

  static const Map<HandType, HandTypeInfo> _all = {
    HandType.highCard: HandTypeInfo(
      type: HandType.highCard,
      name: 'High Card',
      baseChips: 5,
      baseMult: 1,
    ),
    HandType.pair: HandTypeInfo(
      type: HandType.pair,
      name: 'Pair',
      baseChips: 10,
      baseMult: 2,
    ),
    HandType.twoPair: HandTypeInfo(
      type: HandType.twoPair,
      name: 'Two Pair',
      baseChips: 20,
      baseMult: 2,
    ),
    HandType.threeOfAKind: HandTypeInfo(
      type: HandType.threeOfAKind,
      name: 'Three of a Kind',
      baseChips: 30,
      baseMult: 3,
    ),
    HandType.straight: HandTypeInfo(
      type: HandType.straight,
      name: 'Straight',
      baseChips: 30,
      baseMult: 4,
    ),
    HandType.flush: HandTypeInfo(
      type: HandType.flush,
      name: 'Flush',
      baseChips: 35,
      baseMult: 4,
    ),
    HandType.fullHouse: HandTypeInfo(
      type: HandType.fullHouse,
      name: 'Full House',
      baseChips: 40,
      baseMult: 4,
    ),
    HandType.fourOfAKind: HandTypeInfo(
      type: HandType.fourOfAKind,
      name: 'Four of a Kind',
      baseChips: 60,
      baseMult: 7,
    ),
    HandType.straightFlush: HandTypeInfo(
      type: HandType.straightFlush,
      name: 'Straight Flush',
      baseChips: 100,
      baseMult: 8,
    ),
    HandType.royalFlush: HandTypeInfo(
      type: HandType.royalFlush,
      name: 'Royal Flush',
      baseChips: 100,
      baseMult: 8,
    ),
  };

  static HandTypeInfo forType(HandType type) => _all[type]!;

  static List<HandTypeInfo> get all => _all.values.toList();
}
