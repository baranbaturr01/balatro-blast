import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/game/managers/game_manager.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/shop_item.dart';
import 'package:balatro_blast/painters/joker_painter.dart';
import 'package:balatro_blast/providers/game_provider.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key, required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.watch(gameManagerProvider);
    final state = gameManager.state;
    final items = gameManager.shopManager.currentItems;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SHOP',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: AppColors.goldAccent, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '\$${state.money}',
                        style: const TextStyle(
                          color: AppColors.goldAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Shop items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: items
                    .map((item) => _ShopItemCard(
                          item: item,
                          canAfford:
                              gameManager.shopManager.canAfford(item, state.money),
                          onBuy: () => _buyItem(context, gameManager, item),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(color: AppColors.mutedPurple),

            // Current jokers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'YOUR JOKERS',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 1.2,
                      ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.jokers
                    .map((joker) => _OwnedJokerCard(
                          joker: joker,
                          onSell: () {
                            gameManager.sellJoker(joker);
                          },
                        ))
                    .toList(),
              ),
            ),

            const Spacer(),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => game.onShopClosed(),
                  child: const Text('Next Round  →'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buyItem(
    BuildContext context,
    GameManager gameManager,
    ShopItem item,
  ) {
    if (item.type == ShopItemType.joker) {
      final joker = gameManager.shopManager.getJokerForItem(item);
      if (joker != null) {
        final success = gameManager.buyJoker(joker);
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cannot buy — slots full or not enough money')),
          );
        }
      }
    }
    // Tarot and Planet card effects would be applied here in a full implementation.
  }
}

class _ShopItemCard extends StatelessWidget {
  const _ShopItemCard({
    required this.item,
    required this.canAfford,
    required this.onBuy,
  });

  final ShopItem item;
  final bool canAfford;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: canAfford ? AppColors.neonGreen : AppColors.mutedPurple,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Item visual area
          Padding(
            padding: const EdgeInsets.all(8),
            child: item.type == ShopItemType.joker
                ? _buildJokerPreview()
                : _buildGenericPreview(),
          ),
          Text(
            item.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 7),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: canAfford ? onBuy : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(60, 24),
              padding: EdgeInsets.zero,
            ),
            child: Text('\$${item.cost}',
                style: const TextStyle(fontSize: 10)),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildJokerPreview() {
    final jokerCard = JokerCard.all.firstWhere(
      (j) => j.name == item.name,
      orElse: () => JokerCard.all.first,
    );
    return SizedBox(
      width: kJokerWidth * 0.9,
      height: kJokerHeight * 0.9,
      child: CustomPaint(
        painter: JokerPainter(joker: jokerCard),
      ),
    );
  }

  Widget _buildGenericPreview() {
    final color = item.type == ShopItemType.tarot
        ? AppColors.neonMagenta
        : AppColors.neonBlue;
    return Container(
      width: kJokerWidth * 0.9,
      height: kJokerHeight * 0.9,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          item.type == ShopItemType.tarot ? '🔮' : '🪐',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class _OwnedJokerCard extends StatelessWidget {
  const _OwnedJokerCard({required this.joker, required this.onSell});

  final JokerCard joker;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: kJokerWidth,
          height: kJokerHeight,
          child: CustomPaint(painter: JokerPainter(joker: joker)),
        ),
        TextButton(
          onPressed: () => _confirmSell(context),
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          ),
          child: Text(
            'Sell \$${joker.sellValue}',
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 8,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmSell(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Sell ${joker.name}?',
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
        content: Text(
          'Receive \$${joker.sellValue}',
          style: const TextStyle(color: AppColors.goldAccent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onSell();
            },
            child: const Text('Sell',
                style: TextStyle(color: AppColors.cardRed)),
          ),
        ],
      ),
    );
  }
}
