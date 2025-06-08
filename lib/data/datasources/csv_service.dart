 
import 'package:csv/csv.dart';
import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:intl/intl.dart';

class CsvService {
  // This function creates a beautifully formatted CSV string
  String generateMonthlyReport(MonthlySummary summary) {
    final formatter = NumberFormat('#,##0.00');

    // Organize the data in a list of lists
    List<List<dynamic>> rows = [];

    // First, add a report header
    rows.add(['DishTV Agent Performance Report']);
    rows.add(['Month:', summary.formattedMonthYear]);
    rows.add([]); // Blank line

    // Next, add the monthly summary
    rows.add(['Monthly Summary']);
    rows.add(['Description', 'Value']);
    rows.add(['Total Login Hours', '${formatter.format(summary.totalLoginHours)} hrs']);
    rows.add(['Total Calls', summary.totalCalls]);
    rows.add(['Average Daily Hours', '${formatter.format(summary.averageDailyLoginHours)} hrs']);
    rows.add(['Average Daily Calls', formatter.format(summary.averageDailyCalls)]);
    rows.add([]); // Blank line

    // Then, add salary details
    rows.add(['Salary Details']);
    rows.add(['Description', 'Amount']);
    rows.add(['Base Salary', 'Rs. ${formatter.format(summary.baseSalary)}']);
    rows.add(['Bonus', 'Rs. ${formatter.format(summary.bonusAmount)}']);
    rows.add(['Total Salary', 'Rs. ${formatter.format(summary.totalSalary)}']);
    rows.add([]); // Blank line

    // Finally, add the daily entries table
    rows.add(['Daily Entries']);
    rows.add(['Date', 'Login Time', 'Call Count']);
    for (DailyEntry entry in summary.entries) {
      rows.add([
        DateFormat('dd-MMM-yyyy').format(entry.date),
        entry.formattedLoginTime,
        entry.callCount,
      ]);
    }

    // Convert the list to a CSV string
    String csv = const ListToCsvConverter().convert(rows);
    return csv;
  }
}

