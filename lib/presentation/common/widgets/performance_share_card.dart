import 'package:flutter/material.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';
import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:intl/intl.dart';

class PerformanceShareCard extends StatelessWidget {
  final MonthlySummary summary;

  const PerformanceShareCard({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    final theme = Theme.of(context);

    return Material(
      color: theme.scaffoldBackgroundColor, // Use scaffold background for consistent look
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor, // Use card color for the background
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Branding
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon/app_icon.png', width: 40, height: 40),
                const SizedBox(width: 10),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.dishTvOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Performance Summary
            Text(
              'Monthly Performance Summary',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              summary.formattedMonthYear,
              style: theme.textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),

            _buildInfoRow(
              context,
              Icons.timer,
              'Total Login Hours',
              '${formatter.format(summary.totalLoginHours)} hrs',
            ),
            _buildInfoRow(
              context,
              Icons.call,
              'Total Calls',
              summary.totalCalls.toString(),
            ),
            _buildInfoRow(
              context,
              Icons.money,
              'Estimated Net Salary',
              '₹${formatter.format(summary.netSalary)}',
            ),
            const SizedBox(height: 20),

            // Motivational Message
            Text(
              'Keep up the great work!',
              style: theme.textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.accentGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.dishTvOrange),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: theme.textTheme.bodyLarge,
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
