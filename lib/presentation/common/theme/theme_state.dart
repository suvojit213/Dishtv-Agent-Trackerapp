import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';

class ThemeState extends Equatable {
  final AppThemeMode themeMode;
  final Color customColor;

  const ThemeState({
    required this.themeMode,
    this.customColor = Colors.deepOrange, // Default custom color
  });

  ThemeState copyWith({
    AppThemeMode? themeMode,
    Color? customColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      customColor: customColor ?? this.customColor,
    );
  }

  @override
  List<Object?> get props => [themeMode, customColor];
}
