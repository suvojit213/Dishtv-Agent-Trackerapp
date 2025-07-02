import 'dart:io';
import 'package:dishtv_agent_tracker/data/datasources/data_import_service.dart';
import 'package:dishtv_agent_tracker/data/datasources/local_data_source.dart';

enum ImportDataType {
  dailyEntries,
  csatEntries,
  cqEntries,
}

class ImportDataUseCase {
  final DataImportService _importService;
  final LocalDataSource _localDataSource;

  ImportDataUseCase(this._importService, this._localDataSource);

  Future<int> execute(File file, ImportDataType type) async {
    int importedCount = 0;
    switch (type) {
      case ImportDataType.dailyEntries:
        final entries = await _importService.importDailyEntriesFromCsv(file);
        await _localDataSource.insertDailyEntries(entries);
        importedCount = entries.length;
        break;
      case ImportDataType.csatEntries:
        final entries = await _importService.importCSATEntriesFromCsv(file);
        await _localDataSource.insertCSATEntries(entries);
        importedCount = entries.length;
        break;
      case ImportDataType.cqEntries:
        final entries = await _importService.importCQEntriesFromCsv(file);
        await _localDataSource.insertCQEntries(entries);
        importedCount = entries.length;
        break;
    }
    return importedCount;
  }
}
