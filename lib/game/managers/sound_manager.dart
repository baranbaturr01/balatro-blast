/// Sound manager stub.
/// Provides a consistent API for playing sounds; actual audio files are not
/// bundled in the initial release.
class SoundManager {
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  bool get soundEnabled => _soundEnabled;
  bool get musicEnabled => _musicEnabled;

  set soundEnabled(bool value) {
    _soundEnabled = value;
  }

  set musicEnabled(bool value) {
    _musicEnabled = value;
    if (value) {
      _startMusic();
    } else {
      _stopMusic();
    }
  }

  void playCardFlip() {
    if (!_soundEnabled) return;
    // TODO: play card flip sound
  }

  void playCardSelect() {
    if (!_soundEnabled) return;
    // TODO: play selection sound
  }

  void playHandScore() {
    if (!_soundEnabled) return;
    // TODO: play scoring jingle
  }

  void playBlindDefeated() {
    if (!_soundEnabled) return;
    // TODO: play victory sound
  }

  void playGameOver() {
    if (!_soundEnabled) return;
    // TODO: play game over sound
  }

  void playShopPurchase() {
    if (!_soundEnabled) return;
    // TODO: play purchase sound
  }

  void _startMusic() {
    // TODO: start background music loop
  }

  void _stopMusic() {
    // TODO: stop background music
  }

  void dispose() {
    _stopMusic();
  }
}
