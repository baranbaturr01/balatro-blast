import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/blind.dart';
import 'package:balatro_blast/utils/constants.dart';

/// Persists and restores game state using Hive.
class SaveManager {
  static const String _boxName = 'game_save';
  static const String _saveKey = 'current_save';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  static Box get _box => Hive.box(_boxName);

  static bool get hasSave => _box.containsKey(_saveKey);

  /// Serialises the game state to a simple map and stores it.
  static Future<void> save(GameState state) async {
    final data = {
      'ante': state.ante,
      'blindIndex': state.blindIndex,
      'handsLeft': state.handsLeft,
      'discardsLeft': state.discardsLeft,
      'money': state.money,
      'runningScore': state.runningScore,
      'phase': state.phase.index,
      'jokers': state.jokers.map((j) => j.type.index).toList(),
      'handLevels': state.handLevels,
    };
    await _box.put(_saveKey, jsonEncode(data));
  }

  /// Loads the saved game state, or returns null if no save exists.
  static GameState? load() {
    if (!hasSave) return null;
    try {
      final raw = _box.get(_saveKey) as String;
      final data = jsonDecode(raw) as Map<String, dynamic>;

      final state = GameState.newRun();
      state.ante = data['ante'] as int;
      state.blindIndex = data['blindIndex'] as int;
      state.handsLeft = data['handsLeft'] as int;
      state.discardsLeft = data['discardsLeft'] as int;
      state.money = data['money'] as int;
      state.runningScore = data['runningScore'] as int;
      state.phase = GamePhase.values[data['phase'] as int];

      final jokerIndices = (data['jokers'] as List).cast<int>();
      state.jokers = jokerIndices
          .map((i) => JokerCard.byType(JokerType.values[i]))
          .whereType<JokerCard>()
          .toList();

      final rawLevels = data['handLevels'] as Map<String, dynamic>? ?? {};
      state.handLevels =
          rawLevels.map((k, v) => MapEntry(k, v as int));

      state.currentBlind =
          Blind.forAnte(state.ante, BlindType.values[state.blindIndex.clamp(0, 2)]);

      return state;
    } catch (_) {
      return null;
    }
  }

  static Future<void> deleteSave() async {
    await _box.delete(_saveKey);
  }
}
