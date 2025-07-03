import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_divider.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/dashboard_card.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/daily_entries_section.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    DashboardCard(
                      title: 'Total Calls',
                      value: summary.totalCalls.toString(),
                      icon: Icons.call,
                      iconColor: Theme.of(context).colorScheme.primary,
                    ),
                    DashboardCard(
                      title: 'Avg. Login Hours',
                      value: summary.averageDailyLoginHours.toStringAsFixed(2),
                      icon: Icons.timer,
                      iconColor: Theme.of(context).colorScheme.secondary,
                    ),
                    DashboardCard(
                      title: 'CSAT Score',
                      value: '${summary.csatSummary?.monthlyCSATPercentage.toStringAsFixed(2) ?? 'N/A'}%',
                      icon: Icons.sentiment_satisfied_alt,
                      iconColor: Theme.of(context).colorScheme.primary,
                    ),
                    DashboardCard(
                      title: 'CQ Score',
                      value: '${summary.cqSummary?.monthlyAverageCQ.toStringAsFixed(2) ?? 'N/A'}%',
                      icon: Icons.assessment,
                      iconColor: Theme.of(context).colorScheme.secondary,
                    ),
                    DashboardCard(
                      title: 'Total Salary',
                      value: '₹${summary.totalSalary.toStringAsFixed(2)}',
                      icon: Icons.currency_rupee,
                      iconColor: Theme.of(context).colorScheme.primary,
                    ),
                    DashboardCard(
                      title: 'Avg. Salary',
                      value: '₹${summary.averageSalary.toStringAsFixed(2)}',
                      icon: Icons.money,
                      iconColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ),
              const CustomDivider(),
              DailyEntriesSection(entries: summary.entries),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

