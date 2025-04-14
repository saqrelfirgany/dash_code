import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentThemeMode = AdaptiveTheme.of(context).mode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Appearance', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 16),
          _ThemeSelectionTile(
            title: 'System Default',
            themeMode: AdaptiveThemeMode.system,
            currentMode: currentThemeMode,
          ),
          _ThemeSelectionTile(
            title: 'Light Theme',
            themeMode: AdaptiveThemeMode.light,
            currentMode: currentThemeMode,
          ),
          _ThemeSelectionTile(
            title: 'Dark Theme',
            themeMode: AdaptiveThemeMode.dark,
            currentMode: currentThemeMode,
          ),
        ],
      ),
    );
  }
}

class _ThemeSelectionTile extends StatelessWidget {
  final String title;
  final AdaptiveThemeMode themeMode;
  final AdaptiveThemeMode currentMode;

  const _ThemeSelectionTile({
    required this.title,
    required this.themeMode,
    required this.currentMode,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<AdaptiveThemeMode>(
      title: Text(title),
      value: themeMode,
      groupValue: currentMode,
      onChanged: (mode) {
        if (mode != null) {
          AdaptiveTheme.of(context).setThemeMode(mode);
        }
      },
    );
  }
}