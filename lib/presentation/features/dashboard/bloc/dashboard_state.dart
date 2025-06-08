import 'package:equatable/equatable.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final MonthlySummary? monthlySummary;
  final String? errorMessage;
  final int currentMonth;
  final int currentYear;
  
  const DashboardState({
    this.status = DashboardStatus.initial,
    this.monthlySummary,
    this.errorMessage,
    required this.currentMonth,
    required this.currentYear,
  });
  
  factory DashboardState.initial() {
    final now = DateTime.now();
    return DashboardState(
      status: DashboardStatus.initial,
      currentMonth: now.month,
      currentYear: now.year,
    );
  }
  
  DashboardState copyWith({
    DashboardStatus? status,
    MonthlySummary? monthlySummary,
    String? errorMessage,
    int? currentMonth,
    int? currentYear,
  }) {
    return DashboardState(
      status: status ?? this.status,
      monthlySummary: monthlySummary ?? this.monthlySummary,
      errorMessage: errorMessage,
      currentMonth: currentMonth ?? this.currentMonth,
      currentYear: currentYear ?? this.currentYear,
    );
  }
  
  @override
  List<Object?> get props => [status, monthlySummary, errorMessage, currentMonth, currentYear];
}

