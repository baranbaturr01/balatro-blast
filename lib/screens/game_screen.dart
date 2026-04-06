import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/providers/game_provider.dart';
import 'package:balatro_blast/screens/main_menu_screen.dart';
import 'package:balatro_blast/screens/shop_screen.dart';
import 'package:balatro_blast/screens/blind_select_screen.dart';
import 'package:balatro_blast/screens/game_over_screen.dart';
import 'package:balatro_blast/screens/settings_screen.dart';
import 'package:balatro_blast/utils/constants.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late BalatraBlastGame _game;

  @override
  void initState() {
    super.initState();
    final gameManager = ref.read(gameManagerProvider);
    _game = BalatraBlastGame(gameManager: gameManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              kOverlayMainMenu: (context, game) => MainMenuScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlayShop: (context, game) => ShopScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlayBlindSelect: (context, game) => BlindSelectScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlayGameOver: (context, game) => GameOverScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlaySettings: (context, game) => SettingsScreen(
                    game: game as BalatraBlastGame,
                  ),
            },
          ),
          // Action buttons overlay at the bottom.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _ActionButtonRow(game: _game),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonRow extends ConsumerWidget {
  const _ActionButtonRow({required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.watch(gameManagerProvider);
    final state = gameManager.state;

    return Container(
      color: const Color(0xFF1a0a2e).withValues(alpha: 0.95),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: state.canPlay
                ? () => game.playHand()
                : null,
            child: const Text('▶ Play Hand'),
          ),
          ElevatedButton(
            onPressed: state.canDiscard
                ? () => game.discardCards()
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6b4fa0),
              foregroundColor: Colors.white,
            ),
            child: Text('✕ Discard (${state.discardsLeft})'),
          ),
        ],
      ),
    );
  }
}
