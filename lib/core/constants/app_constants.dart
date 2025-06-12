class AppConstants {
  // App information
  static const String appName = 'DishTV Agent Tracker';
  static const String appVersion = '1.0.4';
  static const String appDeveloper = 'Suvojeet';

  // Salary calculation constants
  static const double baseRatePerCall = 4.30;
  static const double bonusAmount = 2000.0;
  static const int bonusCallTarget = 750;
  static const int bonusHourTarget = 100; // in hours

  // Database constants
  static const String databaseName = 'dishtv_agent_tracker.db';
  static const int databaseVersion = 3; // Updated version for CQ feature

  // Table names
  static const String tableEntries = 'daily_entries';
  static const String tableCSATEntries = 'csat_entries';
  static const String tableCQEntries = 'cq_entries'; // New CQ table

  // Shared preferences keys
  static const String prefThemeMode = 'theme_mode';
}
