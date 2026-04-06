# Balatro Blast — UI Design

## Design Language

Balatro Blast uses a **dark neon retro** aesthetic:
- Deep dark backgrounds (near-black purple)
- Bright neon accent colors (green, yellow, magenta)
- Glowing text and borders
- Clean, readable card faces

## Color Palette

| Name | Hex | Usage |
|------|-----|-------|
| Background | `#1a0a2e` | Game background |
| Surface | `#2d1b4e` | Card slots, panels |
| Neon Green | `#39ff14` | Highlights, selected state, buttons |
| Neon Yellow | `#ffff00` | Score display, money |
| Neon Magenta | `#ff00ff` | Mult values |
| Neon Blue | `#00cfff` | Chips values |
| Card White | `#f5f5f5` | Card face background |
| Card Red | `#cc0000` | Hearts and Diamonds |
| Card Black | `#111111` | Clubs and Spades |
| Muted Purple | `#6b4fa0` | Disabled states, deck back |

## Typography

Using Google Fonts — **Press Start 2P** for headers, **Roboto Mono** for body/numbers.

| Style | Font | Size | Color |
|-------|------|------|-------|
| Title | Press Start 2P | 32sp | Neon Green |
| Heading | Press Start 2P | 18sp | Neon Yellow |
| Score | Roboto Mono | 28sp Bold | Neon Yellow |
| Body | Roboto Mono | 14sp | White |
| Card Rank | Roboto Mono | 18sp Bold | Suit color |
| Button | Press Start 2P | 12sp | Black on Neon Green |

## Screen Layouts

### Game Screen (Flame Canvas)

```
┌─────────────────────────────────────────┐
│  BLIND: Small  TARGET: 300  SCORE: 0    │ ← ScoreDisplayComponent
│  Hands: 4  Discards: 3  $: 4           │
├─────────────────────────────────────────┤
│                                         │
│  [J1] [J2] [J3] [J4] [J5]             │ ← JokerSlotComponents
│                                         │
│                                         │
│          (playing field)                │
│                                         │
│                                         │
│  ╔═════════════════════════════════╗    │
│  ║  [Card][Card][Card][Card][Card] ║    │ ← HandComponent
│  ║  [Card][Card][Card]             ║    │
│  ╚═════════════════════════════════╝    │
│                                         │
│  [▶ Play Hand]    [✕ Discard]  [🂠 52]  │ ← Action buttons + DeckComponent
└─────────────────────────────────────────┘
```

### Main Menu Screen (Flutter overlay)

```
┌─────────────────────────────────────────┐
│                                         │
│         ╔═══════════════╗               │
│         ║ BALATRO BLAST ║               │
│         ╚═══════════════╝               │
│                                         │
│              [▶ PLAY]                   │
│              [⚙ SETTINGS]               │
│              [? HOW TO PLAY]            │
│                                         │
└─────────────────────────────────────────┘
```

### Shop Screen (Flutter overlay)

See docs/06_SHOP_SYSTEM.md for shop layout.

### Blind Select Screen (Flutter overlay)

```
┌─────────────────────────────────────────┐
│  ANTE 1                                 │
│                                         │
│  ┌──────────┐  ┌──────────┐  ┌───────┐ │
│  │ SMALL    │  │  BIG     │  │  BOSS │ │
│  │ BLIND    │  │  BLIND   │  │ BLIND │ │
│  │          │  │          │  │       │ │
│  │ 300 pts  │  │ 450 pts  │  │600pts │ │
│  │          │  │          │  │Effect │ │
│  │ [SELECT] │  │ [SELECT] │  │[SEL.] │ │
│  └──────────┘  └──────────┘  └───────┘ │
└─────────────────────────────────────────┘
```

## Component Design

### Playing Card

```
┌────────┐
│ A  ♥   │  ← rank + suit (top-left)
│        │
│   ♥    │  ← large suit symbol (center)
│        │
│   ♥  A │  ← suit + rank (bottom-right, flipped)
└────────┘
```

Size: 60×90 pixels on game canvas
Selected: lifted 16px upward, neon green border glow

### Joker Card

```
┌────────┐
│ JOKER  │  ← "JOKER" label
│ NAME   │
│        │
│ effect │
│ text   │
└────────┘
```

Size: 60×90 pixels, neon border, dark background

### Score Display

```
╔═══════════════════════════════════╗
║  BLIND: Small     TARGET: 300     ║
║  SCORE: 125       HANDS: 3 | D: 2 ║
╚═══════════════════════════════════╝
```

## Button Style

- Background: Neon green (`#39ff14`)
- Text: Black, Press Start 2P font, 12sp
- Border radius: 8px
- Padding: 12px × 24px
- Disabled state: Muted grey

## Glow Effect Implementation

```dart
final glowPaint = Paint()
  ..color = AppColors.neonGreen
  ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
canvas.drawRRect(cardRect, glowPaint);
```
