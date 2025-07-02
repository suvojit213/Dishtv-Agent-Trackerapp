import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_cubit.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_state.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Theme'),
      ),
      body: ListView(
        children: [
          ...AppThemeMode.values.where((mode) => mode != AppThemeMode.amber && mode != AppThemeMode.teal && mode != AppThemeMode.custom).map((themeMode) {
            return RadioListTile<AppThemeMode>(
              title: Text(themeMode.toString().split('.').last.toUpperCase()),
              value: themeMode,
              groupValue: context.watch<ThemeCubit>().state.themeMode,
              onChanged: (AppThemeMode? newValue) {
                if (newValue != null) {
                  context.read<ThemeCubit>().setTheme(newValue);
                }
              },
            );
          }).toList(),
          ListTile(
            title: const Text('CUSTOM COLOR'),
            trailing: ColorIndicator(
              width: 44,
              height: 44,
              borderRadius: 4,
              color: context.watch<ThemeCubit>().state.customColor,
              onSelectFocus: false,
              onSelect: () async {
                final newColor = await showColorPicker(context, context.read<ThemeCubit>().state.customColor);
                if (newColor != null) {
                  context.read<ThemeCubit>().setCustomColor(newColor);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Color?> showColorPicker(BuildContext context, Color currentColor) async {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        Color? selectedColor = currentColor;
        return AlertDialog(
          title: const Text('Select Custom Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: currentColor,
              onColorChanged: (color) {
                selectedColor = color;
              },
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              wheelSubheading: Text(
                'Selected color and its shades',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              showColorName: true,
              showColorCode: true,
              copyPasteBehavior: const ColorPickerCopyPasteBehavior(longPressMenu: true),
              materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
              colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
              colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: false,
                ColorPickerType.custom: true,
                ColorPickerType.wheel: true,
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(selectedColor);
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }
}
