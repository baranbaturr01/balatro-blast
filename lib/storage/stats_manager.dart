import 'package:hive_flutter/hive_flutter.dart';

/// Tracks run statistics across multiple games.
class StatsManager {
  static const String _boxName = 'stats';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static int get totalRuns => _box.get('totalRuns', defaultValue: 0) as int;
  static int get wins => _box.get('wins', defaultValue: 0) as int;
  static int get highScore => _box.get('highScore', defaultValue: 0) as int;
  static int get highestAnte =>
      _box.get('highestAnte', defaultValue: 0) as int;
  static int get totalHandsPlayed =>
      _box.get('totalHandsPlayed', defaultValue: 0) as int;

  static Future<void> recordRunEnd({
    required bool won,
    required int finalScore,
    required int ante,
    required int handsPlayed,
  }) async {
    await _box.put('totalRuns', totalRuns + 1);
    if (won) await _box.put('wins', wins + 1);
    if (finalScore > highScore) await _box.put('highScore', finalScore);
    if (ante > highestAnte) await _box.put('highestAnte', ante);
    await _box.put('totalHandsPlayed', totalHandsPlayed + handsPlayed);
  }

  static Future<void> reset() async {
    await _box.clear();
  }

  static Map<String, dynamic> getSummary() {
    return {
      'totalRuns': totalRuns,
      'wins': wins,
      'winRate': totalRuns > 0
          ? '${(wins / totalRuns * 100).toStringAsFixed(1)}%'
          : '0%',
      'highScore': highScore,
      'highestAnte': highestAnte,
      'totalHandsPlayed': totalHandsPlayed,
    };
  }
}
