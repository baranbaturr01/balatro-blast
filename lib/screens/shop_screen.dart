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
    final canReroll = state.money >= kShopRerollCost;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context, state.money),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shop items column
                  Expanded(
                    flex: 6,
                    child: _buildShopItems(context, gameManager, items, state.money),
                  ),
                  // Vertical divider
                  Container(
                    width: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: AppColors.mutedPurple.withValues(alpha: 0.4),
                  ),
                  // Owned jokers column
                  Expanded(
                    flex: 4,
                    child: _buildOwnedJokers(context, gameManager, state.jokers),
                  ),
                ],
              ),
            ),
            _buildBottomBar(context, gameManager, canReroll),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int money) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.mutedPurple.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.neonBlue, AppColors.neonMagenta],
            ).createShader(bounds),
            child: const Text(
              '🛒  SHOP',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.goldAccent.withValues(alpha: 0.6),
              ),
            ),
            child: Row(
              children: [
                const Text('💰', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 6),
                Text(
                  '\$$money',
                  style: const TextStyle(
                    color: AppColors.goldAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItems(
    BuildContext context,
    GameManager gameManager,
    List<ShopItem> items,
    int money,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Text(
            'FOR SALE',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 9,
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: _ShopItemCard(
                        item: item,
                        canAfford: gameManager.shopManager.canAfford(item, money),
                        onBuy: () => _buyItem(context, gameManager, item),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnedJokers(
    BuildContext context,
    GameManager gameManager,
    List<JokerCard> jokers,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
          child: Row(
            children: [
              const Text(
                'YOUR JOKERS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 9,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.neonMagenta.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.neonMagenta.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '${jokers.length}/$kMaxJokers',
                  style: const TextStyle(
                    color: AppColors.neonMagenta,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: jokers.isEmpty
              ? Center(
                  child: Text(
                    'No jokers yet',
                    style: TextStyle(
                      color: AppColors.textMuted.withValues(alpha: 0.5),
                      fontSize: 10,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: jokers
                        .map(
                          (joker) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _OwnedJokerCard(
                              joker: joker,
                              onSell: () => gameManager.sellJoker(joker),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    GameManager gameManager,
    bool canReroll,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.mutedPurple.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Reroll button
          GestureDetector(
            onTap: canReroll ? () => gameManager.rerollShop() : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: canReroll
                    ? AppColors.neonYellow.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: canReroll
                      ? AppColors.neonYellow
                      : AppColors.mutedPurple.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: canReroll
                    ? [
                        BoxShadow(
                          color: AppColors.neonYellow.withValues(alpha: 0.25),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              child: Text(
                '🔄  REROLL  \$$kShopRerollCost',
                style: TextStyle(
                  color: canReroll
                      ? AppColors.neonYellow
                      : AppColors.mutedPurple.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const Spacer(),
          // Next round button
          GestureDetector(
            onTap: () => game.onShopClosed(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neonGreen, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.neonGreen.withValues(alpha: 0.35),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Text(
                'NEXT ROUND  →',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
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
            const SnackBar(
              content: Text('Cannot buy — slots full or not enough money'),
              backgroundColor: AppColors.surface,
            ),
          );
        }
      }
    }
    // Tarot and Planet card effects would be applied here in a full implementation.
  }
}

// ---------------------------------------------------------------------------
// Shop item card
// ---------------------------------------------------------------------------

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
    final borderColor = canAfford ? _typeColor : AppColors.mutedPurple;

    return Container(
      width: 92,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: canAfford
            ? [
                BoxShadow(
                  color: _typeColor.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Type label
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: _typeColor.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Text(
              _typeLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _typeColor,
                fontSize: 7,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Visual preview
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: item.type == ShopItemType.joker
                ? _buildJokerPreview()
                : _buildGenericPreview(),
          ),

          // Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 7,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Buy button
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
            child: GestureDetector(
              onTap: canAfford ? onBuy : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: canAfford
                      ? AppColors.neonGreen.withValues(alpha: 0.2)
                      : AppColors.mutedPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: canAfford
                        ? AppColors.neonGreen
                        : AppColors.mutedPurple.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '\$${item.cost}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: canAfford
                        ? AppColors.neonGreen
                        : AppColors.mutedPurple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color get _typeColor => switch (item.type) {
        ShopItemType.joker => AppColors.neonYellow,
        ShopItemType.tarot => AppColors.neonMagenta,
        ShopItemType.planet => AppColors.neonBlue,
      };

  String get _typeLabel => switch (item.type) {
        ShopItemType.joker => 'JOKER',
        ShopItemType.tarot => 'TAROT',
        ShopItemType.planet => 'PLANET',
      };

  Widget _buildJokerPreview() {
    final jokerCard = JokerCard.all.firstWhere(
      (j) => j.name == item.name,
      orElse: () => JokerCard.all.first,
    );
    return SizedBox(
      width: kJokerWidth * 0.85,
      height: kJokerHeight * 0.85,
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
      width: kJokerWidth * 0.85,
      height: kJokerHeight * 0.85,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Text(
          item.type == ShopItemType.tarot ? '🔮' : '🪐',
          style: const TextStyle(fontSize: 26),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Owned joker card
// ---------------------------------------------------------------------------

class _OwnedJokerCard extends StatelessWidget {
  const _OwnedJokerCard({required this.joker, required this.onSell});

  final JokerCard joker;
  final VoidCallback onSell;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonMagenta.withValues(alpha: 0.15),
                blurRadius: 8,
              ),
            ],
          ),
          child: SizedBox(
            width: kJokerWidth * 0.85,
            height: kJokerHeight * 0.85,
            child: CustomPaint(painter: JokerPainter(joker: joker)),
          ),
        ),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: () => _confirmSell(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.cardRed.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.cardRed.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              'SELL \$${joker.sellValue}',
              style: const TextStyle(
                color: AppColors.cardRed,
                fontSize: 7,
                fontWeight: FontWeight.bold,
              ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.cardRed.withValues(alpha: 0.5),
          ),
        ),
        title: Text(
          'Sell ${joker.name}?',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
        content: Text(
          'Receive \$${joker.sellValue}',
          style: const TextStyle(color: AppColors.goldAccent),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onSell();
            },
            child: const Text(
              'Sell',
              style: TextStyle(color: AppColors.cardRed),
            ),
          ),
        ],
      ),
    );
  }
}

