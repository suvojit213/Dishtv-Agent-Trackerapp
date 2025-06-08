import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class AddEntryUseCase {
  final PerformanceRepository repository;
  
  AddEntryUseCase(this.repository);
  
  Future<int> execute(DailyEntry entry) {
    return repository.addEntry(entry);
  }
}

