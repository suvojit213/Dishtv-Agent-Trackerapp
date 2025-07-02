import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:intl/intl.dart';

class PdfService {
  Future<List<int>> generateMonthlyReportPdf(MonthlySummary summary) async {
    final pdf = pw.Document();
    final formatter = NumberFormat('#,##0.00');

    // Helper function to build the common header for each page
    pw.Widget _buildHeader(pw.Context context, String title) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('DishTV Agent Performance Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Month: ${summary.formattedMonthYear}', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 20),
          pw.Text(title, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
        ],
      );
    }

    // First page content (summary, CSAT, CQ, Salary)
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(context, 'Monthly Summary'),
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

              // CSAT Summary
              if (summary.csatSummary != null && summary.csatSummary!.entries.isNotEmpty) ...[
                pw.Text('CSAT Summary', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Date', 'T2', 'B2', 'N', 'CSAT %'],
                  data: summary.csatSummary!.entries.map((entry) {
                    final total = entry.t2Count + entry.b2Count + entry.nCount;
                    final csatPercentage = total == 0 ? 0.0 : ((entry.t2Count - entry.b2Count) / total) * 100;
                    return [
                      DateFormat('dd-MMM-yyyy').format(entry.date),
                      entry.t2Count.toString(),
                      entry.b2Count.toString(),
                      entry.nCount.toString(),
                      '${csatPercentage.toStringAsFixed(2)}%',
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Overall CSAT Performance', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Table.fromTextArray(
                  headers: ['Description', 'Value'],
                  data: [
                    ['Total CSAT Entries', summary.csatSummary!.entries.length.toString()],
                    ['Average CSAT Score', '${formatter.format(summary.csatSummary!.averageScore)}%'],
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              // CQ Summary
              if (summary.cqSummary != null) ...[
                pw.Text('CQ Summary', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Table.fromTextArray(
                  headers: ['Description', 'Value'],
                  data: [
                    ['Total CQ Entries', summary.cqSummary!.entries.length.toString()],
                    ['Average CQ Score', formatter.format(summary.cqSummary!.averageScore)],
                  ],
                ),
                pw.SizedBox(height: 20),
              ],

              pw.Text('Salary Details', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Description', 'Amount'],
                data: [
                  ['Base Salary', 'Rs. ${formatter.format(summary.baseSalary)}'],
                  ['Bonus', 'Rs. ${formatter.format(summary.bonusAmount)}'],
                  ['CSAT Bonus', 'Rs. ${formatter.format(summary.csatBonus)}'],
                  ['Gross Salary', 'Rs. ${formatter.format(summary.totalSalary + summary.csatBonus)}'],
                  ['TDS Deduction (${(summary.tdsDeduction / (summary.totalSalary + summary.csatBonus) * 100).toStringAsFixed(0)}%)', 'Rs. -${formatter.format(summary.tdsDeduction)}'],
                  ['Net Salary', 'Rs. ${formatter.format(summary.netSalary)}'],
                ],
              ),
            ],
          );
        },
      ),
    );

    // Daily Entries - potentially multiple pages
    if (summary.entries.isEmpty) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(context, 'Daily Entries'),
                pw.Text('No daily entries found for this month.', style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic)),
              ],
            );
          },
        ),
      );
    } else {
      const int rowsPerPage = 25; // Estimate rows that fit on a page
      for (int i = 0; i < summary.entries.length; i += rowsPerPage) {
        final end = (i + rowsPerPage < summary.entries.length) ? i + rowsPerPage : summary.entries.length;
        final pageEntries = summary.entries.sublist(i, end);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, 'Daily Entries'),
                  pw.Table.fromTextArray(
                    headers: ['Date', 'Login Time', 'Call Count'],
                    data: pageEntries.map((entry) => [
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
      }
    }

    return pdf.save();
  }
}


