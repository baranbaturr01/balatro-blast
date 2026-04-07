import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/models/blind.dart';
import 'package:balatro_blast/providers/game_provider.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class BlindSelectScreen extends ConsumerWidget {
  const BlindSelectScreen({super.key, required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.watch(gameManagerProvider);
    final ante = gameManager.state.ante;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _BlindSelectBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context, ante),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _BlindCard(
                          blind: Blind.forAnte(ante, BlindType.small),
                          accentColor: AppColors.neonGreen,
                          onSelect: () => _selectBlind(BlindType.small),
                        ),
                        _BlindCard(
                          blind: Blind.forAnte(ante, BlindType.big),
                          accentColor: AppColors.neonYellow,
                          onSelect: () => _selectBlind(BlindType.big),
                        ),
                        _BlindCard(
                          blind: Blind.forAnte(ante, BlindType.boss),
                          accentColor: AppColors.neonMagenta,
                          isBoss: true,
                          onSelect: () => _selectBlind(BlindType.boss),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int ante) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.neonYellow, AppColors.goldAccent],
            ).createShader(bounds),
            child: Text(
              'ANTE $ante',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 1,
            height: 22,
            color: AppColors.mutedPurple.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 16),
          const Text(
            'Choose Your Blind',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _selectBlind(BlindType type) {
    game.gameManager.selectBlind(type);
    game.overlays.remove(kOverlayBlindSelect);
    game.onBlindSelected();
  }
}

// ---------------------------------------------------------------------------
// Individual blind card
// ---------------------------------------------------------------------------

class _BlindCard extends StatelessWidget {
  const _BlindCard({
    required this.blind,
    required this.accentColor,
    required this.onSelect,
    this.isBoss = false,
  });

  final Blind blind;
  final Color accentColor;
  final VoidCallback onSelect;
  final bool isBoss;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor,
          width: isBoss ? 2.5 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: isBoss ? 0.45 : 0.25),
            blurRadius: isBoss ? 24 : 14,
            spreadRadius: isBoss ? 3 : 1,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Blind type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.6),
              ),
            ),
            child: Text(
              blind.name.toUpperCase(),
              style: TextStyle(
                color: accentColor,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Boss icon or suit symbol
          Text(
            isBoss ? '👹' : (blind.type == BlindType.small ? '🃏' : '🂡'),
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(height: 10),

          // Target score
          Text(
            _formatScore(blind.targetScore),
            style: TextStyle(
              color: AppColors.goldAccent,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              shadows: [
                Shadow(
                  color: AppColors.goldAccent.withValues(alpha: 0.6),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const Text(
            'TARGET SCORE',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 8,
              letterSpacing: 1.5,
            ),
          ),

          // Reward
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.monetization_on,
                  color: AppColors.goldAccent, size: 12),
              const SizedBox(width: 4),
              Text(
                '+\$$kBlindWinReward reward',
                style: TextStyle(
                  color: AppColors.goldAccent.withValues(alpha: 0.8),
                  fontSize: 9,
                ),
              ),
            ],
          ),

          // Boss effect
          if (isBoss && blind.bossEffect != null) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.cardRed.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                blind.bossEffect!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.cardRed,
                  fontSize: 8,
                  height: 1.4,
                ),
              ),
            ),
          ],

          const SizedBox(height: 14),

          // Select button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onSelect,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: accentColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    'SELECT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _formatScore(int score) {
    if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(score % 1000 == 0 ? 0 : 1)}K';
    }
    return '$score';
  }
}

// ---------------------------------------------------------------------------
// Background decoration
// ---------------------------------------------------------------------------

class _BlindSelectBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(
            right: -60,
            top: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonMagenta.withValues(alpha: 0.07),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonGreen.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          ...[
            const Offset(30, 30),
            const Offset(740, 60),
            const Offset(400, 420),
          ].map(
            (p) => Positioned(
              left: p.dx,
              top: p.dy,
              child: Text(
                '♦',
                style: TextStyle(
                  fontSize: 60,
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
