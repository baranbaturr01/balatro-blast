import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:balatro_blast/game/balatro_blast_game.dart';
import 'package:balatro_blast/providers/settings_provider.dart';
import 'package:balatro_blast/utils/constants.dart';
import 'package:balatro_blast/utils/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key, required this.game});

  final BalatraBlastGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('SETTINGS',
            style: TextStyle(color: AppColors.neonGreen, fontSize: 14)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => game.overlays.remove(kOverlaySettings),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsTile(
            title: 'Sound Effects',
            subtitle: 'Card sounds, scoring jingles',
            value: settings.soundEnabled,
            onChanged: (v) => notifier.setSoundEnabled(v),
          ),
          _SettingsTile(
            title: 'Music',
            subtitle: 'Background music',
            value: settings.musicEnabled,
            onChanged: (v) => notifier.setMusicEnabled(v),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => _confirmReset(context, ref),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.cardRed),
              foregroundColor: AppColors.cardRed,
            ),
            child: const Text('Reset All Progress'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Reset Progress?',
            style: TextStyle(color: AppColors.cardRed)),
        content: const Text(
          'This will delete all saved data and statistics.',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: implement full reset
            },
            child: const Text('Reset',
                style: TextStyle(color: AppColors.cardRed)),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      subtitle: Text(subtitle,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.neonGreen,
      ),
    );
  }
}
