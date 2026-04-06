import 'package:flutter/material.dart';
import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/blind.dart';
import 'package:balatro_blast/models/hand_type.dart';
import 'package:balatro_blast/engine/scoring_engine.dart';
import 'package:balatro_blast/engine/poker_evaluator.dart';
import 'package:balatro_blast/game/managers/score_manager.dart';
import 'package:balatro_blast/game/managers/round_manager.dart';
import 'package:balatro_blast/game/managers/shop_manager.dart';
import 'package:balatro_blast/utils/constants.dart';

class GameManager extends ChangeNotifier {
  GameManager()
      : _state = GameState(),
        _scoringEngine = ScoringEngine(),
        _scoreManager = ScoreManager(),
        _roundManager = RoundManager(),
        _shopManager = ShopManager(),
        _evaluator = const PokerEvaluator();

  GameState _state;
  final ScoringEngine _scoringEngine;
  final ScoreManager _scoreManager;
  final RoundManager _roundManager;
  final ShopManager _shopManager;
  final PokerEvaluator _evaluator;

  GameState get state => _state;
  ScoreManager get scoreManager => _scoreManager;
  ShopManager get shopManager => _shopManager;

  // ---------------------------------------------------------------------------
  // Game lifecycle
  // ---------------------------------------------------------------------------

  void startNewRun() {
    _state = GameState.newRun();
    _scoreManager.reset();
    _state.phase = GamePhase.blindSelect;
    notifyListeners();
  }

  void selectBlind(BlindType type) {
    _state.currentBlind = Blind.forAnte(_state.ante, type);
    _state.blindIndex = type.index;
    _beginBlind();
  }

  void _beginBlind() {
    _state.phase = GamePhase.playing;
    _state.handsLeft = kStartingHands;
    _state.discardsLeft = kStartingDiscards;
    _state.runningScore = 0;
    _state.selectedCards.clear();

    // Shuffle deck and deal hand.
    _state.deck = PlayingCard.fullDeck()..shuffle();
    _state.hand.clear();
    _drawCards(kHandSize);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Card selection
  // ---------------------------------------------------------------------------

  void toggleCardSelection(PlayingCard card) {
    if (card.isSelected) {
      card.isSelected = false;
      _state.selectedCards.remove(card);
    } else {
      if (_state.selectedCards.length >= kMaxSelectedCards) return;
      card.isSelected = true;
      _state.selectedCards.add(card);
    }
    _updatePreviewHand();
    notifyListeners();
  }

  void clearSelection() {
    for (final card in _state.selectedCards) {
      card.isSelected = false;
    }
    _state.selectedCards.clear();
    _state.previewHandType = null;
    notifyListeners();
  }

  void _updatePreviewHand() {
    if (_state.selectedCards.isEmpty) {
      _state.previewHandType = null;
    } else {
      try {
        final result = _evaluator.evaluate(List.from(_state.selectedCards));
        _state.previewHandType = result.handType;
      } catch (_) {
        _state.previewHandType = null;
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Play hand
  // ---------------------------------------------------------------------------

  ScoringResult? playHand() {
    if (!_state.canPlay) return null;

    final played = List<PlayingCard>.from(_state.selectedCards);
    final result = _scoringEngine.calculate(
      played,
      _state.jokers,
      handLevels: _state.handLevels,
    );

    // Mark scored cards.
    for (final card in result.scoredCards) {
      card.isScored = true;
    }

    _state.runningScore += result.score;
    _state.handsLeft--;

    // Remove played cards from hand.
    for (final card in played) {
      _state.hand.remove(card);
    }
    _state.selectedCards.clear();

    // Draw replacement cards.
    _drawCards(played.length);

    _scoreManager.recordHand(result);

    _checkBlindCompletion();
    notifyListeners();
    return result;
  }

  // ---------------------------------------------------------------------------
  // Discard
  // ---------------------------------------------------------------------------

  void discardCards() {
    if (!_state.canDiscard) return;

    final toDiscard = List<PlayingCard>.from(_state.selectedCards);
    for (final card in toDiscard) {
      _state.hand.remove(card);
    }
    _state.selectedCards.clear();
    _state.discardsLeft--;

    _drawCards(toDiscard.length);
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  void _drawCards(int count) {
    final toDraw = count.clamp(0, _state.deck.length);
    for (int i = 0; i < toDraw; i++) {
      final card = _state.deck.removeLast();
      card.isSelected = false;
      card.isScored = false;
      _state.hand.add(card);
    }
  }

  void _checkBlindCompletion() {
    if (_state.isBlindDefeated) {
      final reward = _roundManager.calculateReward(_state);
      _state.money += reward;
      _state.phase = GamePhase.shop;
      _shopManager.generateItems(_state);
    } else if (_state.isGameOver) {
      _state.phase = GamePhase.gameOver;
    }
  }

  // ---------------------------------------------------------------------------
  // Shop actions
  // ---------------------------------------------------------------------------

  bool buyJoker(JokerCard joker) {
    if (_state.jokers.length >= kMaxJokers) return false;
    if (_state.money < joker.cost) return false;
    _state.money -= joker.cost;
    _state.jokers.add(joker);
    notifyListeners();
    return true;
  }

  void sellJoker(JokerCard joker) {
    _state.jokers.remove(joker);
    _state.money += joker.sellValue;
    notifyListeners();
  }

  void advanceFromShop() {
    _state = _roundManager.advance(_state);
    if (_state.phase == GamePhase.victory) {
      notifyListeners();
      return;
    }
    _state.phase = GamePhase.blindSelect;
    notifyListeners();
  }
}
