import 'package:flutter/material.dart';
import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key, required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.neonGreen, AppColors.neonYellow],
              ).createShader(bounds),
              child: const Text(
                'BALATRO\nBLAST',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '🃏 Roguelike Poker',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                game.gameManager.startNewRun();
                game.overlays.remove(kOverlayMainMenu);
                game.overlays.add(kOverlayBlindSelect);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text('▶  PLAY'),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                game.overlays.add(kOverlaySettings);
              },
              child: const Text('⚙  SETTINGS'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => _showHowToPlay(context),
              child: const Text('?  HOW TO PLAY'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'How to Play',
          style: TextStyle(color: AppColors.neonGreen),
        ),
        content: const SingleChildScrollView(
          child: Text(
            '1. Select up to 5 cards from your hand\n'
            '2. Tap "Play Hand" to score a poker hand\n'
            '3. Reach the target score before running out of hands\n'
            '4. Visit the shop between blinds to buy Jokers\n'
            '5. Defeat all 8 antes to win!\n\n'
            'Score = Chips × Mult\n'
            'Jokers provide powerful bonuses.',
            style: TextStyle(color: AppColors.textPrimary, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK', style: TextStyle(color: AppColors.neonGreen)),
          ),
        ],
      ),
    );
  }
}
