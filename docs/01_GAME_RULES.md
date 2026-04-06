# Balatro Blast — Game Rules

## Overview

Balatro Blast is a roguelike card game where players build poker hands to score points and defeat blinds across 8 antes.

## Deck Composition

- Standard 52-card deck (no Jokers in the deck)
- 4 suits: Hearts ♥, Diamonds ♦, Clubs ♣, Spades ♠
- 13 ranks per suit: 2 through Ace

## Hand Types & Base Values

| Hand | Base Chips | Base Mult | Description |
|------|-----------|-----------|-------------|
| High Card | 5 | 1 | No matching ranks |
| Pair | 10 | 2 | Two cards of same rank |
| Two Pair | 20 | 2 | Two different pairs |
| Three of a Kind | 30 | 3 | Three cards of same rank |
| Straight | 30 | 4 | Five consecutive ranks |
| Flush | 35 | 4 | Five cards of same suit |
| Full House | 40 | 4 | Three of a Kind + Pair |
| Four of a Kind | 60 | 7 | Four cards of same rank |
| Straight Flush | 100 | 8 | Straight + Flush |
| Royal Flush | 100 | 8 | 10-J-Q-K-A same suit |

## Scoring Formula

```
Final Score = (Base Chips + Card Chips) × (Base Mult + Joker Mult Bonuses) × Joker Mult Multipliers
```

### Card Chip Values
- Number cards (2–9): face value (e.g., 7 = 7 chips)
- 10, Jack, Queen, King: 10 chips each
- Ace: 11 chips

Only "scored" cards (those forming the hand) contribute chips.

## Game Structure

### Antes
There are 8 total antes. Each ante has 3 blinds:
1. Small Blind
2. Big Blind
3. Boss Blind

### Blind Score Targets

| Ante | Small | Big | Boss |
|------|-------|-----|------|
| 1 | 300 | 450 | 600 |
| 2 | 800 | 1,200 | 1,600 |
| 3 | 2,000 | 3,000 | 4,000 |
| 4 | 5,000 | 7,500 | 10,000 |
| 5 | 11,000 | 16,500 | 22,000 |
| 6 | 20,000 | 30,000 | 40,000 |
| 7 | 35,000 | 52,500 | 70,000 |
| 8 | 50,000 | 75,000 | 100,000 |

### Player Starting Stats
- **Hand Size**: 8 cards dealt
- **Hands per Blind**: 4
- **Discards per Blind**: 3
- **Starting Money**: $4
- **Joker Slots**: 5

## Playing a Blind

1. Draw 8 cards from shuffled deck
2. Select 1–5 cards to play
3. Hand is evaluated and scored
4. If cumulative score ≥ target: blind defeated
5. If hands run out before target: game over
6. Cards played are removed; new cards drawn to refill hand

## Discarding

- Select 1–5 cards, click Discard
- Discarded cards are removed from hand
- New cards drawn from deck
- Uses 1 discard charge

## Shop Phase

After defeating each blind:
- Earn money based on performance
- Shop offers: Jokers, Tarot cards, Planet cards
- Jokers cost $6–$8 each
- Money carries over between rounds

## Jokers

Up to 5 Jokers can be held at once. They apply passive effects during scoring. See docs/04_JOKER_SYSTEM.md for full joker list.

## Boss Blinds

Boss blinds have special negative effects such as:
- "The Needle": Only 1 hand allowed
- "The Water": No discards
- "The Club": All Club cards are debuffed
- "The Eye": No repeat hand types
- "The Mouth": Only one hand type allowed

## Victory

Defeating the Boss Blind of Ante 8 wins the run.

## Game Over

Running out of hands before reaching the blind target ends the run immediately.
