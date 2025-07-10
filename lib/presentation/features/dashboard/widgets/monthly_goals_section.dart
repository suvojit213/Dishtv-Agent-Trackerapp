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
                child: Column(
                  children: [
                    Row(
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
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: theme.colorScheme.onSurface.withOpacity(0.1)),
                    const SizedBox(height: 16),
                    _buildGoalDetails(
                      context,
                      'Remaining Hours to Goal:',
                      '${(state.targetHours - summary.totalLoginHours).clamp(0.0, double.infinity).toStringAsFixed(1)}h',
                    ),
                    const SizedBox(height: 8),
                    _buildGoalDetails(
                      context,
                      'Remaining Calls to Goal:',
                      '${(state.targetCalls - summary.totalCalls).clamp(0, double.infinity).toInt()}',
                    ),
                    const SizedBox(height: 8),
                    _buildGoalDetails(
                      context,
                      'Daily Avg. Hours Needed:',
                      '${((state.targetHours - summary.totalLoginHours).clamp(0.0, double.infinity) / (DateTime(summary.year, summary.month + 1, 0).day - DateTime.now().day)).toStringAsFixed(1)}h',
                    ),
                    const SizedBox(height: 8),
                    _buildGoalDetails(
                      context,
                      'Daily Avg. Calls Needed:',
                      '${((state.targetCalls - summary.totalCalls).clamp(0, double.infinity).toInt() / (DateTime(summary.year, summary.month + 1, 0).day - DateTime.now().day)).toStringAsFixed(0)}',
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

  Widget _buildGoalDetails(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyLarge),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _showEditGoalsDialog(BuildContext context, int currentHours, int currentCalls) {
    final theme = Theme.of(context);
    final hoursController = TextEditingController(text: currentHours.toString());
    final callsController = TextEditingController(text: currentCalls.toString());
    final _formKey = GlobalKey<FormState>(); // Add a form key

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set Monthly Goals'),
          content: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: hoursController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Login Hours (Max 570)',
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.enabledBorder,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    filled: theme.inputDecorationTheme.filled,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter target hours';
                    }
                    final hours = int.tryParse(value);
                    if (hours == null) {
                      return 'Please enter a valid number';
                    }
                    if (hours > 570) {
                      return 'Hours cannot exceed 570';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: callsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Call Count',
                    border: theme.inputDecorationTheme.border,
                    enabledBorder: theme.inputDecorationTheme.enabledBorder,
                    focusedBorder: theme.inputDecorationTheme.focusedBorder,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    filled: theme.inputDecorationTheme.filled,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) { // Validate the form
                  final newHours = int.tryParse(hoursController.text) ?? currentHours;
                  final newCalls = int.tryParse(callsController.text) ?? currentCalls;
                  context.read<GoalsBloc>().add(SaveGoals(hours: newHours, calls: newCalls));
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
