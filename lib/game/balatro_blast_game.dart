import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:balatro_blast/game/components/hand_component.dart';
import 'package:balatro_blast/game/components/score_display_component.dart';
import 'package:balatro_blast/game/components/joker_slot_component.dart';
import 'package:balatro_blast/game/components/deck_component.dart';
import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/models/playing_card.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class BalatraBlastGame extends FlameGame {
  BalatraBlastGame({required this.gameManager});

  final GameManager gameManager;

  late HandComponent _handComponent;
  late ScoreDisplayComponent _scoreDisplay;
  late ScoreFormulaComponent _scoreFormula;
  late JokerSlotComponent _jokerSlots;
  late DeckComponent _deckComponent;

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Landscape viewport: 800 x 480 logical pixels.
    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(kViewportWidth, kViewportHeight),
    );

    const jokerTop = kHudHeight + 8.0;
    const formulaTop = jokerTop + kJokerAreaHeight + 4.0;
    const handTop = formulaTop + kScoreFormulaHeight + 4.0;

    _scoreDisplay = ScoreDisplayComponent(
      gameManager: gameManager,
      position: Vector2(0, 0),
      size: Vector2(kViewportWidth, kHudHeight),
    );

    _jokerSlots = JokerSlotComponent(
      gameManager: gameManager,
      position: Vector2(8, jokerTop),
      size: Vector2(kViewportWidth - kDeckAreaWidth - 20, kJokerAreaHeight),
    );

    _deckComponent = DeckComponent(
      gameManager: gameManager,
      position: Vector2(kViewportWidth - kDeckAreaWidth - 8, jokerTop),
      size: Vector2(kDeckAreaWidth, kJokerAreaHeight),
    );

    _scoreFormula = ScoreFormulaComponent(
      gameManager: gameManager,
      position: Vector2(0, formulaTop),
      size: Vector2(kViewportWidth, kScoreFormulaHeight),
    );

    _handComponent = HandComponent(
      gameManager: gameManager,
      position: Vector2(0, handTop),
      size: Vector2(kViewportWidth, kCardHeight + kCardSelectedOffset + 8),
      onCardTapped: _onCardTapped,
    );

    await addAll([
      _scoreDisplay,
      _jokerSlots,
      _deckComponent,
      _scoreFormula,
      _handComponent,
    ]);

    // Show main menu overlay on game start.
    overlays.add(kOverlayMainMenu);
  }

  void _onCardTapped(PlayingCard card) {
    gameManager.toggleCardSelection(card);
    _handComponent.refresh();
  }

  void playHand() {
    final result = gameManager.playHand();
    if (result == null) return;
    _scoreFormula.displayChips = result.chips;
    _scoreFormula.displayMult = result.mult;
    _handlePhaseTransition();
  }

  void discardCards() {
    gameManager.discardCards();
    _handComponent.refresh();
    _scoreFormula.displayChips = 0;
    _scoreFormula.displayMult = 0;
  }

  void _handlePhaseTransition() {
    switch (gameManager.state.phase) {
      case GamePhase.shop:
        overlays.add(kOverlayShop);
      case GamePhase.gameOver:
        overlays.add(kOverlayGameOver);
      case GamePhase.victory:
        overlays.add(kOverlayGameOver);
      default:
        break;
    }
    _handComponent.refresh();
    _scoreDisplay.refresh();
    _jokerSlots.refresh();
  }

  void onShopClosed() {
    overlays.remove(kOverlayShop);
    gameManager.advanceFromShop();
    _scoreFormula.displayChips = 0;
    _scoreFormula.displayMult = 0;
    if (gameManager.state.phase == GamePhase.blindSelect) {
      overlays.add(kOverlayBlindSelect);
    }
    _jokerSlots.refresh();
  }

  void onBlindSelected() {
    overlays.remove(kOverlayBlindSelect);
    _handComponent.refresh();
    _scoreDisplay.refresh();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
