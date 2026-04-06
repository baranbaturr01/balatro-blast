import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/models/blind.dart';
import 'package:balatro_blast/utils/constants.dart';

class RoundManager {
  /// Calculates money reward after defeating a blind.
  int calculateReward(GameState state) {
    int reward = kBlindWinReward;
    reward += state.handsLeft * kHandRemainingReward;
    // Interest: $1 per $5 held, capped at $5.
    final interest = (state.money ~/ kInterestPer).clamp(0, kMaxInterest);
    reward += interest;
    return reward;
  }

  /// Advances the game to the next blind or ante.
  GameState advance(GameState state) {
    final nextBlindIndex = state.blindIndex + 1;
    if (nextBlindIndex >= kBlindsPerAnte) {
      // Move to next ante.
      final nextAnte = state.ante + 1;
      if (nextAnte > kTotalAntes) {
        state.phase = GamePhase.victory;
        return state;
      }
      state.ante = nextAnte;
      state.blindIndex = 0;
      state.currentBlind = Blind.forAnte(nextAnte, BlindType.small);
    } else {
      state.blindIndex = nextBlindIndex;
      final type = BlindType.values[nextBlindIndex];
      state.currentBlind = Blind.forAnte(state.ante, type);
    }
    state.phase = GamePhase.blindSelect;
    return state;
  }
}
