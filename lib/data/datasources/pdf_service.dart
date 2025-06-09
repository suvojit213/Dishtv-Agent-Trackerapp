import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<List<int>> generateMonthlyReportPdf(MonthlySummary summary) async {
    final pdf = pw.Document();
    final formatter = NumberFormat('#,##0.00');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('DishTV Agent Performance Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text('Month: ${summary.formattedMonthYear}', style: pw.TextStyle(fontSize: 18)),
              pw.SizedBox(height: 20),

              pw.Text('Monthly Summary', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Description', 'Value'],
                data: [
                  ['Total Login Hours', '${formatter.format(summary.totalLoginHours)} hrs'],
                  ['Total Calls', summary.totalCalls.toString()],
                  ['Average Daily Hours', '${formatter.format(summary.averageDailyLoginHours)} hrs'],
                  ['Average Daily Calls', formatter.format(summary.averageDailyCalls)],
                ],
              ),
              pw.SizedBox(height: 20),

              pw.Text('Salary Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Description', 'Amount'],
                data: [
                  ['Base Salary', 'Rs. ${formatter.format(summary.baseSalary)}'],
                  ['Bonus', 'Rs. ${formatter.format(summary.bonusAmount)}'],
                  ['Total Salary', 'Rs. ${formatter.format(summary.totalSalary)}'],
                ],
              ),
              pw.SizedBox(height: 20),

              pw.Text('Daily Entries', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Date', 'Login Time', 'Call Count'],
                data: summary.entries.map((entry) => [
                  DateFormat('dd-MMM-yyyy').format(entry.date),
                  entry.formattedLoginTime,
                  entry.callCount.toString(),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

