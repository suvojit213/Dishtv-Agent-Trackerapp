// Call Quality (CQ) Summary Entity
import 'package:equatable/equatable.dart';
import 'package:dishtv_agent_tracker/domain/entities/cq_entry.dart';

class CQSummary extends Equatable {
  final List<CQEntry> entries;
  final int month;
  final int year;
  
  const CQSummary({
    required this.entries,
    required this.month,
    required this.year,
  });
  
  // Calculate monthly average CQ percentage
  double get monthlyAverageCQ {
    if (entries.isEmpty) return 0.0;
    
    double totalPercentage = entries.fold(0.0, (sum, entry) => sum + entry.percentage);
    return totalPercentage / entries.length;
  }
  
  // Get total number of audits for the month
  int get totalAudits {
    return entries.length;
  }
  
  // Check if monthly CQ needs improvement (below 80%)
  bool get needsImprovement {
    return monthlyAverageCQ < 80.0;
  }
  
  // Get quality rating based on average percentage
  String get qualityRating {
    if (monthlyAverageCQ >= 95) return 'Excellent';
    if (monthlyAverageCQ >= 85) return 'Good';
    if (monthlyAverageCQ >= 75) return 'Average';
    if (monthlyAverageCQ >= 60) return 'Below Average';
    return 'Poor';
  }
  
  // Get formatted month year
  String get formattedMonthYear {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[month - 1]} $year';
  }
  
  // Get highest CQ score for the month
  double get highestCQ {
    if (entries.isEmpty) return 0.0;
    return entries.map((e) => e.percentage).reduce((a, b) => a > b ? a : b);
  }
  
  // Get lowest CQ score for the month
  double get lowestCQ {
    if (entries.isEmpty) return 0.0;
    return entries.map((e) => e.percentage).reduce((a, b) => a < b ? a : b);
  }
  
  // Get count of audits that need improvement
  int get auditsNeedingImprovement {
    return entries.where((entry) => entry.needsImprovement).length;
  }
  
  // Get percentage of audits that need improvement
  double get improvementRate {
    if (entries.isEmpty) return 0.0;
    return (auditsNeedingImprovement / entries.length) * 100;
  }
  
  @override
  List<Object?> get props => [entries, month, year];
}

