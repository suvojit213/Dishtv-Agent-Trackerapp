import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class DeleteEntryUseCase {
  final PerformanceRepository repository;
  
  DeleteEntryUseCase(this.repository);
  
  Future<int> execute(int id) {
    return repository.deleteEntry(id);
  }
}

