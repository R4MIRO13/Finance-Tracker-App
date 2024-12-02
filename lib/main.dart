import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
          headlineSmall: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
          headlineSmall: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        onThemeChanged: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    );
  }
}
