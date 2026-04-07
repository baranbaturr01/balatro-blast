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
      body: Stack(
        children: [
          _BackgroundDecor(),
          Row(
            children: [
              Expanded(child: _buildTitleSection()),
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 40),
                color: AppColors.mutedPurple.withValues(alpha: 0.4),
              ),
              Expanded(child: _buildButtonSection(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.neonGreen, AppColors.neonYellow, AppColors.neonGreen],
              ).createShader(bounds),
              child: Text(
                'BALATRO\nBLAST',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(
                      color: AppColors.neonGreen.withValues(alpha: 0.9),
                      blurRadius: 24,
                    ),
                    Shadow(
                      color: AppColors.neonYellow.withValues(alpha: 0.5),
                      blurRadius: 48,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.neonBlue.withValues(alpha: 0.5),
                ),
                color: AppColors.neonBlue.withValues(alpha: 0.08),
              ),
              child: const Text(
                'Roguelike Poker Adventure',
                style: TextStyle(
                  color: AppColors.neonBlue,
                  fontSize: 10,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonSection(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _NeonButton(
              label: '▶  NEW GAME',
              color: AppColors.neonGreen,
              filled: true,
              onPressed: () {
                game.gameManager.startNewRun();
                game.overlays.remove(kOverlayMainMenu);
                game.overlays.add(kOverlayBlindSelect);
              },
            ),
            const SizedBox(height: 14),
            _NeonButton(
              label: '?  HOW TO PLAY',
              color: AppColors.neonBlue,
              filled: false,
              onPressed: () => _showHowToPlay(context),
            ),
            const SizedBox(height: 14),
            _NeonButton(
              label: '⚙  SETTINGS',
              color: AppColors.mutedPurple,
              filled: false,
              onPressed: () => game.overlays.add(kOverlaySettings),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.neonBlue.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        title: const Text(
          'How to Play',
          style: TextStyle(
            color: AppColors.neonGreen,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
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
            style: TextStyle(
              color: AppColors.textPrimary,
              height: 1.6,
              fontSize: 13,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.neonGreen),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Background decoration (card symbols + radial glows)
// ---------------------------------------------------------------------------

class _BackgroundDecor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          // Radial glow – left side
          Positioned(
            left: -80,
            top: -80,
            child: _RadialGlow(color: AppColors.neonMagenta.withValues(alpha: 0.07), size: 380),
          ),
          // Radial glow – right side
          Positioned(
            right: -60,
            bottom: -60,
            child: _RadialGlow(color: AppColors.neonBlue.withValues(alpha: 0.06), size: 320),
          ),
          // Scattered card suit symbols
          ..._suitPositions.map(
            (p) => Positioned(
              left: p.dx,
              top: p.dy,
              child: Text(
                p.label,
                style: TextStyle(
                  fontSize: p.size,
                  color: AppColors.mutedPurple.withValues(alpha: 0.13),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const List<_SuitPos> _suitPositions = [
    _SuitPos(dx: 18, dy: 12, label: '♠', size: 88),
    _SuitPos(dx: 130, dy: 55, label: '♣', size: 60),
    _SuitPos(dx: 55, dy: 220, label: '♥', size: 100),
    _SuitPos(dx: 190, dy: 370, label: '♦', size: 72),
    _SuitPos(dx: 680, dy: 20, label: '♦', size: 80),
    _SuitPos(dx: 720, dy: 290, label: '♠', size: 96),
    _SuitPos(dx: 590, dy: 380, label: '♥', size: 64),
    _SuitPos(dx: 340, dy: 400, label: '♣', size: 56),
  ];
}

class _SuitPos {
  const _SuitPos({
    required this.dx,
    required this.dy,
    required this.label,
    required this.size,
  });
  final double dx;
  final double dy;
  final String label;
  final double size;
}

class _RadialGlow extends StatelessWidget {
  const _RadialGlow({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable neon button widget
// ---------------------------------------------------------------------------

class _NeonButton extends StatelessWidget {
  const _NeonButton({
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
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: filled ? color.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 14,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: filled ? Colors.black : color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
