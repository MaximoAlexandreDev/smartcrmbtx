// DAO da fila de sincronização.

import 'package:sqflite/sqflite.dart';
import 'database.dart';
import '../models/sync_job.dart';

class SyncDao {
  Future<void> enqueue(SyncJob job) async {
    final db = await AppDatabase.database;
    await db.insert('sync_queue', job.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SyncJob>> pending({int limit = 20}) async {
    final db = await AppDatabase.database;
    final rows = await db.query(
      'sync_queue',
      where: 'status = ?',
      whereArgs: ['PENDING'],
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return rows.map((e) => SyncJob.fromMap(e)).toList();
  }

  Future<void> markSuccess(String id) async {
    final db = await AppDatabase.database;
    await db.update(
      'sync_queue',
      {
        'status': 'SUCCESS',
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markError(String id, String error, int attempts) async {
    final db = await AppDatabase.database;
    await db.update(
      'sync_queue',
      {
        'status': 'ERROR',
        'attempts': attempts,
        'last_error': error,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}