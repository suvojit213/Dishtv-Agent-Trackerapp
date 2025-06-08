import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_event.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/goals_state.dart';

class MonthlyGoalsSection extends StatelessWidget {
  final MonthlySummary summary;
  const MonthlyGoalsSection({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final hoursProgress = (summary.totalLoginHours / state.targetHours).clamp(0.0, 1.0);
        final callsProgress = (summary.totalCalls / state.targetCalls).clamp(0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Monthly Goals', style: theme.textTheme.titleLarge),
                  TextButton.icon(
                    onPressed: () => _showEditGoalsDialog(context, state.targetHours, state.targetCalls),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                  )
                ],
              ),
              const SizedBox(height: 12),
              CustomCard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProgressIndicator(
                      context,
                      percent: hoursProgress,
                      title: 'Login Hours',
                      current: summary.totalLoginHours.toStringAsFixed(1),
                      target: '${state.targetHours}h',
                      color: theme.colorScheme.primary,
                    ),
                    _buildProgressIndicator(
                      context,
                      percent: callsProgress,
                      title: 'Calls',
                      current: summary.totalCalls.toString(),
                      target: state.targetCalls.toString(),
                      color: Colors.green,
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator(BuildContext context, {
    required double percent,
    required String title,
    required String current,
    required String target,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 12.0,
      percent: percent,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(current, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Text('/ $target', style: theme.textTheme.bodySmall),
        ],
      ),
      footer: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(title, style: theme.textTheme.titleMedium),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: color.withOpacity(0.2),
      progressColor: color,
      animation: true,
      animationDuration: 800,
    );
  }

  void _showEditGoalsDialog(BuildContext context, int currentHours, int currentCalls) {
    final hoursController = TextEditingController(text: currentHours.toString());
    final callsController = TextEditingController(text: currentCalls.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set Monthly Goals'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: hoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Login Hours',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: callsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Call Count',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newHours = int.tryParse(hoursController.text) ?? currentHours;
                final newCalls = int.tryParse(callsController.text) ?? currentCalls;
                context.read<GoalsBloc>().add(SaveGoals(hours: newHours, calls: newCalls));
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
