# Balatro Blast — Scoring System

## Formula

```
Final Score = Total Chips × Total Mult
```

Where:
- **Total Chips** = Base Chips (hand type) + Card Chips (scored cards) + Joker Chip Bonuses
- **Total Mult** = (Base Mult (hand type) + Joker Additive Mult Bonuses) × Joker Multiplicative Bonuses

## Step-by-Step Scoring

### Step 1: Hand Evaluation
The `PokerEvaluator` identifies the best poker hand from 1–5 played cards and returns:
- `HandType` (e.g., `flush`)
- `scoredCards`: the subset of cards that form the hand

### Step 2: Base Values
Look up `HandTypeInfo` for the identified hand:

```
High Card:         5 chips, ×1 mult
Pair:             10 chips, ×2 mult
Two Pair:         20 chips, ×2 mult
Three of a Kind:  30 chips, ×3 mult
Straight:         30 chips, ×4 mult
Flush:            35 chips, ×4 mult
Full House:       40 chips, ×4 mult
Four of a Kind:   60 chips, ×7 mult
Straight Flush:  100 chips, ×8 mult
Royal Flush:     100 chips, ×8 mult
```

### Step 3: Card Chip Contribution
Each scored card adds its chip value to the total:

```
chips += card.chipValue  (for each card in scoredCards)
```

Chip values:
- 2 → 2, 3 → 3, ..., 9 → 9
- 10, J, Q, K → 10
- A → 11

### Step 4: Joker Chip Bonuses (addChips jokers)
Applied before mult calculation:

```dart
// Example: Sly Joker (+50 chips if pair)
if (joker.type == JokerType.sly && handContainsPair) {
  chips += 50;
}
```

### Step 5: Joker Additive Mult Bonuses
Applied to base mult additively:

```dart
// Example: Jolly Joker (+8 mult if pair)
if (joker.type == JokerType.jolly && handContainsPair) {
  mult += 8;
}
```

Suit jokers iterate scored cards:
```dart
// Example: Greedy Joker (+3 mult per Diamond scored)
for (final card in scoredCards) {
  if (card.suit == Suit.diamonds) mult += 3;
}
```

### Step 6: Joker Multiplicative Mult
Applied as multipliers after all additive bonuses:

```dart
// Example: The Duo (×2 mult if pair)
if (joker.type == JokerType.duo && handContainsPair) {
  mult *= 2;
}
```

### Step 7: Final Score
```
score = chips × mult
```

## Example Calculation

**Hand**: K♥ K♦ K♣ 7♠ 3♥ (Three of a Kind)
**Jokers**: Zany Joker, The Trio

1. Hand type: Three of a Kind → 30 chips, 3 mult
2. Scored cards: K♥, K♦, K♣ (the three kings)
3. Card chips: 10 + 10 + 10 = 30
4. Total chips so far: 30 + 30 = 60
5. Zany Joker: +12 mult → mult = 3 + 12 = 15
6. The Trio: ×3 mult → mult = 15 × 3 = 45
7. **Final score = 60 × 45 = 2,700**

## Score Accumulation

Scores from multiple hands within a blind are **added together**:

```
Blind Target: 600
Hand 1 score: 250  → Running total: 250
Hand 2 score: 400  → Running total: 650 ✓ (blind defeated!)
```

## Money Rewards

| Performance | Money Earned |
|-------------|--------------|
| Win blind | $3 base |
| Remaining hands | +$1 per hand left |
| Interest | +$1 per $5 held (max $5) |
| Blind skip bonus | +$3 (if skipped) |

## ScoringResult Object

```dart
class ScoringResult {
  final int chips;
  final int mult;
  final HandType handType;
  final List<PlayingCard> scoredCards;
  
  int get score => chips * mult;
}
```
