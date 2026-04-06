import 'package:balatro_blast/utils/constants.dart';

enum BlindType { small, big, boss }

class Blind {
  const Blind({
    required this.name,
    required this.targetScore,
    required this.ante,
    required this.type,
    this.bossEffect,
  });

  final String name;
  final int targetScore;
  final int ante;
  final BlindType type;
  final String? bossEffect;

  static Blind forAnte(int ante, BlindType type) {
    // ante is 1-based
    final idx = (ante - 1).clamp(0, kBlindTargets.length - 1);
    final targets = kBlindTargets[idx];
    final score = targets[type.index];

    switch (type) {
      case BlindType.small:
        return Blind(
          name: 'Small Blind',
          targetScore: score,
          ante: ante,
          type: type,
        );
      case BlindType.big:
        return Blind(
          name: 'Big Blind',
          targetScore: score,
          ante: ante,
          type: type,
        );
      case BlindType.boss:
        return _bossBlind(ante, score);
    }
  }

  static Blind _bossBlind(int ante, int score) {
    final bosses = _bossBlindPool;
    final boss = bosses[ante % bosses.length];
    return Blind(
      name: boss['name'] as String,
      targetScore: score,
      ante: ante,
      type: BlindType.boss,
      bossEffect: boss['effect'] as String,
    );
  }

  static const List<Map<String, String>> _bossBlindPool = [
    {
      'name': 'The Needle',
      'effect': 'Only 1 hand allowed this round',
    },
    {
      'name': 'The Water',
      'effect': 'No discards this round',
    },
    {
      'name': 'The Club',
      'effect': 'All Club cards are debuffed',
    },
    {
      'name': 'The Eye',
      'effect': 'No repeat hand types this round',
    },
    {
      'name': 'The Mouth',
      'effect': 'Only one hand type may be played',
    },
    {
      'name': 'The Fish',
      'effect': 'Draw one fewer card after each hand',
    },
    {
      'name': 'The Wall',
      'effect': 'Extra large blind',
    },
    {
      'name': 'The House',
      'effect': 'First hand is drawn face down',
    },
  ];

  bool get isBoss => type == BlindType.boss;

  @override
  String toString() => '$name ($targetScore pts, Ante $ante)';
}
