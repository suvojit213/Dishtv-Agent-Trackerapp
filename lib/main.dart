import 'package:dishtv_agent_tracker/data/datasources/goal_data_source.dart';
import 'package:dishtv_agent_tracker/data/repositories/goal_repository_impl.dart';
import 'package:dishtv_agent_tracker/domain/repositories/goal_repository.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/core/constants/app_enums.dart';
import 'package:dishtv_agent_tracker/data/datasources/local_data_source.dart';
import 'package:dishtv_agent_tracker/data/repositories/performance_repository_impl.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/app_theme.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_cubit.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_state.dart';
import 'package:dishtv_agent_tracker/presentation/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom ScrollBehavior for smoother scrolling
class SmoothScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final localDataSource = await LocalDataSource.init();
  final goalDataSource = GoalDataSource();
  
  final performanceRepository = PerformanceRepositoryImpl(localDataSource: localDataSource);
  final goalRepository = GoalRepositoryImpl(goalDataSource);

  final prefs = await SharedPreferences.getInstance();
  final hasShownOnboarding = prefs.getBool('hasShownOnboarding') ?? false;

  String initialRoute = AppRouter.dashboardRoute;
  if (!hasShownOnboarding) {
    initialRoute = AppRouter.onboardingTutorialRoute;
    await prefs.setBool('hasShownOnboarding', true);
  }
  
  runApp(MyApp(
    performanceRepository: performanceRepository,
    goalRepository: goalRepository,
    initialRoute: initialRoute,
  ));
}

class MyApp extends StatelessWidget {
  final PerformanceRepository performanceRepository;
  final GoalRepository goalRepository;
  final String initialRoute;
  
  const MyApp({
    Key? key,
    required this.performanceRepository,
    required this.goalRepository,
    required this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // एक से ज़्यादा Repository और BLoC प्रोवाइड करें
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PerformanceRepository>.value(value: performanceRepository),
        RepositoryProvider<GoalRepository>.value(value: goalRepository),
      ],
      child: BlocProvider(
        create: (context) => ThemeCubit(),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            ThemeData selectedTheme;
            ThemeMode themeMode;

            switch (themeState.themeMode) {
              case AppThemeMode.system:
                selectedTheme = AppTheme.lightTheme; // Default theme for system mode, actual theme determined by system brightness
                themeMode = ThemeMode.system;
                break;
              case AppThemeMode.light:
                selectedTheme = AppTheme.lightTheme;
                themeMode = ThemeMode.light;
                break;
              case AppThemeMode.dark:
                selectedTheme = AppTheme.darkTheme;
                themeMode = ThemeMode.dark;
                break;
              case AppThemeMode.blue:
                selectedTheme = AppTheme.blueTheme;
                themeMode = selectedTheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
                break;
              case AppThemeMode.green:
                selectedTheme = AppTheme.greenTheme;
                themeMode = selectedTheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
                break;
              case AppThemeMode.purple:
                selectedTheme = AppTheme.purpleTheme;
                themeMode = selectedTheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
                break;
              case AppThemeMode.red:
                selectedTheme = AppTheme.redTheme;
                themeMode = selectedTheme.brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
                break;
              case AppThemeMode.custom:
                selectedTheme = AppTheme.generateThemeFromColor(themeState.customColor, Brightness.light); // Assuming light for custom for now
                themeMode = ThemeMode.light;
                break;
              default: // Fallback for any unhandled AppThemeMode, though all are handled now
                selectedTheme = AppTheme.lightTheme;
                themeMode = ThemeMode.light;
                break;
            }

            return MaterialApp(
              title: AppConstants.appName,
              theme: selectedTheme,
              darkTheme: AppTheme.darkTheme, // Keep darkTheme for system dark mode fallback
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              scrollBehavior: SmoothScrollBehavior(),
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: initialRoute,
            );
          },
        ),
      ),
    );
  }
}
