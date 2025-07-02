import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_cubit.dart';

class AnimatedThemeSwitcher extends StatelessWidget {
  const AnimatedThemeSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppThemeMode>(
      builder: (context, appThemeMode) {
        return IconButton(
          splashRadius: 20.0,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: appThemeMode == AppThemeMode.dark
                ? const Icon(Icons.nightlight_round, key: ValueKey('moon'))
                : const Icon(Icons.wb_sunny_rounded, key: ValueKey('sun')),
          ),
          onPressed: () {
            if (appThemeMode == AppThemeMode.dark) {
              context.read<ThemeCubit>().setTheme(AppThemeMode.light);
            } else {
              context.read<ThemeCubit>().setTheme(AppThemeMode.dark);
            }
          },
        );
      },
    );
  }
}
