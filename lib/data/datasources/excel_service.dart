import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';

class ExcelService {
  Future<File> generateMonthlyReportExcel(MonthlySummary summary) async {
    final excel = Excel.createExcel();
    final formatter = NumberFormat('#,##0.00');

    // --- Summary Sheet ---
    Sheet summarySheet = excel['Summary'];
    _addHeader(summarySheet, 'DishTV Agent Performance Report', summary.formattedMonthYear);

    // Monthly Summary Section
    _addSectionTitle(summarySheet, 'Monthly Summary');
    _addTable(summarySheet, ['Description', 'Value'], [
      ['Total Login Hours', '${formatter.format(summary.totalLoginHours)} hrs'],
      ['Total Calls', summary.totalCalls.toString()],
      ['Average Daily Hours', '${formatter.format(summary.averageDailyLoginHours)} hrs'],
      ['Average Daily Calls', formatter.format(summary.averageDailyCalls)],
    ]);
    _addEmptyRow(summarySheet);

    // Overall CSAT Performance Section
    if (summary.csatSummary != null && summary.csatSummary!.entries.isNotEmpty) {
      _addSectionTitle(summarySheet, 'Overall CSAT Performance');
      _addTable(summarySheet, ['Description', 'Value'], [
        ['Total T2 Count', summary.csatSummary!.totalT2Count.toString()],
        ['Total B2 Count', summary.csatSummary!.totalB2Count.toString()],
        ['Total N Count', summary.csatSummary!.totalNCount.toString()],
        ['Total Survey Hits', summary.csatSummary!.totalSurveyHits.toString()],
        ['Monthly CSAT Percentage', '${formatter.format(summary.csatSummary!.monthlyCSATPercentage)}%'],
        ['Average Daily CSAT Score', '${formatter.format(summary.csatSummary!.averageScore)}%'],
      ]);
      _addEmptyRow(summarySheet);
    }

    // Overall CQ Performance Section
    if (summary.cqSummary != null && summary.cqSummary!.entries.isNotEmpty) {
      _addSectionTitle(summarySheet, 'Overall CQ Performance');
      _addTable(summarySheet, ['Description', 'Value'], [
        ['Total CQ Entries', summary.cqSummary!.entries.length.toString()],
        ['Average CQ Score', formatter.format(summary.cqSummary!.averageScore)],
      ]);
      _addEmptyRow(summarySheet);
    }

    // Salary Details Section
    _addSectionTitle(summarySheet, 'Salary Details');
    _addTable(summarySheet, ['Description', 'Amount', 'Status'], [
      ['Base Salary', '₹${formatter.format(summary.baseSalary)}', ''],
      ['Bonus Amount', '₹${formatter.format(summary.bonusAmount)}', summary.isBonusAchieved ? 'Achieved' : 'Not Achieved'],
      ['CSAT Bonus', '₹${formatter.format(summary.csatBonus)}', summary.isCSATBonusAchieved ? 'Achieved' : 'Not Achieved'],
      ['Gross Salary', '₹${formatter.format(summary.totalSalary + summary.csatBonus)}', ''],
      ['TDS Deduction', '₹-${formatter.format(summary.tdsDeduction)}', ''],
      ['Net Salary', '₹${formatter.format(summary.netSalary)}', ''],
    ]);
    _addEmptyRow(summarySheet);

    // --- Daily Entries Sheet ---
    if (summary.entries.isNotEmpty) {
      Sheet dailyEntriesSheet = excel['Daily Entries'];
      _addHeader(dailyEntriesSheet, 'Daily Entries', summary.formattedMonthYear);
      _addTable(dailyEntriesSheet, ['Date', 'Login Time', 'Call Count'],
        summary.entries.map((entry) => [
          DateFormat('dd-MMM-yyyy').format(entry.date),
          entry.formattedLoginTime,
          entry.callCount,
        ]).toList(),
      );
    }

    // --- CSAT Daily Breakdown Sheet ---
    if (summary.csatSummary != null && summary.csatSummary!.entries.isNotEmpty) {
      Sheet csatDailySheet = excel['CSAT Daily Breakdown'];
      _addHeader(csatDailySheet, 'CSAT Daily Breakdown', summary.formattedMonthYear);
      _addTable(csatDailySheet, ['Date', 'T2', 'B2', 'N', 'CSAT %'],
        summary.csatSummary!.entries.map((entry) {
          final total = entry.t2Count + entry.b2Count + entry.nCount;
          final csatPercentage = total == 0 ? 0.0 : ((entry.t2Count - entry.b2Count) / total) * 100;
          return [
            DateFormat('dd-MMM-yyyy').format(entry.date),
            entry.t2Count,
            entry.b2Count,
            entry.nCount,
            csatPercentage.toStringAsFixed(2) + '%',
          ];
        }).toList(),
      );
    }

    // --- CQ Daily Breakdown Sheet ---
    if (summary.cqSummary != null && summary.cqSummary!.entries.isNotEmpty) {
      Sheet cqDailySheet = excel['CQ Daily Breakdown'];
      _addHeader(cqDailySheet, 'CQ Daily Breakdown', summary.formattedMonthYear);
      _addTable(cqDailySheet, ['Date', 'Percentage', 'Quality Rating'],
        summary.cqSummary!.entries.map((entry) => [
          DateFormat('dd-MMM-yyyy').format(entry.auditDate),
          entry.percentage,
          _getQualityRating(entry.percentage),
        ]).toList(),
      );
    }

    // Auto-fit columns for all sheets
    for (var sheetName in excel.tables.keys) {
      for (var colIdx = 0; colIdx < excel.tables[sheetName]!.maxCols; colIdx++) {
        excel.tables[sheetName]!.setColAutoFit(colIdx);
      }
    }

    // Save the Excel file
    final directory = await getExternalStorageDirectory();
    final filePath = '${directory!.path}/DishTV_Report_${summary.formattedMonthYear}.xlsx';
    final file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
    return file;
  }

  void _addHeader(Sheet sheet, String title, String monthYear) {
    sheet.appendRow([title]);
    sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: sheet.maxRows - 1),
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: sheet.maxRows - 1));
    sheet.appendRow(['Month: $monthYear']);
    sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: sheet.maxRows - 1),
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: sheet.maxRows - 1));
    _addEmptyRow(sheet);
  }

  void _addSectionTitle(Sheet sheet, String title) {
    sheet.appendRow([title]);
    sheet.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: sheet.maxRows - 1),
        CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: sheet.maxRows - 1));
    _addEmptyRow(sheet);
  }

  void _addTable(Sheet sheet, List<String> headers, List<List<dynamic>> data) {
    sheet.appendRow(headers.map((e) => TextCellValue(e)).toList());
    for (var row in data) {
      sheet.appendRow(row.map((e) => TextCellValue(e.toString())).toList());
    }
  }

  void _addEmptyRow(Sheet sheet) {
    sheet.appendRow([]);
  }

  String _getQualityRating(double percentage) {
    if (percentage >= 95) return 'Excellent';
    if (percentage >= 85) return 'Good';
    if (percentage >= 75) return 'Average';
    if (percentage >= 60) return 'Below Average';
    return 'Poor';
  }
}