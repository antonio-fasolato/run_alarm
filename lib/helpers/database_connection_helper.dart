import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:sqflite_common/sqflite_logger.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseConnectionHelper {
  final log = Logger((DatabaseConnectionHelper).toString());
  Database? _database;

  static final DatabaseConnectionHelper _instance =
      DatabaseConnectionHelper._internal();

  factory DatabaseConnectionHelper() {
    return _instance;
  }

  DatabaseConnectionHelper._internal();

  bool get isConnected => _database != null && _database!.isOpen;

  Database get db {
    if (!isConnected) {
      throw Exception("Database not connected");
    }
    return _database as Database;
  }

  connect() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (isConnected) {
      log.info("Database already connected");
      return;
    }

    var databasePath = join(await getDatabasesPath(), 'run_app.db');
    bool newFile = !(await io.File(databasePath).exists());
    DatabaseFactory factory = kDebugMode
        ? SqfliteDatabaseFactoryLogger(
            databaseFactoryFfi,
            options: SqfliteLoggerOptions(
              type: SqfliteDatabaseFactoryLoggerType.all,
              log: (event) => log.info(event),
            ),
          )
        : databaseFactoryFfi;
    _database = await factory.openDatabase(databasePath);
    log.info("Connected to $databasePath");
    if (newFile) {
      await _initDb(_database as Database);
    }
  }

  Future<void> _initDb(Database db) async {
    log.info("Initializing new database");

    var sql = '''
      CREATE TABLE DB_VERSION(id PRIMARY KEY)
    ''';
    await db.execute(sql);
    await db.insert('DB_VERSION', {"id": 1});
  }
}
