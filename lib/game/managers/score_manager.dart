import 'package:balatro_blast/engine/scoring_engine.dart';
import 'package:balatro_blast/models/hand_type.dart';

class ScoreManager {
  int _runningTotal = 0;
  int _handsPlayed = 0;
  final List<ScoringResult> _handHistory = [];

  int get runningTotal => _runningTotal;
  int get handsPlayed => _handsPlayed;
  List<ScoringResult> get handHistory => List.unmodifiable(_handHistory);

  void recordHand(ScoringResult result) {
    _runningTotal += result.score;
    _handsPlayed++;
    _handHistory.add(result);
  }

  void reset() {
    _runningTotal = 0;
    _handsPlayed = 0;
    _handHistory.clear();
  }

  /// Returns the most common hand type played this run.
  HandType? get favoriteHand {
    if (_handHistory.isEmpty) return null;
    final counts = <HandType, int>{};
    for (final result in _handHistory) {
      counts[result.handType] = (counts[result.handType] ?? 0) + 1;
    }
    return counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  int get bestHandScore {
    if (_handHistory.isEmpty) return 0;
    return _handHistory
        .map((r) => r.score)
        .reduce((a, b) => a > b ? a : b);
  }
}
