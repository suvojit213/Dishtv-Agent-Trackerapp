import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// यह क्यूबिट ऐप की थीम (लाइट/डार्क) को मैनेज करेगा
class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themePrefKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.dark) {
    _loadTheme();
  }

  // ऐप शुरू होने पर सेव की गई थीम को लोड करें
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePrefKey) ?? ThemeMode.dark.index;
    emit(ThemeMode.values[themeIndex]);
  }

  // थीम को टॉगल करें (डार्क से लाइट और लाइट से डार्क)
  void toggleTheme() async {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, newTheme.index);
    emit(newTheme);
  }
}
