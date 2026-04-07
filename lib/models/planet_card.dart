import 'package:balatro_blast/models/hand_type.dart';

enum PlanetCardType {
  mercury,
  venus,
  earth,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto,
}

class PlanetCard {
  const PlanetCard({
    required this.type,
    required this.name,
    required this.upgrades,
  });

  final PlanetCardType type;
  final String name;
  final HandType upgrades;

  String get description => 'Level up ${HandTypeInfo.forType(upgrades).name}';

  static const int cost = 4;
  static const int chipsPerLevel = 15;
  static const int multPerLevel = 1;

  static const List<PlanetCard> all = [
    PlanetCard(
      type: PlanetCardType.pluto,
      name: 'Pluto',
      upgrades: HandType.highCard,
    ),
    PlanetCard(
      type: PlanetCardType.mercury,
      name: 'Mercury',
      upgrades: HandType.pair,
    ),
    PlanetCard(
      type: PlanetCardType.uranus,
      name: 'Uranus',
      upgrades: HandType.twoPair,
    ),
    PlanetCard(
      type: PlanetCardType.venus,
      name: 'Venus',
      upgrades: HandType.threeOfAKind,
    ),
    PlanetCard(
      type: PlanetCardType.saturn,
      name: 'Saturn',
      upgrades: HandType.straight,
    ),
    PlanetCard(
      type: PlanetCardType.jupiter,
      name: 'Jupiter',
      upgrades: HandType.flush,
    ),
    PlanetCard(
      type: PlanetCardType.earth,
      name: 'Earth',
      upgrades: HandType.fullHouse,
    ),
    PlanetCard(
      type: PlanetCardType.mars,
      name: 'Mars',
      upgrades: HandType.fourOfAKind,
    ),
    PlanetCard(
      type: PlanetCardType.neptune,
      name: 'Neptune',
      upgrades: HandType.straightFlush,
    ),
  ];

  static PlanetCard forHandType(HandType type) {
    return all.firstWhere((p) => p.upgrades == type);
  }
}
