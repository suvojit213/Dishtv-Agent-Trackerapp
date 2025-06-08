import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:flutter/material.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/dashboard_screen.dart';
import 'package:dishtv_agent_tracker/presentation/features/add_entry/widgets/add_entry_screen.dart';
import 'package:dishtv_agent_tracker/presentation/features/monthly_performance/widgets/monthly_performance_screen.dart';
import 'package:dishtv_agent_tracker/presentation/features/all_reports/widgets/all_reports_screen.dart';

class AppRouter {
  // Route names
  static const String dashboardRoute = '/';
  static const String addEntryRoute = '/add-entry';
  static const String monthlyPerformanceRoute = '/monthly-performance';
  static const String allReportsRoute = '/all-reports';

  // Route generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardRoute:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );
      case addEntryRoute:
        final DailyEntry? entryToEdit = settings.arguments as DailyEntry?;
        return MaterialPageRoute(
          builder: (_) => AddEntryScreen(entryToEdit: entryToEdit),
        );
      case monthlyPerformanceRoute:
        final MonthlySummary summary = settings.arguments as MonthlySummary;
        return MaterialPageRoute(
          builder: (_) => MonthlyPerformanceScreen(summary: summary),
        );
      case allReportsRoute:
        return MaterialPageRoute(
          builder: (_) => const AllReportsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
