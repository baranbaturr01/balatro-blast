enum ShopItemType { joker, tarot, planet }

class ShopItem {
  const ShopItem({
    required this.type,
    required this.name,
    required this.description,
    required this.cost,
  });

  final ShopItemType type;
  final String name;
  final String description;
  final int cost;
}
