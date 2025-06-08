import 'package:shared_preferences/shared_preferences.dart';

class GoalDataSource {
  static const _hoursKey = 'goal_hours';
  static const _callsKey = 'goal_calls';

  Future<void> saveGoals({required int hours, required int calls}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hoursKey, hours);
    await prefs.setInt(_callsKey, calls);
  }

  Future<Map<String, int>> getGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final hours = prefs.getInt(_hoursKey) ?? 150; // डिफ़ॉल्ट लक्ष्य
    final calls = prefs.getInt(_callsKey) ?? 1000; // डिफ़ॉल्ट लक्ष्य
    return {'hours': hours, 'calls': calls};
  }
}
