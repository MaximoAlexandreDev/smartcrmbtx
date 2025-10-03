// DAO de tarefas para CRUD local.

import 'package:sqflite/sqflite.dart';
import 'database.dart';
import '../models/task.dart';

class TaskDao {
  Future<void> insert(TaskModel task) async {
    final db = await AppDatabase.database;
    await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TaskModel>> listAll() async {
    final db = await AppDatabase.database;
    final rows = await db.query('tasks', orderBy: 'created_at DESC');
    return rows.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<void> update(TaskModel task) async {
    final db = await AppDatabase.database;
    await db.update('tasks', task.toMap(),
        where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> delete(String id) async {
    final db = await AppDatabase.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}