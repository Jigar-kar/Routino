import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

import 'database_service.dart';

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  /// The local SQLite tables we want to backup.
  static const List<String> _tablesToBackup = [
    'tasks',
    'expenses',
    'notes',
    'routines',
    'user',
  ];

  /// Exports all local SQLite databases to a monolithic JSON file, 
  /// and opens the system Share sheet (allowing save to Drive, Dropbox, Local Storage, etc).
  Future<bool> exportBackupToDriveOrLocal() async {
    try {
      final db = await DatabaseService.instance.database;
      final Map<String, dynamic> backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'data': {},
      };

      // 1. Fetch all data from supported tables
      for (final table in _tablesToBackup) {
        final List<Map<String, dynamic>> records = await db.query(table);
        // sqflite returns mapped data as read-only, so we take a copy if needed,
        // but jsonEncode handles them fine as maps.
        backupData['data'][table] = records;
      }

      // 2. Convert to JSON string
      final String jsonString = jsonEncode(backupData);

      // 3. Write to a temporary file
      final directory = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/routino_backup_$dateStr.json');
      await file.writeAsString(jsonString);

      // 4. Trigger system share sheet
      // Allows user to upload to Google Drive, share via Email, save to Files, etc.
      if (kIsWeb) {
        // Share_plus on web might not handle files perfectly depending on browser,
        // but for mobile/desktop it works perfectly.
        return false;
      }

      // ignore: deprecated_member_use
      final result = await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Routino Backup $dateStr',
        text: 'Here is your Routino app backup.',
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('[BackupService] Export failed: $e');
      return false;
    }
  }

  /// Opens the system file picker to select a JSON backup file,
  /// parses it, and restores all table records into the local SQLite database.
  Future<bool> importBackupFromJSON() async {
    try {
      // 1. Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) {
        // User canceled the picker
        return false;
      }

      final File file = File(result.files.single.path!);
      final String jsonString = await file.readAsString();

      // 2. Parse JSON
      final Map<String, dynamic> backupData = jsonDecode(jsonString);

      if (backupData['version'] == null || backupData['data'] == null) {
        throw const FormatException('Invalid backup file format.');
      }

      final Map<String, dynamic> tablesData = backupData['data'];

      // 3. Restore to Database
      final db = await DatabaseService.instance.database;

      await db.transaction((txn) async {
        for (final table in _tablesToBackup) {
          if (tablesData.containsKey(table)) {
            final List<dynamic> records = tablesData[table];
            for (final record in records) {
              final Map<String, dynamic> mappedRecord = Map<String, dynamic>.from(record);
              // Insert or replace to avoid constraint errors
              await txn.insert(
                table,
                mappedRecord,
                conflictAlgorithm: ConflictAlgorithm.replace,
              );
            }
          }
        }
      });

      debugPrint('[BackupService] Restore successful.');
      return true;
    } catch (e) {
      debugPrint('[BackupService] Import failed: $e');
      return false;
    }
  }
}
