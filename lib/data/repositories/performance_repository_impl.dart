import 'package:dishtv_agent_tracker/data/datasources/pdf_service.dart';
import 'package:dishtv_agent_tracker/data/datasources/local_data_source.dart';
import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';

class PerformanceRepositoryImpl implements PerformanceRepository {
  final LocalDataSource localDataSource;
  final PdfService _pdfService = PdfService();

  PerformanceRepositoryImpl({
    required this.localDataSource,
  });

  // ... बाकी के सभी मेथड्स वैसे ही रहेंगे ...
  @override
  Future<List<DailyEntry>> getAllEntries() async {
    return await localDataSource.getAllEntries();
  }
  @override
  Future<List<DailyEntry>> getEntriesForMonth(int month, int year) async {
    return await localDataSource.getEntriesForMonth(month, year);
  }
  @override
  Future<DailyEntry?> getEntryForDate(DateTime date) async {
    return await localDataSource.getEntryForDate(date);
  }
  @override
  Future<int> addEntry(DailyEntry entry) async {
    return await localDataSource.insertEntry(entry);
  }
  @override
  Future<int> updateEntry(DailyEntry entry) async {
    return await localDataSource.updateEntry(entry);
  }
  @override
  Future<int> deleteEntry(int id) async {
    return await localDataSource.deleteEntry(id);
  }
  @override
  Future<List<MonthlySummary>> getAllMonthlySummaries() async {
    final monthYearCombinations = await localDataSource.getUniqueMonthYearCombinations();
    final List<MonthlySummary> summaries = [];
    for (final combination in monthYearCombinations) {
      final month = combination["month"]!;
      final year = combination["year"]!;
      final summary = await getMonthlySummary(month, year);
      summaries.add(summary);
    }
    return summaries;
  }
  @override
  Future<MonthlySummary> getMonthlySummary(int month, int year) async {
    final entries = await localDataSource.getEntriesForMonth(month, year);
    return MonthlySummary(
      month: month,
      year: year,
      entries: entries,
    );
  }
  
  // PDF मेथड को CSV से बदलें
  @override
  Future<List<int>> generateMonthlyReportPdf(MonthlySummary summary) async {
    return _pdfService.generateMonthlyReportPdf(summary);
  }
}
