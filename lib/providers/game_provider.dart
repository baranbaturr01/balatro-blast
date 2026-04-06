import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/game_state.dart';

final gameManagerProvider = ChangeNotifierProvider<GameManager>((ref) {
  return GameManager();
});

final gameStateProvider = Provider<GameState>((ref) {
  return ref.watch(gameManagerProvider).state;
});

final gamePhaseProvider = Provider<GamePhase>((ref) {
  return ref.watch(gameStateProvider).phase;
});
