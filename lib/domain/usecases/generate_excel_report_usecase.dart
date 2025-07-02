import 'dart:io';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class GenerateExcelReportUseCase {
  final PerformanceRepository repository;

  GenerateExcelReportUseCase(this.repository);

  Future<File> execute(MonthlySummary summary) {
    return repository.generateMonthlyReportExcel(summary);
  }
}
