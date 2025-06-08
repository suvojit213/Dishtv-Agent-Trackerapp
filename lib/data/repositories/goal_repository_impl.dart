import 'package:dishtv_agent_tracker/data/datasources/goal_data_source.dart';
import 'package:dishtv_agent_tracker/domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final GoalDataSource dataSource;

  GoalRepositoryImpl(this.dataSource);

  @override
  Future<Map<String, int>> getGoals() {
    return dataSource.getGoals();
  }

  @override
  Future<void> saveGoals({required int hours, required int calls}) {
    return dataSource.saveGoals(hours: hours, calls: calls);
  }
}
