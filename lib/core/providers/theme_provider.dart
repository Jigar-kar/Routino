import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark, colorful, minimalist, glass, custom }

class ThemeNotifier extends Notifier<ThemeType> {
  late SharedPreferences _prefs;
  Color _primaryColor = Colors.blue;
  Color _secondaryColor = Colors.blueAccent;
  Color _backgroundColor = Colors.white;
  Color _surfaceColor = Colors.white;
  Color _textColor = Colors.black;

  @override
  ThemeType build() {
    _loadFromPrefs();
    return ThemeType.light;
  }

  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final themeString = _prefs.getString('theme_type') ?? 'light';
    state = ThemeType.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => ThemeType.light,
    );

    _primaryColor = Color(_prefs.getInt('custom_primary') ?? Colors.blue.value);
    _secondaryColor = Color(
      _prefs.getInt('custom_secondary') ?? Colors.blueAccent.value,
    );
    _backgroundColor = Color(
      _prefs.getInt('custom_background') ?? Colors.white.value,
    );
    _surfaceColor = Color(
      _prefs.getInt('custom_surface') ?? Colors.white.value,
    );
    _textColor = Color(_prefs.getInt('custom_text') ?? Colors.black.value);
  }

  Future<void> setTheme(ThemeType theme) async {
    state = theme;
    await _prefs.setString('theme_type', theme.name);
  }

  Future<void> setCustomColors({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? text,
  }) async {
    if (primary != null) {
      _primaryColor = primary;
      await _prefs.setInt('custom_primary', primary.value);
    }
    if (secondary != null) {
      _secondaryColor = secondary;
      await _prefs.setInt('custom_secondary', secondary.value);
    }
    if (background != null) {
      _backgroundColor = background;
      await _prefs.setInt('custom_background', background.value);
    }
    if (surface != null) {
      _surfaceColor = surface;
      await _prefs.setInt('custom_surface', surface.value);
    }
    if (text != null) {
      _textColor = text;
      await _prefs.setInt('custom_text', text.value);
    }
  }

  Color get primaryColor => _primaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get backgroundColor => _backgroundColor;
  Color get surfaceColor => _surfaceColor;
  Color get textColor => _textColor;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeType>(() {
  return ThemeNotifier();
});
