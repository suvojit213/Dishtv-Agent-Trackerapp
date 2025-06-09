import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class GeneratePdfReportUseCase {
  final PerformanceRepository repository;

  GeneratePdfReportUseCase(this.repository);

  Future<List<int>> execute(MonthlySummary summary) {
    return repository.generateMonthlyReportPdf(summary);
  }
}

