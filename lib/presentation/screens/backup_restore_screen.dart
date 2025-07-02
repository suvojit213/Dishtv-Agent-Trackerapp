import 'package:dishtv_agent_tracker/data/datasources/local_data_source.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupRestoreScreen extends StatelessWidget {
  final LocalDataSource _localDataSource = LocalDataSource();

  Future<bool> _requestPermissions(BuildContext context) async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.storage.request();
    if (result.isGranted) {
      return true;
    } else if (result.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission permanently denied. Please enable it from app settings.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return false;
    }
    return false;
  }

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
                if (await _requestPermissions(context)) {
                  final success = await _localDataSource.backupDatabase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Backup successful!'
                          : 'Backup failed. Please try again.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Storage permission is required to create a backup.'),
                    ),
                  );
                }
              },
              child: Text('Backup Data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (await _requestPermissions(context)) {
                  final success = await _localDataSource.restoreDatabase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success
                          ? 'Restore successful!\nPlease restart the app to see the changes.'
                          : 'Restore failed. Please select a valid backup file.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Storage permission is required to restore data.'),
                    ),
                  );
                }
              },
              child: Text('Restore Data'),
            ),
          ],
        ),
      ),
    );
  }
}
