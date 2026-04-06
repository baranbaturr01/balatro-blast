# Balatro Blast — Shop System

## Overview

After defeating each blind, the player enters the Shop. The shop offers:
- **Joker Cards** — passive scoring modifiers (up to 5 held)
- **Tarot Cards** — one-time use card enhancements
- **Planet Cards** — upgrade hand type base values

## Shop Layout

The shop is a Flutter overlay widget (`ShopScreen`) displayed over the Flame canvas.

```
┌─────────────────────────────────────────┐
│              SHOP                       │
│  Money: $12           [Next Round →]    │
│                                         │
│  ┌────────┐  ┌────────┐  ┌────────┐    │
│  │ Joker  │  │ Joker  │  │ Tarot  │    │
│  │  $6    │  │  $8    │  │  $3    │    │
│  │ [Buy]  │  │ [Buy]  │  │ [Buy]  │    │
│  └────────┘  └────────┘  └────────┘    │
│                                         │
│  Your Jokers:                           │
│  ┌──────┐ ┌──────┐ ┌──────┐           │
│  │Greedy│ │ Sly  │ │      │           │
│  │ $3↩  │ │ $3↩  │ │      │           │
│  └──────┘ └──────┘ └──────┘           │
└─────────────────────────────────────────┘
```

## Shop Items

### Joker Cards
- 2–3 jokers offered per shop visit
- Cost: $6 (standard) or $8 (premium/multiply type)
- Can only buy if joker slots not full (max 5)

### Tarot Cards (Cost: $3)

| Tarot | Effect |
|-------|--------|
| The Fool | Copies the last Tarot used |
| The Magician | Enhances 1 selected card to Lucky (+Chips) |
| The High Priestess | Creates 2 Planet cards |
| The Empress | Enhances 2 selected cards to Bonus (+30 chips) |
| The Emperor | Creates 2 Tarot cards |
| The Hierophant | Enhances 2 selected cards to Mult (+4 mult) |
| The Lovers | Enhances 1 selected card to Wild (any suit) |
| The Chariot | Enhances 1 selected card to Steel (×1.5 mult when in hand) |
| Justice | Enhances 1 selected card to Glass (×2 mult, may break) |
| The Hermit | Doubles current money (max +$20) |
| The Wheel of Fortune | 1 in 4 chance: random Joker gains edition |
| Strength | Increases rank of 2 selected cards by 1 |
| The Hanged Man | Destroys 2 selected cards |
| Death | Converts first selected card to second selected card |
| Temperance | Gives total sell value of all Jokers held (max $50) |
| The Devil | Enhances 1 selected card to Gold (earn $3 when scored) |
| The Tower | Enhances 1 selected card to Stone (+25 chips, no rank/suit) |
| The Star | Converts 3 selected cards to Diamonds |
| The Moon | Converts 3 selected cards to Clubs |
| The Sun | Converts 3 selected cards to Hearts |
| Judgement | Creates a random Joker |
| The World | Converts 3 selected cards to Spades |

### Planet Cards (Cost: $4)

Each Planet card upgrades a specific hand type's base values (+15 chips, +1 mult per level):

| Planet | Hand Upgraded |
|--------|--------------|
| Mercury | Pair |
| Venus | Three of a Kind |
| Earth | Full House |
| Mars | Four of a Kind |
| Jupiter | Flush |
| Saturn | Straight |
| Uranus | Two Pair |
| Neptune | Straight Flush |
| Pluto | High Card |

## Economy

### Earning Money
- Base reward: $3 per blind defeated
- Remaining hands bonus: $1 per unused hand
- Interest: $1 per $5 held (capped at $5 interest per round)

### Spending Money
- Jokers: $6 or $8
- Tarot cards: $3
- Planet cards: $4
- Reroll shop: $5 (first reroll free)

### Selling Jokers
- Jokers can be sold from the shop screen
- Sell value = half of purchase price (rounded down)
- Sold jokers are removed from slots immediately

## ShopManager

```dart
class ShopManager {
  List<ShopItem> generateShopItems(); // called each visit
  bool canAfford(ShopItem item, int money);
  int purchase(ShopItem item, GameState state);  // returns new money
  int sellJoker(JokerCard joker); // returns money gained
}
```

## Shop Item Model

```dart
class ShopItem {
  final ShopItemType type; // joker, tarot, planet
  final String name;
  final String description;
  final int cost;
  final JokerCard? joker;
  final TarotCard? tarot;
  final PlanetCard? planet;
}
```
