import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/providers/game_provider.dart';
import 'package:balatro_blast/screens/main_menu_screen.dart';
import 'package:balatro_blast/screens/shop_screen.dart';
import 'package:balatro_blast/screens/blind_select_screen.dart';
import 'package:balatro_blast/screens/game_over_screen.dart';
import 'package:balatro_blast/screens/settings_screen.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

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
      backgroundColor: AppColors.background,
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

    // Only show action buttons during active gameplay.
    if (state.phase != GamePhase.playing) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background.withValues(alpha: 0.92),
            AppColors.background,
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Play Hand button
          _NeonButton(
            label: '▶  Play Hand',
            sublabel: '${state.handsLeft} left',
            enabled: state.canPlay,
            primaryColor: const Color(0xFF39FF14),
            onPressed: () => game.playHand(),
          ),
          const SizedBox(width: 32),
          // Discard button
          _NeonButton(
            label: '✕  Discard',
            sublabel: '${state.discardsLeft} left',
            enabled: state.canDiscard,
            primaryColor: const Color(0xFFFF4444),
            onPressed: () => game.discardCards(),
          ),
        ],
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  const _NeonButton({
    required this.label,
    required this.sublabel,
    required this.enabled,
    required this.primaryColor,
    required this.onPressed,
  });

  final String label;
  final String sublabel;
  final bool enabled;
  final Color primaryColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = enabled ? primaryColor : AppColors.textMuted;

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: 170,
        height: 52,
        decoration: BoxDecoration(
          color: enabled
              ? primaryColor.withValues(alpha: 0.12)
              : AppColors.surface.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: effectiveColor.withValues(alpha: enabled ? 0.9 : 0.3),
            width: 2,
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: effectiveColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              sublabel,
              style: TextStyle(
                color: effectiveColor.withValues(alpha: 0.7),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
