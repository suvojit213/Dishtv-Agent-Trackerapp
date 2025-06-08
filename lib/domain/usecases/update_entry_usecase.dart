import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class UpdateEntryUseCase {
  final PerformanceRepository repository;
  
  UpdateEntryUseCase(this.repository);
  
  Future<int> execute(DailyEntry entry) {
    return repository.updateEntry(entry);
  }
}

