abstract class GoalRepository {
  Future<void> saveGoals({required int hours, required int calls});
  Future<Map<String, int>> getGoals();
}
