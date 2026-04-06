# Balatro Blast — Joker System

## Overview

Jokers are powerful passive modifiers that change how scoring works. Players can hold up to 5 Jokers simultaneously. Jokers are evaluated after each hand is played.

## Joker Effect Types

| Type | Description |
|------|-------------|
| `addMult` | Adds flat value to the mult total |
| `addChips` | Adds flat value to the chip total |
| `multiplyMult` | Multiplies the current mult by a value |

## The 20 Jokers

### Suit-Based Mult Jokers

| # | Name | Effect | Cost |
|---|------|--------|------|
| 1 | Greedy Joker | +3 Mult for each Diamond card scored | $6 |
| 2 | Lusty Joker | +3 Mult for each Heart card scored | $6 |
| 3 | Wrathful Joker | +3 Mult for each Spade card scored | $6 |
| 4 | Gluttonous Joker | +3 Mult for each Club card scored | $6 |

### Hand-Type Mult Jokers (Additive)

| # | Name | Effect | Cost |
|---|------|--------|------|
| 5 | Jolly Joker | +8 Mult if hand contains a Pair | $6 |
| 6 | Zany Joker | +12 Mult if hand contains Three of a Kind | $6 |
| 7 | Mad Joker | +10 Mult if hand contains Two Pair | $6 |
| 8 | Crazy Joker | +12 Mult if hand is a Straight | $6 |
| 9 | Droll Joker | +10 Mult if hand is a Flush | $6 |

### Hand-Type Chip Jokers (Additive)

| # | Name | Effect | Cost |
|---|------|--------|------|
| 10 | Sly Joker | +50 Chips if hand contains a Pair | $6 |
| 11 | Wily Joker | +100 Chips if hand contains Three of a Kind | $6 |
| 12 | Clever Joker | +80 Chips if hand contains Two Pair | $6 |
| 13 | Devious Joker | +100 Chips if hand is a Straight | $6 |
| 14 | Crafty Joker | +80 Chips if hand is a Flush | $6 |

### Size-Based Joker

| # | Name | Effect | Cost |
|---|------|--------|------|
| 15 | Half Joker | +20 Mult if played hand has 3 or fewer cards | $7 |

### Multiplicative Mult Jokers

| # | Name | Effect | Cost |
|---|------|--------|------|
| 16 | The Duo | ×2 Mult if hand contains a Pair | $8 |
| 17 | The Trio | ×3 Mult if hand contains Three of a Kind | $8 |
| 18 | The Family | ×4 Mult if hand contains Four of a Kind | $8 |
| 19 | The Order | ×3 Mult if hand is a Straight | $8 |
| 20 | The Tribe | ×2 Mult if hand is a Flush | $8 |

## Joker Evaluation Order

Jokers are evaluated in slot order (left to right). The order matters for multiplicative jokers:

```
1. Calculate base chips (hand type + card values)
2. Calculate base mult (hand type)
3. Apply addChips jokers (in order)
4. Apply addMult jokers (in order)
5. Apply multiplyMult jokers (in order)
6. Final score = chips × mult
```

## Joker Engine Logic

```dart
ScoringResult applyJokers(
  ScoringResult base,
  List<JokerCard> jokers,
  List<PlayingCard> scoredCards,
  HandType handType,
  int playedCardCount,
) {
  int chips = base.chips;
  int mult = base.mult;

  // Pass 1: addChips
  for (final joker in jokers) {
    chips += _getChipBonus(joker, handType, scoredCards);
  }

  // Pass 2: addMult
  for (final joker in jokers) {
    mult += _getMultBonus(joker, handType, scoredCards, playedCardCount);
  }

  // Pass 3: multiplyMult
  for (final joker in jokers) {
    mult = (mult * _getMultMultiplier(joker, handType)).round();
  }

  return ScoringResult(chips: chips, mult: mult, ...);
}
```

## Joker Slots

- Maximum 5 jokers at a time
- Jokers can be sold back in the shop for half their purchase price
- Jokers occupy visible slots in the game HUD

## Visual Design

Jokers are rendered by `JokerPainter`:
- Dark background with neon border
- Joker name in neon text
- Abbreviated effect description
- Unique color accent per joker category:
  - Suit jokers: suit color (red/black)
  - Chip jokers: gold/yellow
  - Mult jokers: green
  - Multiply jokers: purple/magenta
