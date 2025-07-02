import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/csat_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/cq_entry.dart';

class DataImportService {
  Future<List<DailyEntry>> importDailyEntriesFromCsv(File file) async {
    final input = file.openRead();
    final fields = await input
        .transform(const SystemEncoding().decoder)
        .transform(const CsvToListConverter())
        .toList();

    final List<DailyEntry> entries = [];
    // Assuming CSV format: date, loginHours, loginMinutes, loginSeconds, callCount
    for (var i = 1; i < fields.length; i++) { // Skip header row
      final row = fields[i];
      try {
        final date = DateTime.parse(row[0].toString());
        final loginHours = int.parse(row[1].toString());
        final loginMinutes = int.parse(row[2].toString());
        final loginSeconds = int.parse(row[3].toString());
        final callCount = int.parse(row[4].toString());

        entries.add(DailyEntry(
          date: date,
          loginHours: loginHours,
          loginMinutes: loginMinutes,
          loginSeconds: loginSeconds,
          callCount: callCount,
        ));
      } catch (e) {
        print('Error parsing daily entry row: $row - $e');
        // Optionally, skip or log problematic rows
      }
    }
    return entries;
  }

  Future<List<CSATEntry>> importCSATEntriesFromCsv(File file) async {
    final input = file.openRead();
    final fields = await input
        .transform(const SystemEncoding().decoder)
        .transform(const CsvToListConverter())
        .toList();

    final List<CSATEntry> entries = [];
    // Assuming CSV format: date, t2Count, b2Count, nCount
    for (var i = 1; i < fields.length; i++) { // Skip header row
      final row = fields[i];
      try {
        final date = DateTime.parse(row[0].toString());
        final t2Count = int.parse(row[1].toString());
        final b2Count = int.parse(row[2].toString());
        final nCount = int.parse(row[3].toString());

        entries.add(CSATEntry(
          date: date,
          t2Count: t2Count,
          b2Count: b2Count,
          nCount: nCount,
        ));
      } catch (e) {
        print('Error parsing CSAT entry row: $row - $e');
        // Optionally, skip or log problematic rows
      }
    }
    return entries;
  }

  Future<List<CQEntry>> importCQEntriesFromCsv(File file) async {
    final input = file.openRead();
    final fields = await input
        .transform(const SystemEncoding().decoder)
        .transform(const CsvToListConverter())
        .toList();

    final List<CQEntry> entries = [];
    // Assuming CSV format: auditDate, percentage
    for (var i = 1; i < fields.length; i++) { // Skip header row
      final row = fields[i];
      try {
        final auditDate = DateTime.parse(row[0].toString());
        final percentage = double.parse(row[1].toString());

        entries.add(CQEntry(
          auditDate: auditDate,
          percentage: percentage,
        ));
      } catch (e) {
        print('Error parsing CQ entry row: $row - $e');
        // Optionally, skip or log problematic rows
      }
    }
    return entries;
  }

  // You can add similar methods for Excel import using the 'excel' package
  // For example:
  // Future<List<DailyEntry>> importDailyEntriesFromExcel(File file) async {
  //   var bytes = file.readAsBytesSync();
  //   var excel = Excel.decodeBytes(bytes);
  //   for (var table in excel.tables.keys) {
  //     if (table == 'Daily Entries') { // Assuming a sheet named 'Daily Entries'
  //       for (var row in excel.tables[table]!.rows) {
  //         // Parse row data into DailyEntry objects
  //       }
  //     }
  //   }
  //   return [];
  // }
}
