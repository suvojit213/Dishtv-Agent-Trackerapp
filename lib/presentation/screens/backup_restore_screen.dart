import 'package:dishtv_agent_tracker/data/datasources/local_data_source.dart';
import 'package:flutter/material.dart';

class BackupRestoreScreen extends StatelessWidget {
  final LocalDataSource _localDataSource = LocalDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Backup & Restore'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final success = await _localDataSource.backupDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Backup successful!'
                        : 'Backup failed.'),
                  ),
                );
              },
              child: Text('Backup Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await _localDataSource.restoreDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Restore successful!\nPlease restart the app.'
                        : 'Restore failed.'),
                  ),
                );
              },
              child: Text('Restore Data'),
            ),
          ],
        ),
      ),
    );
  }
}