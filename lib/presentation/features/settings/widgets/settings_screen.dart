import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_app_bar.dart';
import 'package:dishtv_agent_tracker/presentation/common/widgets/custom_button.dart';
import 'package:dishtv_agent_tracker/domain/repositories/performance_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Management',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Backup Data',
              icon: Icons.cloud_upload,
              onPressed: () => _backupData(context),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Restore Data',
              icon: Icons.cloud_download,
              onPressed: () => _restoreData(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _backupData(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backing up data...')), 
    );
    try {
      final repo = context.read<PerformanceRepository>();
      final backupPath = await repo.backupDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data backed up to: $backupPath')), 
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup failed: $e')), 
      );
    }
  }

  Future<void> _restoreData(BuildContext context) async {
    // This is a simplified example. In a real app, you'd want a file picker.
    // For now, let's assume the backup file is in a known location or user selects it.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Restoring data... (Manual file selection needed in real app)')), 
    );
    try {
      final repo = context.read<PerformanceRepository>();
      // Placeholder for actual file selection
      // You would typically use a package like file_picker to let the user select a file
      // For demonstration, let's assume a file named 'dishtv_agent_tracker.db_backup_TIMESTAMP.db' exists in external storage
      final externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        throw Exception("Could not get external storage directory.");
      }
      // This path needs to be dynamic based on the actual backup file name
      final backupFilePath = '${externalDir.path}/dishtv_agent_tracker.db_backup_YOUR_TIMESTAMP.db'; // REPLACE WITH ACTUAL BACKUP FILE

      // Check if the placeholder file exists
      if (!await File(backupFilePath).exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup file not found at assumed path. Please select manually in a real app.')), 
        );
        return;
      }

      await repo.restoreDatabase(backupFilePath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data restored successfully! Please restart the app.')), 
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')), 
      );
    }
  }
}


