# Balatro Blast — AI Prompt Guide

This document provides guidance for using AI assistants (GitHub Copilot, Claude, etc.) to extend or modify Balatro Blast.

## Project Context Prompt

When starting a new AI session, provide this context:

```
I'm working on Balatro Blast, a Flutter Flame roguelike poker card game.
Tech stack: Flutter 3.x, Flame 1.18.0, Riverpod 2.x, Hive 2.x.
The game uses a hybrid Flame (canvas rendering) + Flutter (overlay UI) architecture.
GameManager extends ChangeNotifier and is the central coordinator.
All imports use package:balatro_blast/ prefix.
Card visuals are drawn with CustomPainter (no image assets).
```

## Adding a New Joker

**Prompt template:**
```
Add a new Joker to Balatro Blast called "[Name]" with the following effect: [effect description].
Files to modify:
1. lib/models/joker_card.dart — add new JokerType enum value
2. lib/engine/joker_engine.dart — add effect logic in appropriate method
3. lib/game/managers/shop_manager.dart — add to the joker pool
4. docs/04_JOKER_SYSTEM.md — document the new joker

Follow the existing pattern for [similar joker type] jokers.
The JokerEffectType should be [addMult/addChips/multiplyMult].
```

## Adding a New Blind Effect

**Prompt template:**
```
Add a Boss Blind effect called "[Name]" to Balatro Blast.
Effect: [description of what restriction it applies]
Modify:
1. lib/models/blind.dart — add the effect
2. lib/game/managers/round_manager.dart — apply the effect when boss blind is active
3. docs/01_GAME_RULES.md — document the effect
```

## Adding a New Screen

**Prompt template:**
```
Create a new screen called [ScreenName]Screen in lib/screens/[screen_name]_screen.dart.
It should be a Flutter StatelessWidget used as a Flame overlay.
It receives the game via context.read<GameManager>().
Add it to the overlays map in lib/screens/game_screen.dart.
The screen should have [describe UI elements].
Follow the dark neon theme from lib/utils/theme.dart.
```

## Modifying Scoring

**Prompt template:**
```
Modify the scoring system in Balatro Blast.
Change: [describe the change]
Files to modify:
- lib/engine/scoring_engine.dart (core calculation)
- lib/engine/poker_evaluator.dart (if hand detection changes)
- test/scoring_engine_test.dart (add/update tests)
Make sure all existing tests still pass.
```

## Adding Animations

**Prompt template:**
```
Add a [animation type] animation to [component] in Balatro Blast.
The component is in lib/game/components/[component_file].dart.
Use Flame's built-in effects: MoveEffect, ScaleEffect, OpacityEffect, etc.
The animation should trigger when [event].
Duration: [duration in seconds]
```

## Debugging Tips for AI

When asking for help debugging:

1. **Include the error message** in full
2. **Specify the Flame version** (1.18.0) as APIs differ significantly between versions
3. **Mention the TapCallbacks pattern** used (not HasTappables which is older)
4. **For overlay issues**, mention that overlays are registered in GameWidget's overlayBuilderMap

## Common Patterns Reference

### Reading game state in a Flutter overlay:
```dart
final gameManager = context.watch<GameManager>();
// or
ref.watch(gameManagerProvider);
```

### Triggering overlay from Flame component:
```dart
game.overlays.add('shop');
```

### Playing a card from GameManager:
```dart
gameManager.playHand();  // uses currently selected cards
```

### Adding a new Flame component:
```dart
// In BalatraBlastGame.onLoad():
await add(MyNewComponent(
  position: Vector2(x, y),
  size: Vector2(width, height),
));
```

## File Dependency Map

```
main.dart
    → game_screen.dart
        → balatro_blast_game.dart
            → game_manager.dart (via provider)
                → scoring_engine.dart
                    → poker_evaluator.dart
                    → joker_engine.dart
                → round_manager.dart
                → shop_manager.dart
```
