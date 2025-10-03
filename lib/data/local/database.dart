// Inicialização do banco local (SQLite) e criação de tabelas.
// Tabelas: tasks, sync_queue, user_profile

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../core/logger.dart';

class AppDatabase {
  static const _dbName = 'smart_bitrix24.db';
  static const _dbVersion = 1;

  static Database? _instance;

  static Future<Database> get database async {
    if (_instance != null) return _instance!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _instance = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    logI('Banco inicializado em $path');
    return _instance!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(''
      'CREATE TABLE tasks ('
      '  id TEXT PRIMARY KEY,'
      '  title TEXT NOT NULL,'
      '  description TEXT,'
      '  status TEXT NOT NULL,'
      '  created_at INTEGER NOT NULL,'
      '  updated_at INTEGER NOT NULL,'
      '  remote_id TEXT'
      ');'
    '');

    await db.execute(''
      'CREATE TABLE sync_queue ('
      '  id TEXT PRIMARY KEY,'
      '  method TEXT NOT NULL,'
      '  payload TEXT NOT NULL,'
      '  status TEXT NOT NULL,' // PENDING | SUCCESS | ERROR
      '  attempts INTEGER NOT NULL,'
      '  last_error TEXT,'
      '  created_at INTEGER NOT NULL,'
      '  updated_at INTEGER NOT NULL'
      ');'
    '');

    await db.execute(''
      'CREATE TABLE user_profile ('
      '  id TEXT PRIMARY KEY,'
      '  name TEXT,'
      '  email TEXT,'
      '  portal_domain TEXT NOT NULL'
      ');'
    '');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Evoluções futuras de schema
  }
}