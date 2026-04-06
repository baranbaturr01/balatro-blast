# Balatro Blast 🃏

A roguelike poker card game built with Flutter and the Flame game engine.

## About

Balatro Blast is inspired by the game Balatro. Build poker hands, collect powerful Joker cards, and try to defeat all 8 antes before running out of hands.

## Features

- 🃏 Full poker hand evaluation (High Card through Royal Flush)
- 🤡 20 unique Joker cards with distinct effects
- 🏪 Shop system with Jokers, Tarot cards, and Planet cards
- 💜 Stunning dark neon visual theme
- 🎮 Smooth card animations via Flame engine
- 💾 Save/load progress via Hive

## How to Play

1. **Select Cards**: Tap 1–5 cards from your hand
2. **Play Hand**: Score a poker hand to chip away at the blind target
3. **Discard**: Replace up to 5 cards if you need better options
4. **Defeat Blinds**: Reach the target score before running out of hands
5. **Visit Shop**: Buy Jokers between blinds
6. **Survive 8 Antes**: Complete all 8 antes to win the run

## Scoring

```
Score = Total Chips × Total Mult
```

- **Chips** come from the hand type base + each scored card's value
- **Mult** comes from the hand type base + Joker bonuses
- Joker cards can add to chips, add to mult, or multiply mult

## Hand Values

| Hand | Chips | Mult |
|------|-------|------|
| High Card | 5 | ×1 |
| Pair | 10 | ×2 |
| Two Pair | 20 | ×2 |
| Three of a Kind | 30 | ×3 |
| Straight | 30 | ×4 |
| Flush | 35 | ×4 |
| Full House | 40 | ×4 |
| Four of a Kind | 60 | ×7 |
| Straight Flush | 100 | ×8 |
| Royal Flush | 100 | ×8 |

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart SDK ≥ 3.0.0

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/balatro-blast.git
cd balatro-blast

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Running Tests

```bash
flutter test
```

### Building

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Project Structure

See [docs/02_ARCHITECTURE.md](docs/02_ARCHITECTURE.md) for detailed architecture documentation.

## Documentation

- [BASE.md](docs/BASE.md) — Project overview
- [01_GAME_RULES.md](docs/01_GAME_RULES.md) — Complete game rules
- [02_ARCHITECTURE.md](docs/02_ARCHITECTURE.md) — Technical architecture
- [03_CARD_SYSTEM.md](docs/03_CARD_SYSTEM.md) — Card models and visuals
- [04_JOKER_SYSTEM.md](docs/04_JOKER_SYSTEM.md) — All 20 jokers
- [05_SCORING.md](docs/05_SCORING.md) — Scoring formula
- [06_SHOP_SYSTEM.md](docs/06_SHOP_SYSTEM.md) — Shop mechanics
- [07_UI_DESIGN.md](docs/07_UI_DESIGN.md) — UI design system
- [08_PROMPT_GUIDE.md](docs/08_PROMPT_GUIDE.md) — AI development guide
- [09_ROADMAP.md](docs/09_ROADMAP.md) — Future features

## Tech Stack

- **Flutter** 3.x — UI framework
- **Flame** 1.18.0 — Game engine for canvas rendering
- **Riverpod** 2.x — State management
- **Hive** 2.x — Local storage
- **Google Fonts** — Typography

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-joker`)
3. Commit your changes (`git commit -m 'Add amazing joker'`)
4. Push to the branch (`git push origin feature/amazing-joker`)
5. Open a Pull Request

## License

MIT License — see LICENSE file for details.
