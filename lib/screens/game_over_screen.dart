import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/providers/game_provider.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class GameOverScreen extends ConsumerWidget {
  const GameOverScreen({super.key, required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.watch(gameManagerProvider);
    final state = gameManager.state;
    final isVictory = state.phase == GamePhase.victory;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isVictory ? '🏆 VICTORY!' : '💀 GAME OVER',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isVictory ? AppColors.neonYellow : AppColors.cardRed,
                shadows: [
                  Shadow(
                    color: (isVictory ? AppColors.neonYellow : AppColors.cardRed)
                        .withValues(alpha: 0.8),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _StatRow(
              label: 'Final Score',
              value: '${state.runningScore}',
              color: AppColors.neonYellow,
            ),
            _StatRow(
              label: 'Ante Reached',
              value: '${state.ante}',
              color: AppColors.neonGreen,
            ),
            _StatRow(
              label: 'Money',
              value: '\$${state.money}',
              color: AppColors.goldAccent,
            ),
            _StatRow(
              label: 'Jokers',
              value: '${state.jokers.length}',
              color: AppColors.neonMagenta,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove(kOverlayGameOver);
                game.gameManager.startNewRun();
                game.overlays.add(kOverlayBlindSelect);
              },
              child: const Text('▶  PLAY AGAIN'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                game.overlays.remove(kOverlayGameOver);
                game.overlays.add(kOverlayMainMenu);
              },
              child: const Text('⌂  MAIN MENU'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
