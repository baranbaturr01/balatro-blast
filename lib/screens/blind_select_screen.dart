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
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'ANTE $ante',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const Text(
              'Choose Your Blind',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BlindCard(
                    blind: Blind.forAnte(ante, BlindType.small),
                    onSelect: () => _selectBlind(context, BlindType.small),
                  ),
                  _BlindCard(
                    blind: Blind.forAnte(ante, BlindType.big),
                    onSelect: () => _selectBlind(context, BlindType.big),
                  ),
                  _BlindCard(
                    blind: Blind.forAnte(ante, BlindType.boss),
                    onSelect: () => _selectBlind(context, BlindType.boss),
                    isBoss: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _selectBlind(BuildContext context, BlindType type) {
    game.gameManager.selectBlind(type);
    game.overlays.remove(kOverlayBlindSelect);
    game.onBlindSelected();
  }
}

class _BlindCard extends StatelessWidget {
  const _BlindCard({
    required this.blind,
    required this.onSelect,
    this.isBoss = false,
  });

  final Blind blind;
  final VoidCallback onSelect;
  final bool isBoss;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isBoss ? AppColors.neonMagenta : AppColors.neonGreen;

    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            blind.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: borderColor,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${blind.targetScore}',
            style: TextStyle(
              color: AppColors.neonYellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'pts',
            style: TextStyle(color: AppColors.textMuted, fontSize: 8),
          ),
          if (isBoss && blind.bossEffect != null) ...[
            const SizedBox(height: 6),
            Text(
              blind.bossEffect!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.neonMagenta,
                fontSize: 7,
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: borderColor,
                padding: const EdgeInsets.symmetric(vertical: 6),
                minimumSize: Size.zero,
              ),
              child: const Text('SELECT', style: TextStyle(fontSize: 8)),
            ),
          ),
        ],
      ),
    );
  }
}
