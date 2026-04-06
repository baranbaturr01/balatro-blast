# Balatro Blast — Project Overview

## What Is Balatro Blast?

Balatro Blast is a roguelike poker card game built with Flutter and the Flame game engine. Inspired by the game Balatro, players build poker hands to score points, defeat blinds, and collect powerful Joker cards that modify scoring in wild ways.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI Framework | Flutter 3.x |
| Game Engine | Flame 1.18.0 |
| State Management | Riverpod 2.x (flutter_riverpod) |
| Local Storage | Hive 2.x |
| Fonts | Google Fonts |
| Language | Dart 3.x |

## Project File Structure

```
balatro-blast/
├── docs/                        # Design & reference documentation
├── lib/
│   ├── main.dart                # App entry point
│   ├── game/                    # Flame game layer
│   │   ├── balatro_blast_game.dart
│   │   ├── components/          # Flame PositionComponents
│   │   └── managers/            # Game logic coordinators
│   ├── models/                  # Plain Dart data models
│   ├── engine/                  # Core game logic (evaluator, scoring)
│   ├── screens/                 # Flutter widget screens / overlays
│   ├── painters/                # CustomPainter implementations
│   ├── providers/               # Riverpod providers
│   ├── storage/                 # Hive persistence
│   └── utils/                   # Constants, theme, extensions
└── test/                        # Unit tests
```

## Two-Layer Architecture

```
┌─────────────────────────────────────┐
│         Flutter UI Layer            │
│  Screens (overlays): Menu, Shop,    │
│  BlindSelect, GameOver, Settings    │
├─────────────────────────────────────┤
│         Flame Game Layer            │
│  BalatraBlastGame (FlameGame)       │
│  Components: Cards, Jokers, Score   │
├─────────────────────────────────────┤
│         Business Logic Layer        │
│  GameManager, ScoringEngine,        │
│  PokerEvaluator, JokerEngine        │
├─────────────────────────────────────┤
│         Data / Storage Layer        │
│  Hive, SaveManager, StatsManager    │
└─────────────────────────────────────┘
```

## Core Game Loop

1. **Blind Select** — Choose to face Small, Big, or Boss blind
2. **Playing Phase** — Select up to 5 cards, play or discard
3. **Scoring** — Poker hand evaluated, chips × mult calculated
4. **Advance** — Win blind → go to shop; lose all hands → game over
5. **Shop** — Buy Jokers, Tarots, Planets with earned money
6. **Repeat** — Progress through 8 antes

## Key Design Decisions

- **No image assets** — All card visuals are drawn with `CustomPainter` and Canvas
- **Riverpod** for dependency injection and reactive UI updates
- **Flame overlays** bridge the Flame canvas and Flutter widget UI
- **ChangeNotifier** pattern on `GameManager` keeps UI in sync
