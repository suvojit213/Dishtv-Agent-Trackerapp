import 'dart:io';
import 'package:dishtv_agent_tracker/domain/entities/monthly_summary.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_card.dart';
import 'package:dishtv_agent_tracker/presentation/features/all_reports/bloc/all_reports_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/features/all_reports/bloc/all_reports_event.dart';
import 'package:dishtv_agent_tracker/presentation/features/all_reports/bloc/all_reports_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class AllReportsScreen extends StatelessWidget {
  const AllReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AllReportsBloc(
        repository: context.read<PerformanceRepository>(),
      )..add(LoadAllMonthlySummaries()),
      child: const AllReportsView(),
    );
  }
}

class AllReportsView extends StatelessWidget {
  const AllReportsView({Key? key}) : super(key: key);

  Future<void> _generateAndSharePdf(BuildContext context, MonthlySummary summary) async {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text("Generating PDF Report...")));

    try {
      final repo = context.read<PerformanceRepository>();
      final pdfBytes = await repo.generateMonthlyReportPdf(summary);
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/Report_${summary.monthName}_${summary.year}.pdf";
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      final xFile = XFile(filePath, mimeType: "application/pdf");
      await Share.shareXFiles([xFile], subject: "Monthly Report - ${summary.formattedMonthYear}");

    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text("Error creating PDF report: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'All Reports'),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Left to Right Swipe (पिछली स्क्रीन पर जाने के लिए)
          if ((details.primaryVelocity ?? 0) > 200) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<AllReportsBloc, AllReportsState>(
          builder: (context, state) {
            if (state.status == AllReportsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.summaries.isEmpty) {
              return const Center(child: Text('No monthly reports found.'));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.summaries.length,
              itemBuilder: (context, index) {
                final summary = state.summaries[index];
                return _buildReportCard(context, summary);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, MonthlySummary summary) {
    final formatter = NumberFormat('#,##0.00');
    return CustomCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summary.formattedMonthYear,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(height: 24),
          _buildInfoRow(context, Icons.call, 'Total Calls', '${summary.totalCalls}'),
          const SizedBox(height: 8),
          _buildInfoRow(context, Icons.timer, 'Total Hours', '${formatter.format(summary.totalLoginHours)} hrs'),
          const SizedBox(height: 8),
          _buildInfoRow(context, Icons.monetization_on, 'Total Salary', '₹${formatter.format(summary.totalSalary)}'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.share_outlined),
              label: const Text("Export PDF"),
              onPressed: () => _generateAndSharePdf(context, summary),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 8),
        Text('$label: ', style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
