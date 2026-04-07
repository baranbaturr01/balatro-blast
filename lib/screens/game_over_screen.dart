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
      body: Stack(
        children: [
          _GameOverBackground(isVictory: isVictory),
          SafeArea(
            child: Row(
              children: [
                // Left side: title + emblem
                Expanded(
                  flex: 5,
                  child: _buildTitleSection(isVictory),
                ),
                // Divider
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  color: AppColors.mutedPurple.withValues(alpha: 0.4),
                ),
                // Right side: stats + buttons
                Expanded(
                  flex: 5,
                  child: _buildStatsSection(context, state, isVictory),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(bool isVictory) {
    final titleColor = isVictory ? AppColors.goldAccent : AppColors.cardRed;
    final titleText = isVictory ? 'VICTORY!' : 'GAME\nOVER';
    final icon = isVictory ? '🏆' : '💀';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isVictory
                  ? [AppColors.neonYellow, AppColors.goldAccent]
                  : [const Color(0xFFff4444), AppColors.cardRed],
            ).createShader(bounds),
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.05,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: titleColor.withValues(alpha: 0.9),
                    blurRadius: 30,
                  ),
                  Shadow(
                    color: titleColor.withValues(alpha: 0.4),
                    blurRadius: 60,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isVictory ? 'You conquered all 8 antes!' : 'Better luck next time',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    GameState state,
    bool isVictory,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stats panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.mutedPurple.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              children: [
                _StatRow(
                  label: 'Final Score',
                  value: _formatNumber(state.runningScore),
                  color: AppColors.neonYellow,
                  icon: '⭐',
                ),
                const _StatDivider(),
                _StatRow(
                  label: 'Ante Reached',
                  value: '${state.ante} / $kTotalAntes',
                  color: AppColors.neonGreen,
                  icon: '🎯',
                ),
                const _StatDivider(),
                _StatRow(
                  label: 'Money',
                  value: '\$${state.money}',
                  color: AppColors.goldAccent,
                  icon: '💰',
                ),
                const _StatDivider(),
                _StatRow(
                  label: 'Jokers',
                  value: '${state.jokers.length} / $kMaxJokers',
                  color: AppColors.neonMagenta,
                  icon: '🃏',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action buttons
          _ActionButton(
            label: '▶  PLAY AGAIN',
            color: AppColors.neonGreen,
            filled: true,
            onPressed: () {
              game.overlays.remove(kOverlayGameOver);
              game.gameManager.startNewRun();
              game.overlays.add(kOverlayBlindSelect);
            },
          ),
          const SizedBox(height: 10),
          _ActionButton(
            label: '⌂  MAIN MENU',
            color: AppColors.mutedPurple,
            filled: false,
            onPressed: () {
              game.overlays.remove(kOverlayGameOver);
              game.overlays.add(kOverlayMainMenu);
            },
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

// ---------------------------------------------------------------------------
// Supporting widgets
// ---------------------------------------------------------------------------

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.mutedPurple.withValues(alpha: 0.3),
      height: 8,
      thickness: 1,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: filled ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.black : color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _GameOverBackground extends StatelessWidget {
  const _GameOverBackground({required this.isVictory});
  final bool isVictory;

  @override
  Widget build(BuildContext context) {
    final glowColor = isVictory ? AppColors.goldAccent : AppColors.cardRed;
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            left: -60,
            top: -60,
            child: Container(
              width: 360,
              height: 360,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glowColor.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -40,
            bottom: -40,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.mutedPurple.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ...[
            const Offset(20, 20),
            const Offset(720, 30),
            const Offset(380, 400),
            const Offset(700, 380),
          ].map(
            (p) => Positioned(
              left: p.dx,
              top: p.dy,
              child: Text(
                '♠',
                style: TextStyle(
                  fontSize: 50,
                  color: AppColors.mutedPurple.withValues(alpha: 0.10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
