import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';

// यह क्यूबिट ऐप की थीम (लाइट/डार्क) को मैनेज करेगा
class ThemeCubit extends Cubit<AppThemeMode> {
  static const String _themePrefKey = 'theme_mode';

  ThemeCubit() : super(AppThemeMode.system) {
    _loadTheme();
  }

  // ऐप शुरू होने पर सेव की गई थीम को लोड करें
  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePrefKey) ?? AppThemeMode.system.index;
    if (themeIndex < AppThemeMode.values.length) {
      emit(AppThemeMode.values[themeIndex]);
    } else {
      emit(AppThemeMode.system); // Fallback to system if index is out of bounds
    }
  }

  // थीम को बदलें
  void setTheme(AppThemeMode newThemeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, newThemeMode.index);
    emit(newThemeMode);
  }
}
