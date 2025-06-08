import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class GetDailyEntriesUseCase {
  final PerformanceRepository repository;
  
  GetDailyEntriesUseCase(this.repository);
  
  Future<List<DailyEntry>> execute(int month, int year) {
    return repository.getEntriesForMonth(month, year);
  }
}

