import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  const SettingsState({
    this.soundEnabled = true,
    this.musicEnabled = true,
  });

  final bool soundEnabled;
  final bool musicEnabled;

  SettingsState copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void setSoundEnabled(bool value) {
    state = state.copyWith(soundEnabled: value);
  }

  void setMusicEnabled(bool value) {
    state = state.copyWith(musicEnabled: value);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(),
);
