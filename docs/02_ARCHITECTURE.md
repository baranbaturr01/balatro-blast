# Balatro Blast — Architecture

## Overview

Balatro Blast uses a hybrid Flutter + Flame architecture. The Flame engine handles real-time rendering and animations while Flutter widgets provide menus, shop, and overlay UI.

## Layer Diagram

```
┌──────────────────────────────────────────────┐
│                 Flutter App                   │
│  ProviderScope → BalatraBlastApp              │
│                     ↓                         │
│              GameScreen (StatelessWidget)     │
│                     ↓                         │
│  ┌────────────────────────────────────────┐   │
│  │         GameWidget (Flame)             │   │
│  │   BalatraBlastGame extends FlameGame   │   │
│  │                                        │   │
│  │   Components:                          │   │
│  │   - HandComponent                      │   │
│  │   - ScoreDisplayComponent              │   │
│  │   - JokerSlotComponent                 │   │
│  │   - DeckComponent                      │   │
│  └────────────────────────────────────────┘   │
│                     ↓ (overlays)              │
│  ┌─────────────────────────────────────────┐  │
│  │  Flutter Overlays (via game.overlays)   │  │
│  │  - 'mainMenu'  → MainMenuScreen        │  │
│  │  - 'shop'      → ShopScreen            │  │
│  │  - 'blindSelect' → BlindSelectScreen   │  │
│  │  - 'gameOver'  → GameOverScreen        │  │
│  │  - 'settings'  → SettingsScreen        │  │
│  └─────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
```

## State Management

### Riverpod Providers

```
gameManagerProvider (ChangeNotifierProvider)
    └── GameManager (ChangeNotifier)
            ├── GameState (current game data)
            ├── ScoreManager
            ├── RoundManager
            └── ShopManager

settingsProvider (StateNotifierProvider)
    └── SettingsNotifier → SettingsState
```

### Data Flow

```
User Tap (Flame component)
    ↓
CardComponent.onTapDown()
    ↓
BalatraBlastGame.onCardTapped()
    ↓
GameManager.selectCard()
    ↓
GameState updated + notifyListeners()
    ↓
Flame components re-render
Flutter overlays re-build (if visible)
```

## Directory Structure

```
lib/
├── main.dart              # App entry point, Hive init, ProviderScope
├── game/
│   ├── balatro_blast_game.dart    # FlameGame root
│   ├── components/
│   │   ├── card_component.dart    # Single card rendering + tap
│   │   ├── hand_component.dart    # Hand layout manager
│   │   ├── deck_component.dart    # Deck pile visual
│   │   ├── joker_slot_component.dart
│   │   └── score_display_component.dart
│   └── managers/
│       ├── game_manager.dart      # Central coordinator (ChangeNotifier)
│       ├── score_manager.dart
│       ├── round_manager.dart
│       ├── shop_manager.dart
│       └── sound_manager.dart
├── models/                # Pure data classes
│   ├── playing_card.dart
│   ├── joker_card.dart
│   ├── hand_type.dart
│   ├── blind.dart
│   ├── shop_item.dart
│   ├── tarot_card.dart
│   ├── planet_card.dart
│   └── game_state.dart
├── engine/                # Pure logic, no Flutter dependencies
│   ├── poker_evaluator.dart
│   ├── scoring_engine.dart
│   └── joker_engine.dart
├── screens/               # Flutter widget screens
│   ├── main_menu_screen.dart
│   ├── game_screen.dart
│   ├── shop_screen.dart
│   ├── blind_select_screen.dart
│   ├── game_over_screen.dart
│   └── settings_screen.dart
├── painters/              # CustomPainter implementations
│   ├── card_painter.dart
│   ├── joker_painter.dart
│   ├── card_back_painter.dart
│   └── particle_painter.dart
├── providers/
│   ├── game_provider.dart
│   └── settings_provider.dart
├── storage/
│   ├── save_manager.dart
│   └── stats_manager.dart
└── utils/
    ├── constants.dart
    ├── theme.dart
    └── extensions.dart
```

## Key Architectural Decisions

### Why Flame + Flutter Hybrid?
- Flame provides smooth canvas rendering for card animations
- Flutter provides rich widget-based UI for menus and shop screens
- Flame overlays allow Flutter widgets to appear on top of the game canvas

### Why Riverpod?
- Type-safe dependency injection
- Works seamlessly with both Flutter and non-Flutter code
- `ChangeNotifierProvider` wraps `GameManager` cleanly

### Why No Asset Images?
- Reduces app size
- Avoids licensing issues
- CustomPainter approach is flexible and extensible

## Testing Strategy

- Engine layer (poker_evaluator, scoring_engine, joker_engine) is pure Dart — fully unit testable
- Models have no Flutter dependencies — easily testable
- UI and Flame components tested manually / integration tests
