import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themePrefKey = 'theme_mode';
  static const String _customColorPrefKey = 'custom_color';

  ThemeCubit() : super(const ThemeState(themeMode: AppThemeMode.system)) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themePrefKey) ?? AppThemeMode.system.index;
    final customColorValue = prefs.getInt(_customColorPrefKey);

    AppThemeMode loadedThemeMode;
    if (themeIndex < AppThemeMode.values.length) {
      loadedThemeMode = AppThemeMode.values[themeIndex];
    } else {
      loadedThemeMode = AppThemeMode.system; // Fallback to system if index is out of bounds
    }

    Color loadedCustomColor = Colors.deepOrange; // Default if not found
    if (customColorValue != null) {
      loadedCustomColor = Color(customColorValue);
    }

    emit(state.copyWith(themeMode: loadedThemeMode, customColor: loadedCustomColor));
  }

  void setTheme(AppThemeMode newThemeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themePrefKey, newThemeMode.index);
    emit(state.copyWith(themeMode: newThemeMode));
  }

  void setCustomColor(Color newColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_customColorPrefKey, newColor.value);
    emit(state.copyWith(themeMode: AppThemeMode.custom, customColor: newColor));
  }
}