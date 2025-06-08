import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class GenerateCsvReportUseCase {
  final PerformanceRepository repository;

  GenerateCsvReportUseCase(this.repository);

  Future<String> execute(MonthlySummary summary) {
    return repository.generateMonthlyReportCsv(summary);
  }
}
