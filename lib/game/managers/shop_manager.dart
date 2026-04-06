import 'dart:math';

import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/models/joker_card.dart';
import 'package:balatro_blast/models/shop_item.dart';
import 'package:balatro_blast/models/tarot_card.dart';
import 'package:balatro_blast/models/planet_card.dart';
import 'package:balatro_blast/utils/constants.dart';

class ShopManager {
  final _rng = Random();
  List<ShopItem> _currentItems = [];

  List<ShopItem> get currentItems => List.unmodifiable(_currentItems);

  void generateItems(GameState state) {
    _currentItems = [];

    // 2–3 jokers from pool.
    final jokerPool = List<JokerCard>.from(JokerCard.all)..shuffle(_rng);
    final jokerCount = _rng.nextInt(2) + 2;
    for (int i = 0; i < jokerCount && i < jokerPool.length; i++) {
      final joker = jokerPool[i];
      _currentItems.add(ShopItem(
        type: ShopItemType.joker,
        name: joker.name,
        description: joker.description,
        cost: joker.cost,
      ));
    }

    // 1 tarot card.
    final tarotPool = List<TarotCard>.from(TarotCard.all)..shuffle(_rng);
    _currentItems.add(ShopItem(
      type: ShopItemType.tarot,
      name: tarotPool.first.name,
      description: tarotPool.first.description,
      cost: TarotCard.cost,
    ));

    // 1 planet card.
    final planetPool = List<PlanetCard>.from(PlanetCard.all)..shuffle(_rng);
    _currentItems.add(ShopItem(
      type: ShopItemType.planet,
      name: planetPool.first.name,
      description: planetPool.first.description,
      cost: PlanetCard.cost,
    ));
  }

  bool canAfford(ShopItem item, int money) => money >= item.cost;

  /// Returns the joker associated with a shop item (if it's a joker item).
  JokerCard? getJokerForItem(ShopItem item) {
    if (item.type != ShopItemType.joker) return null;
    try {
      return JokerCard.all.firstWhere((j) => j.name == item.name);
    } catch (_) {
      return null;
    }
  }

  void reroll(GameState state) {
    if (state.money < kShopRerollCost) return;
    state.money -= kShopRerollCost;
    generateItems(state);
  }
}
