import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/entities/csat_summary.dart';
import 'package:dishtv_agent_tracker/domain/entities/csat_entry.dart'; // Import CSATEntry

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
  Future<CSATSummary> getCSATSummary(int month, int year);

  // Add CSAT entry methods
  Future<int> saveCSATEntry(CSATEntry entry); // Add this line
  Future<int> deleteCSATEntry(int id); // Add this line
  
  // PDF को CSV से बदलें
  Future<List<int>> generateMonthlyReportPdf(MonthlySummary summary);
}


