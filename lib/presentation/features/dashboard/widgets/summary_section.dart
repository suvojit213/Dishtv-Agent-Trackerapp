import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';
import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/features/dashboard/bloc/dashboard_state.dart';

class SummarySection extends StatelessWidget {
  final MonthlySummary summary;
  
  const SummarySection({
    Key? key,
    required this.summary,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Monthly Summary',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Total Login Hours',
                '${formatter.format(summary.totalLoginHours)} hrs',
                Icons.access_time,
              ),
            ),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Total Calls',
                '${summary.totalCalls}',
                Icons.call,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                context,
                'Avg. Daily Hours',
                '${formatter.format(summary.averageDailyLoginHours)} hrs',
                Icons.av_timer,
              ),
            ),
            Expanded(
              child: _buildSummaryCard(
                context,
                'Avg. Daily Calls',
                '${formatter.format(summary.averageDailyCalls)}',
                Icons.call_made,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

