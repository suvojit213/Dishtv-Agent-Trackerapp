import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/domain/repositories/goal_repository.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/empty_state_widget.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_event.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/dashboard_shimmer.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/monthly_goals_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/csat_performance_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/cq_performance_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/animated_theme_switcher.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_event.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_state.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/daily_entries_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/summary_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/salary_section.dart';
import 'package:dishtv_agent_tracker/presentation/routes/app_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(
            repository: context.read<PerformanceRepository>(),
          )..add(LoadDashboardData(month: DateTime.now().month, year: DateTime.now().year)),
        ),
        BlocProvider(
          create: (context) => GoalsBloc(
            goalRepository: context.read<GoalRepository>(),
          )..add(LoadGoals()),
        ),
      ],
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  void _navigateToMonthlyPerformance(BuildContext context) {
    final dashboardState = context.read<DashboardBloc>().state;
    if (dashboardState.status == DashboardStatus.loaded && dashboardState.monthlySummary != null) {
      Navigator.pushNamed(
        context,
        AppRouter.monthlyPerformanceRoute,
        arguments: dashboardState.monthlySummary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        leading: IconButton(
          icon: const Icon(Icons.info_outline_rounded),
          onPressed: () => _showAboutDialog(context),
        ),
        actions: [
          const AnimatedThemeSwitcher(),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.pushNamed(context, AppRouter.faqRoute),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DashboardBloc>().add(RefreshDashboard());
              context.read<GoalsBloc>().add(LoadGoals());
            },
          ),
        ],
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Right to Left Swipe (अगली स्क्रीन पर जाने के लिए)
          if ((details.primaryVelocity ?? 0) < -200) { // स्वाइप की गति को थोड़ा बढ़ा दिया है
            _navigateToMonthlyPerformance(context);
          }
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.initial || state.status == DashboardStatus.loading) {
              return const DashboardShimmer();
            }

            if (state.status == DashboardStatus.error) {
              return EmptyStateWidget(
                message: state.errorMessage ?? 'An unknown error occurred.',
                icon: Icons.cloud_off_rounded,
                onRetry: () => context.read<DashboardBloc>().add(RefreshDashboard()),
              );
            }
            
            if (state.monthlySummary == null || state.monthlySummary!.entries.isEmpty) {
              return EmptyStateWidget(
                message: 'No entries found for this month.\nTap the + button to add your first entry!',
                onRetry: () => context.read<DashboardBloc>().add(RefreshDashboard()),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(RefreshDashboard());
                context.read<GoalsBloc>().add(LoadGoals());
              },
              color: AppColors.dishTvOrange,
              child: ListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          state.monthlySummary!.formattedMonthYear,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              onPressed: () {
                                final currentDate = DateTime(state.currentYear, state.currentMonth);
                                final previousMonth = DateTime(currentDate.year, currentDate.month - 1);
                                context.read<DashboardBloc>().add(
                                  LoadDashboardData(month: previousMonth.month, year: previousMonth.year),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                final currentDate = DateTime(state.currentYear, state.currentMonth);
                                final nextMonth = DateTime(currentDate.year, currentDate.month + 1);
                                context.read<DashboardBloc>().add(
                                  LoadDashboardData(month: nextMonth.month, year: nextMonth.year),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  MonthlyGoalsSection(summary: state.monthlySummary!),
                  const SizedBox(height: 24),
                  CSATPerformanceSection(csatSummary: state.csatSummary), // Pass CSAT data directly from state
                  const SizedBox(height: 24),
                  CQPerformanceSection(cqSummary: state.cqSummary), // Pass CQ data directly from state
                  const SizedBox(height: 24),
                  SummarySection(summary: state.monthlySummary!),
                  const SizedBox(height: 24),
                  SalarySection(summary: state.monthlySummary!),
                  const SizedBox(height: 24),
                  DailyEntriesSection(entries: state.monthlySummary!.entries),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouter.addEntryRoute, arguments: null)
              .then((value) {
            if (value == true) {
              context.read<DashboardBloc>().add(RefreshDashboard());
            }
          });
        },
        backgroundColor: AppColors.dishTvOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              _navigateToMonthlyPerformance(context);
              break;
            case 2:
              Navigator.pushNamed(context, AppRouter.allReportsRoute);
              break;
          }
        },
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Image.asset('assets/icon/app_icon.png', width: 48, height: 48),
      applicationLegalese: '© 2025 Suvojeet Sengupta',
      children: <Widget>[
        const SizedBox(height: 24),
        const Text(
          'Developer - Suvojeet Sengupta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'Credits -Thanks to Sudhanshu & many others who contributed and helped me to complete this app',
           style: TextStyle(fontStyle: FontStyle.italic),
        ),
        const Divider(height: 32),
        const Text(
          '"I Developed This App for Easy to Track DishTV WFH Agent Perfomence Yourself, Thanks For using This Application"',
           style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}


