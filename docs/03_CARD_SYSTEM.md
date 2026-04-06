# Balatro Blast — Card System

## Playing Card Model

Each card is represented by a `PlayingCard` object:

```dart
class PlayingCard {
  final Suit suit;   // hearts, diamonds, clubs, spades
  final Rank rank;   // two through ace
  bool isSelected;   // player has tapped to select
  bool isScored;     // participates in scoring (for animation)
}
```

## Suits

| Suit | Symbol | Color |
|------|--------|-------|
| Hearts | ♥ | Red |
| Diamonds | ♦ | Red |
| Clubs | ♣ | Black |
| Spades | ♠ | Black |

## Ranks & Chip Values

| Rank | Display | Chip Value |
|------|---------|-----------|
| Two | 2 | 2 |
| Three | 3 | 3 |
| Four | 4 | 4 |
| Five | 5 | 5 |
| Six | 6 | 6 |
| Seven | 7 | 7 |
| Eight | 8 | 8 |
| Nine | 9 | 9 |
| Ten | 10 | 10 |
| Jack | J | 10 |
| Queen | Q | 10 |
| King | K | 10 |
| Ace | A | 11 |

## Deck Composition

- 52 cards total (4 suits × 13 ranks)
- Shuffled at start of each blind
- Cards played are removed from deck
- Cards discarded are removed from deck
- No reshuffle mid-round (deck is depleted)

## Card States

```
IDLE → SELECTED → PLAYED/SCORED
         ↓
      DISCARDED
```

| State | Visual |
|-------|--------|
| Idle | Normal position in hand |
| Selected | Card lifts up (y offset), subtle glow |
| Scored | Bright highlight during scoring animation |
| Discarded | Slide off to side, fade out |

## Visual Representation

Cards are drawn entirely with `CardPainter` (CustomPainter):

### Card Face
- White/cream rounded rectangle background
- Rank displayed in top-left and bottom-right corners
- Suit symbol in center (large) and corners (small)
- Red color for Hearts/Diamonds
- Black color for Clubs/Spades

### Card Back
- Dark purple/blue gradient
- Diamond lattice pattern in lighter shade
- Thin neon border

### Selected State
- Card shifts upward by 16px
- Subtle golden/green glow border

## Hand Display

The `HandComponent` manages card positions in the hand:

- Cards arranged in a horizontal fan
- Up to 8 cards displayed simultaneously
- Cards slightly overlap when 6+ are shown
- Selected cards animate upward

## Deck Component

The `DeckComponent` shows:
- A stack of face-down cards in the bottom-right corner
- Card count displayed on top
- Slight 3D offset to suggest a pile
