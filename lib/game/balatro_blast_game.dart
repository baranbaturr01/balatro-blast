import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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

class BalatraBlastGame extends FlameGame with HasTappableComponents {
  BalatraBlastGame({required this.gameManager});

  final GameManager gameManager;

  late HandComponent _handComponent;
  late ScoreDisplayComponent _scoreDisplay;
  late JokerSlotComponent _jokerSlots;
  late DeckComponent _deckComponent;

  @override
  Color backgroundColor() => AppColors.background;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(400, 700),
    );

    _scoreDisplay = ScoreDisplayComponent(
      gameManager: gameManager,
      position: Vector2(0, 0),
      size: Vector2(400, 80),
    );

    _jokerSlots = JokerSlotComponent(
      gameManager: gameManager,
      position: Vector2(8, 90),
      size: Vector2(380, 100),
    );

    _handComponent = HandComponent(
      gameManager: gameManager,
      position: Vector2(0, 460),
      size: Vector2(400, 160),
      onCardTapped: _onCardTapped,
    );

    _deckComponent = DeckComponent(
      gameManager: gameManager,
      position: Vector2(340, 400),
      size: Vector2(50, 50),
    );

    await addAll([
      _scoreDisplay,
      _jokerSlots,
      _handComponent,
      _deckComponent,
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
    _handlePhaseTransition();
  }

  void discardCards() {
    gameManager.discardCards();
    _handComponent.refresh();
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
