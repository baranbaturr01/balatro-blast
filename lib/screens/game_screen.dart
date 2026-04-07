import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/models/game_state.dart';
import 'package:balatro_blast/models/hand_type.dart';
import 'package:balatro_blast/providers/game_provider.dart';
import 'package:balatro_blast/screens/main_menu_screen.dart';
import 'package:balatro_blast/screens/shop_screen.dart';
import 'package:balatro_blast/screens/blind_select_screen.dart';
import 'package:balatro_blast/screens/game_over_screen.dart';
import 'package:balatro_blast/screens/settings_screen.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late BalatraBlastGame _game;

  @override
  void initState() {
    super.initState();
    final gameManager = ref.read(gameManagerProvider);
    _game = BalatraBlastGame(gameManager: gameManager);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          GameWidget(
            game: _game,
            overlayBuilderMap: {
              kOverlayMainMenu: (context, game) => MainMenuScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlayShop: (context, game) => ShopScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlayBlindSelect: (context, game) => BlindSelectScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlayGameOver: (context, game) => GameOverScreen(
                    game: game as BalatraBlastGame,
                  ),
              kOverlaySettings: (context, game) => SettingsScreen(
                    game: game as BalatraBlastGame,
                  ),
            },
          ),
          // Action buttons overlay at the bottom.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _ActionButtonRow(game: _game),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action button row overlay
// ---------------------------------------------------------------------------

class _ActionButtonRow extends ConsumerWidget {
  const _ActionButtonRow({required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameManager = ref.watch(gameManagerProvider);
    final state = gameManager.state;

    // Only show action buttons during active gameplay.
    if (state.phase != GamePhase.playing) return const SizedBox.shrink();

    final selectedCount = state.selectedCards.length;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background.withValues(alpha: 0.0),
            AppColors.background.withValues(alpha: 0.85),
            AppColors.background.withValues(alpha: 0.97),
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Hand info bar: selected count + hand type preview.
          _HandInfoBar(
            selectedCount: selectedCount,
            previewHandType: state.previewHandType,
          ),
          const SizedBox(height: 10),
          // Main action buttons row.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Play Hand – primary action, larger.
              _NeonButton(
                label: '▶  Play Hand',
                countLabel: '${state.handsLeft}',
                countSuffix: state.handsLeft == 1 ? 'hand' : 'hands',
                enabled: state.canPlay,
                width: 192,
                height: 62,
                gradientColors: const [Color(0xFF1a6b00), Color(0xFF39FF14)],
                glowColor: const Color(0xFF39FF14),
                borderColor: const Color(0xFF39FF14),
                onPressed: () => game.playHand(),
              ),
              const SizedBox(width: 20),
              // Discard – secondary action, slightly smaller.
              _NeonButton(
                label: '✕  Discard',
                countLabel: '${state.discardsLeft}',
                countSuffix: state.discardsLeft == 1 ? 'discard' : 'discards',
                enabled: state.canDiscard,
                width: 168,
                height: 58,
                gradientColors: const [Color(0xFF6b1a00), Color(0xFFFF6B35)],
                glowColor: const Color(0xFFFF4444),
                borderColor: const Color(0xFFFF5500),
                onPressed: () => game.discardCards(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hand info bar
// ---------------------------------------------------------------------------

class _HandInfoBar extends StatelessWidget {
  const _HandInfoBar({
    required this.selectedCount,
    required this.previewHandType,
  });

  final int selectedCount;
  final HandType? previewHandType;

  @override
  Widget build(BuildContext context) {
    final handName = previewHandType != null
        ? HandTypeInfo.forType(previewHandType!).name.toUpperCase()
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Selected card count pill.
        _InfoPill(
          child: Text(
            '$selectedCount / $kMaxSelectedCards selected',
            style: TextStyle(
              color: selectedCount > 0
                  ? AppColors.neonYellow
                  : AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        if (handName != null) ...[
          const SizedBox(width: 10),
          // Hand type preview pill – neon cyan glow.
          _InfoPill(
            glowColor: AppColors.neonBlue,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome,
                    size: 12, color: AppColors.neonBlue),
                const SizedBox(width: 5),
                Text(
                  handName,
                  style: TextStyle(
                    color: AppColors.neonBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: AppColors.neonBlue.withValues(alpha: 0.85),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.child, this.glowColor});

  final Widget child;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    final glow = glowColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: glow != null
              ? glow.withValues(alpha: 0.55)
              : AppColors.mutedPurple.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: glow != null
            ? [
                BoxShadow(
                  color: glow.withValues(alpha: 0.22),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Neon press button (StatefulWidget for scale animation)
// ---------------------------------------------------------------------------

class _NeonButton extends StatefulWidget {
  const _NeonButton({
    required this.label,
    required this.countLabel,
    required this.countSuffix,
    required this.enabled,
    required this.width,
    required this.height,
    required this.gradientColors,
    required this.glowColor,
    required this.borderColor,
    required this.onPressed,
  });

  final String label;
  final String countLabel;
  final String countSuffix;
  final bool enabled;
  final double width;
  final double height;
  final List<Color> gradientColors;
  final Color glowColor;
  final Color borderColor;
  final VoidCallback onPressed;

  @override
  State<_NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<_NeonButton> {
  bool _pressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.enabled) setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (_pressed) setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (_pressed) setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    final scale = _pressed ? 0.94 : 1.0;

    // Disabled appearance
    final borderCol = enabled
        ? widget.borderColor.withValues(alpha: 0.9)
        : AppColors.mutedPurple.withValues(alpha: 0.3);
    final gradient = enabled
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.gradientColors[0].withValues(alpha: 0.85),
              widget.gradientColors[1].withValues(alpha: 0.55),
            ],
          )
        : LinearGradient(
            colors: [
              AppColors.surface.withValues(alpha: 0.45),
              AppColors.surface.withValues(alpha: 0.3),
            ],
          );
    final shadows = enabled && !_pressed
        ? [
            BoxShadow(
              color: widget.glowColor.withValues(alpha: 0.45),
              blurRadius: 18,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: widget.glowColor.withValues(alpha: 0.20),
              blurRadius: 36,
              spreadRadius: 4,
            ),
          ]
        : <BoxShadow>[];

    return GestureDetector(
      onTap: enabled ? widget.onPressed : null,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderCol, width: 1.8),
            boxShadow: shadows,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main label
              Text(
                widget.label,
                style: TextStyle(
                  color: enabled
                      ? Colors.white.withValues(alpha: 0.95)
                      : AppColors.textMuted.withValues(alpha: 0.5),
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                  shadows: enabled
                      ? [
                          Shadow(
                            color:
                                widget.glowColor.withValues(alpha: 0.7),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 3),
              // Count sub-label
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.countLabel,
                      style: TextStyle(
                        color: enabled
                            ? widget.glowColor.withValues(alpha: 0.95)
                            : AppColors.textMuted.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                        shadows: enabled
                            ? [
                                Shadow(
                                  color: widget.glowColor
                                      .withValues(alpha: 0.6),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                    TextSpan(
                      text: ' ${widget.countSuffix}',
                      style: TextStyle(
                        color: enabled
                            ? Colors.white.withValues(alpha: 0.55)
                            : AppColors.textMuted.withValues(alpha: 0.3),
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
