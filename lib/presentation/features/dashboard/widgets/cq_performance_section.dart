import 'package:flutter/material.dart';
import 'package:dishtv_agent_tracker/core/constants/app_colors.dart';
import 'package:dishtv_agent_tracker/domain/entities/cq_summary.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';

class CQPerformanceSection extends StatelessWidget {
  final CQSummary? cqSummary;

  const CQPerformanceSection({
    Key? key,
    required this.cqSummary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (cqSummary == null || cqSummary!.entries.isEmpty) {
      return CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assessment,
                  color: AppColors.dishTvOrange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Call Quality (CQ) Performance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No CQ data available',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Add CQ audit entries to see performance',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final averageCQ = cqSummary!.monthlyAverageCQ;
    final needsImprovement = cqSummary!.needsImprovement;
    final qualityRating = cqSummary!.qualityRating;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assessment,
                color: AppColors.dishTvOrange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Call Quality (CQ) Performance',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // CQ Percentage Display
          Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getQualityColor(averageCQ).withOpacity(0.1),
                    border: Border.all(
                      color: _getQualityColor(averageCQ),
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${averageCQ.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _getQualityColor(averageCQ),
                          ),
                        ),
                        Text(
                          'CQ Avg',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getQualityColor(averageCQ),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Quality Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getQualityColor(averageCQ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getQualityColor(averageCQ).withOpacity(0.3)),
                  ),
                  child: Text(
                    qualityRating,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _getQualityColor(averageCQ),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Improvement message if needed
                if (needsImprovement)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accentRed.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppColors.accentRed,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Needs Improvement',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.accentRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // CQ Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Audits',
                  cqSummary!.totalAudits.toString(),
                  AppColors.dishTvOrange,
                  Icons.assignment_turned_in,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Highest',
                  '${cqSummary!.highestCQ.toStringAsFixed(1)}%',
                  AppColors.accentGreen,
                  Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Lowest',
                  '${cqSummary!.lowestCQ.toStringAsFixed(1)}%',
                  AppColors.accentRed,
                  Icons.trending_down,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Improvement Rate
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cqSummary!.improvementRate > 50 
                  ? AppColors.accentRed.withOpacity(0.1)
                  : AppColors.accentGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cqSummary!.improvementRate > 50 
                    ? AppColors.accentRed.withOpacity(0.3)
                    : AppColors.accentGreen.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Audits Needing Improvement',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${cqSummary!.auditsNeedingImprovement}/${cqSummary!.totalAudits} (${cqSummary!.improvementRate.toStringAsFixed(1)}%)',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cqSummary!.improvementRate > 50 
                        ? AppColors.accentRed
                        : AppColors.accentGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getQualityColor(double percentage) {
    if (percentage >= 85) return AppColors.accentGreen;
    if (percentage >= 75) return AppColors.dishTvOrange;
    return AppColors.accentRed;
  }
}

