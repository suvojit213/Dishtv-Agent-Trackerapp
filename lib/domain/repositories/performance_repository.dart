import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';

abstract class PerformanceRepository {
  // ... बाकी के मेथड्स वैसे ही रहेंगे ...
  Future<List<DailyEntry>> getAllEntries();
  Future<List<DailyEntry>> getEntriesForMonth(int month, int year);
  Future<DailyEntry?> getEntryForDate(DateTime date);
  Future<int> addEntry(DailyEntry entry);
  Future<int> updateEntry(DailyEntry entry);
  Future<int> deleteEntry(int id);
  Future<List<MonthlySummary>> getAllMonthlySummaries();
  Future<MonthlySummary> getMonthlySummary(int month, int year);
  
  // PDF को CSV से बदलें
  Future<String> generateMonthlyReportCsv(MonthlySummary summary);
}
