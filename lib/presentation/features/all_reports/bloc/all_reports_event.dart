import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:equatable/equatable.dart';

abstract class AllReportsEvent extends Equatable {
  const AllReportsEvent();

  @override
  List<Object> get props => [];
}

class LoadAllMonthlySummaries extends AllReportsEvent {}

class ExportMonthlyReportAsPdf extends AllReportsEvent {
  final MonthlySummary summary;

  const ExportMonthlyReportAsPdf(this.summary);

  @override
  List<Object> get props => [summary];
}