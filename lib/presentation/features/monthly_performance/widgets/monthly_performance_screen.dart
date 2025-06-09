import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/daily_entries_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/salary_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/summary_section.dart';
import 'package:dishtv_agent_tracker/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';

class MonthlyPerformanceScreen extends StatelessWidget {
  final MonthlySummary summary;

  const MonthlyPerformanceScreen({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: summary.formattedMonthYear),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Right to Left Swipe (अगली स्क्रीन पर जाने के लिए)
          if ((details.primaryVelocity ?? 0) < -200) {
            Navigator.pushReplacementNamed(context, AppRouter.allReportsRoute);
          }
          // Left to Right Swipe (पिछली स्क्रीन पर जाने के लिए)
          else if ((details.primaryVelocity ?? 0) > 200) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              SummarySection(summary: summary),
              const SizedBox(height: 24),
              SalarySection(summary: summary),
              const SizedBox(height: 24),
              DailyEntriesSection(entries: summary.entries),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
