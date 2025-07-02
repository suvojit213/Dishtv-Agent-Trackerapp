import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';
import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';

class SalarySection extends StatelessWidget {
  final MonthlySummary summary;
  
  const SalarySection({
    Key? key,
    required this.summary,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00');
    final theme = Theme.of(context); // Get the current theme

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Salary',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: [
                _buildSalaryRow(
                  context,
                  'Base Salary (₹${AppConstants.baseRatePerCall} per call)',
                  '₹${formatter.format(summary.baseSalary)}',
                ),
                const Divider(), // Uses theme's divider color
                _buildSalaryRow(
                  context,
                  'Bonus (${summary.isBonusAchieved ? 'Achieved' : 'Not Achieved'})',
                  '₹${formatter.format(summary.bonusAmount)}',
                  highlight: summary.isBonusAchieved,
                ),
                const SizedBox(height: 8),
                // This is the fixed container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // Use a theme-aware color instead of a hardcoded one
                    color: theme.colorScheme.surfaceVariant, 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Bonus Criteria: ${AppConstants.bonusCallTarget}+ calls & ${AppConstants.bonusHourTarget}+ hours',
                    // Use a theme-aware text style
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                _buildSalaryRow(
                  context,
                  'CSAT Bonus',
                  '₹${formatter.format(summary.csatBonus)}',
                  highlight: summary.csatBonus > 0,
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'CSAT Bonus Criteria: ${AppConstants.csatBonusPercentage}% CSAT & ${AppConstants.csatBonusCallTarget}+ calls',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                _buildSalaryRow(
                  context,
                  'Gross Salary',
                  '₹${formatter.format(summary.totalSalary + summary.csatBonus)}',
                  isBold: true,
                ),
                const Divider(),
                _buildSalaryRow(
                  context,
                  'TDS Deduction (${(AppConstants.tdsRate * 100).toStringAsFixed(0)}%)',
                  '-₹${formatter.format(summary.tdsDeduction)}',
                  highlight: summary.tdsDeduction > 0,
                ),
                const Divider(),
                _buildSalaryRow(
                  context,
                  'Net Salary',
                  '₹${formatter.format(summary.netSalary)}',
                  isBold: true,
                  highlight: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSalaryRow(
    BuildContext context,
    String label,
    String amount, {
    bool highlight = false,
    bool isBold = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: isBold
                  ? theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )
                  : theme.textTheme.bodyMedium,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isBold ? 18 : 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              // Use the theme's primary color for highlight
              color: highlight ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
