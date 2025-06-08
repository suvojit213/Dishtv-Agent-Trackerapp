import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:dishtv_agent_tracker/core/constants/app_constants.dart';
import 'package:dishtv_agent_tracker/domain/entities/daily_entry.dart';

class LocalDataSource {
  static Database? _database;
  
  // Private constructor to prevent instantiation
  LocalDataSource._();
  
  // Singleton instance
  static LocalDataSource? _instance;
  
  // Factory constructor to return the singleton instance
  factory LocalDataSource() {
    _instance ??= LocalDataSource._();
    return _instance!;
  }
  
  // Initialize the database
  static Future<LocalDataSource> init() async {
    if (_database != null) {
      return LocalDataSource();
    }
    
    // Get the database path
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    
    // Open the database
    _database = await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: (db, version) async {
        // Create tables
        await db.execute('''
          CREATE TABLE ${AppConstants.tableEntries} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date INTEGER NOT NULL,
            login_hours INTEGER NOT NULL,
            login_minutes INTEGER NOT NULL,
            login_seconds INTEGER NOT NULL,
            call_count INTEGER NOT NULL
          )
        ''');
      },
    );
    
    return LocalDataSource();
  }
  
  // Get the database instance
  Future<Database> get database async {
    if (_database == null) {
      await init();
    }
    return _database!;
  }
  
  // CRUD operations for daily entries
  
  // Create a new entry
  Future<int> insertEntry(DailyEntry entry) async {
    final db = await database;
    return await db.insert(
      AppConstants.tableEntries,
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  // Read all entries
  Future<List<DailyEntry>> getAllEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableEntries,
      orderBy: 'date DESC',
    );
    
    return List.generate(maps.length, (i) {
      return DailyEntry.fromMap(maps[i]);
    });
  }
  
  // Read entries for a specific month
  Future<List<DailyEntry>> getEntriesForMonth(int month, int year) async {
    final db = await database;
    
    // Calculate start and end dates for the month
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0); // Last day of the month
    
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableEntries,
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'date ASC',
    );
    
    return List.generate(maps.length, (i) {
      return DailyEntry.fromMap(maps[i]);
    });
  }
  
  // Read entry for a specific date
  Future<DailyEntry?> getEntryForDate(DateTime date) async {
    final db = await database;
    
    // Normalize the date to start of day
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final nextDay = normalizedDate.add(const Duration(days: 1));
    
    final List<Map<String, dynamic>> maps = await db.query(
      AppConstants.tableEntries,
      where: 'date >= ? AND date < ?',
      whereArgs: [
        normalizedDate.millisecondsSinceEpoch,
        nextDay.millisecondsSinceEpoch,
      ],
    );
    
    if (maps.isEmpty) {
      return null;
    }
    
    return DailyEntry.fromMap(maps.first);
  }
  
  // Update an existing entry
  Future<int> updateEntry(DailyEntry entry) async {
    final db = await database;
    return await db.update(
      AppConstants.tableEntries,
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }
  
  // Delete an entry
  Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete(
      AppConstants.tableEntries,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Get all unique month-year combinations
  Future<List<Map<String, int>>> getUniqueMonthYearCombinations() async {
    final entries = await getAllEntries();
    
    // Use a set to track unique combinations
    final Set<String> uniqueCombinations = {};
    final List<Map<String, int>> result = [];
    
    for (final entry in entries) {
      final key = '${entry.date.month}-${entry.date.year}';
      if (!uniqueCombinations.contains(key)) {
        uniqueCombinations.add(key);
        result.add({
          'month': entry.date.month,
          'year': entry.date.year,
        });
      }
    }
    
    // Sort by year and month (descending)
    result.sort((a, b) {
      final yearComparison = b['year']!.compareTo(a['year']!);
      if (yearComparison != 0) {
        return yearComparison;
      }
      return b['month']!.compareTo(a['month']!);
    });
    
    return result;
  }
}

