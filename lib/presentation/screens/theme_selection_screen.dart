import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_cubit.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theme'),
      ),
      body: ListView(
        children: AppThemeMode.values.map((themeMode) {
          return RadioListTile<AppThemeMode>(
            title: Text(themeMode.toString().split('.').last.toUpperCase()),
            value: themeMode,
            groupValue: context.watch<ThemeCubit>().state,
            onChanged: (AppThemeMode? newValue) {
              if (newValue != null) {
                context.read<ThemeCubit>().setTheme(newValue);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
