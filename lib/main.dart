import 'package:dishtv_agent_tracker/data/datasources/goal_data_source.dart';
import 'package:dishtv_agent_tracker/data/repositories/goal_repository_impl.dart';
import 'package:dishtv_agent_tracker/domain/repositories/goal_repository.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/data/datasources/local_data_source.dart';
import 'package:dishtv_agent_tracker/data/repositories/performance_repository_impl.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/app_theme.dart';
import 'package:dishtv_agent_tracker/presentation/common/theme/theme_cubit.dart';
import 'package:dishtv_agent_tracker/presentation/routes/app_router.dart';

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
  
  runApp(MyApp(
    performanceRepository: performanceRepository,
    goalRepository: goalRepository,
  ));
}

class MyApp extends StatelessWidget {
  final PerformanceRepository performanceRepository;
  final GoalRepository goalRepository;
  
  const MyApp({
    Key? key,
    required this.performanceRepository,
    required this.goalRepository,
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
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: AppConstants.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              scrollBehavior: SmoothScrollBehavior(),
              onGenerateRoute: AppRouter.onGenerateRoute,
              initialRoute: AppRouter.dashboardRoute,
            );
          },
        ),
      ),
    );
  }
}
