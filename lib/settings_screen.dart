import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const SettingsScreen({super.key, required this.onThemeChanged, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: onThemeChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
