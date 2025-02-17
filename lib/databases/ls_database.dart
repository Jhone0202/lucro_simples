import 'dart:io';

import 'package:lucro_simples/databases/ls_migration_scripts.dart';
import 'package:lucro_simples/helpers/directory_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LsDatabase {
  static final LsDatabase _dbController = LsDatabase.internal();
  static Database? _db;

  factory LsDatabase() => _dbController;

  Future<Database> get db async {
    if (_db != null) return _db!;
    return _db = await initDb();
  }

  static closeDatabase() async {
    await _db?.close();
    _db = null;
  }

  LsDatabase.internal();

  Future<Database> initDb() async {
    final Directory directory = await DirectoryHelper.getDatabaseDirectory();
    final String path = join(directory.path, 'db_lucro_simples.db');

    final database = await openDatabase(
      path,
      version: lsMigrationScripts.length,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    // Ativar a verificação de chaves estrangeiras
    await database.rawQuery('PRAGMA foreign_keys = ON;');

    return database;
  }

  Future _onCreate(Database db, int version) async {
    for (var i = 1; i <= lsMigrationScripts.length; i++) {
      if (lsMigrationScripts[i] != null) {
        await db.execute(lsMigrationScripts[i]!);
      }
    }
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      if (lsMigrationScripts[i] != null) {
        await db.execute(lsMigrationScripts[i]!);
      }
    }
  }

  Future resetDatabase() async {
    final database = await db;

    await closeDatabase();
    await deleteDatabase(database.path);

    _db = await initDb();
  }
}
