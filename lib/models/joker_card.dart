enum JokerType {
  greedy,
  lusty,
  wrathful,
  gluttonous,
  jolly,
  zany,
  mad,
  crazy,
  droll,
  sly,
  wily,
  clever,
  devious,
  crafty,
  half,
  duo,
  trio,
  family,
  order,
  tribe,
}

enum JokerEffectType { addMult, addChips, multiplyMult }

class JokerCard {
  const JokerCard({
    required this.type,
    required this.name,
    required this.description,
    required this.cost,
    required this.effectType,
  });

  final JokerType type;
  final String name;
  final String description;
  final int cost;
  final JokerEffectType effectType;

  int get sellValue => cost ~/ 2;

  static const List<JokerCard> all = [
    JokerCard(
      type: JokerType.greedy,
      name: 'Greedy Joker',
      description: '+3 Mult for each\nDiamond scored',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.lusty,
      name: 'Lusty Joker',
      description: '+3 Mult for each\nHeart scored',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.wrathful,
      name: 'Wrathful Joker',
      description: '+3 Mult for each\nSpade scored',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.gluttonous,
      name: 'Gluttonous Joker',
      description: '+3 Mult for each\nClub scored',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.jolly,
      name: 'Jolly Joker',
      description: '+8 Mult if hand\ncontains a Pair',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.zany,
      name: 'Zany Joker',
      description: '+12 Mult if hand\ncontains Three of a Kind',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.mad,
      name: 'Mad Joker',
      description: '+10 Mult if hand\ncontains Two Pair',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.crazy,
      name: 'Crazy Joker',
      description: '+12 Mult if hand\nis a Straight',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.droll,
      name: 'Droll Joker',
      description: '+10 Mult if hand\nis a Flush',
      cost: 6,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.sly,
      name: 'Sly Joker',
      description: '+50 Chips if hand\ncontains a Pair',
      cost: 6,
      effectType: JokerEffectType.addChips,
    ),
    JokerCard(
      type: JokerType.wily,
      name: 'Wily Joker',
      description: '+100 Chips if hand\ncontains Three of a Kind',
      cost: 6,
      effectType: JokerEffectType.addChips,
    ),
    JokerCard(
      type: JokerType.clever,
      name: 'Clever Joker',
      description: '+80 Chips if hand\ncontains Two Pair',
      cost: 6,
      effectType: JokerEffectType.addChips,
    ),
    JokerCard(
      type: JokerType.devious,
      name: 'Devious Joker',
      description: '+100 Chips if hand\nis a Straight',
      cost: 6,
      effectType: JokerEffectType.addChips,
    ),
    JokerCard(
      type: JokerType.crafty,
      name: 'Crafty Joker',
      description: '+80 Chips if hand\nis a Flush',
      cost: 6,
      effectType: JokerEffectType.addChips,
    ),
    JokerCard(
      type: JokerType.half,
      name: 'Half Joker',
      description: '+20 Mult if played\nhand has ≤3 cards',
      cost: 7,
      effectType: JokerEffectType.addMult,
    ),
    JokerCard(
      type: JokerType.duo,
      name: 'The Duo',
      description: '×2 Mult if hand\ncontains a Pair',
      cost: 8,
      effectType: JokerEffectType.multiplyMult,
    ),
    JokerCard(
      type: JokerType.trio,
      name: 'The Trio',
      description: '×3 Mult if hand\ncontains Three of a Kind',
      cost: 8,
      effectType: JokerEffectType.multiplyMult,
    ),
    JokerCard(
      type: JokerType.family,
      name: 'The Family',
      description: '×4 Mult if hand\ncontains Four of a Kind',
      cost: 8,
      effectType: JokerEffectType.multiplyMult,
    ),
    JokerCard(
      type: JokerType.order,
      name: 'The Order',
      description: '×3 Mult if hand\nis a Straight',
      cost: 8,
      effectType: JokerEffectType.multiplyMult,
    ),
    JokerCard(
      type: JokerType.tribe,
      name: 'The Tribe',
      description: '×2 Mult if hand\nis a Flush',
      cost: 8,
      effectType: JokerEffectType.multiplyMult,
    ),
  ];

  static JokerCard? byType(JokerType type) {
    try {
      return all.firstWhere((j) => j.type == type);
    } catch (_) {
      return null;
    }
  }
}
