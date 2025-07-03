import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/salary_section.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/summary_section.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_divider.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/dashboard_card.dart';
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
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';

import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_event.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_state.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/widgets/daily_entries_section.dart';
import 'package:dishtv_agent_tracker/presentation/routes/app_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:dishtv_agent_tracker/presentation/common/widgets/performance_share_card.dart';

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

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final ScreenshotController screenshotController = ScreenshotController();

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

  Future<void> _sharePerformance(BuildContext context, MonthlySummary summary) async {
    // Show a loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing performance image...')),
    );

    try {
      // Capture the widget as an image
      final imageFile = await screenshotController.captureFromWidget(
        InheritedTheme.captureAll(
          context,
          PerformanceShareCard(summary: summary),
        ),
        delay: const Duration(milliseconds: 100),
        pixelRatio: 2.0, // Adjust pixel ratio for better quality
      );

      if (imageFile != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/performance_summary.png';
        final file = File(imagePath);
        await file.writeAsBytes(imageFile);

        // Share the image
        await Share.shareXFiles([XFile(file.path)], text: 'Check out my DishTV Agent performance!');

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Performance image shared!')),
        );
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing performance: $e')),
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
          onPressed: () => Navigator.pushNamed(context, AppRouter.appInfoRoute),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => Navigator.pushNamed(context, AppRouter.onboardingTutorialRoute),
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () => Navigator.pushNamed(context, AppRouter.themeSelectionRoute),
          ),
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state.status == DashboardStatus.loaded && state.monthlySummary != null) {
                return IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _sharePerformance(context, state.monthlySummary!),
                );
              }
              return const SizedBox.shrink();
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
        onPressed: () async {
          final result = await Navigator.pushNamed(context, AppRouter.addEntryRoute, arguments: null);
          if (result == true) {
            context.read<DashboardBloc>().add(RefreshDashboard());
            context.read<GoalsBloc>().add(LoadGoals());
          }
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
            case 3:
              Navigator.pushNamed(context, AppRouter.settingsRoute);
              break;
          }
        },
      ),
    );
  }
}


