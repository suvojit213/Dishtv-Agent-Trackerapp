import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class GetAllMonthlySummariesUseCase {
  final PerformanceRepository repository;

  GetAllMonthlySummariesUseCase(this.repository);

  Future<List<MonthlySummary>> execute() {
    // Repository se seedhe summaries laayein aur return karein.
    return repository.getAllMonthlySummaries();
  }
}
