// Repositório de tarefas: orquestra dados locais e enfileira operações de sync.

import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../../core/logger.dart';
import '../..//data/local/task_dao.dart';
import '../..//data/local/sync_dao.dart';
import '../..//data/models/task.dart';
import '../..//data/models/sync_job.dart';

class TaskRepository {
  final TaskDao taskDao;
  final SyncDao syncDao;

  TaskRepository(this.taskDao, this.syncDao);

  Future<TaskModel> createLocal({
    required String title,
    String? description,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final task = TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      status: 'open',
      createdAt: now,
      updatedAt: now,
    );
    await taskDao.insert(task);

    // Enfileirar criação remota no Bitrix (tasks.task.add)
    final job = SyncJob(
      id: const Uuid().v4(),
      method: 'tasks.task.add',
      payload: jsonEncode({
        'fields': {
          'TITLE': title,
          if (description != null) 'DESCRIPTION': description,
        }
      }),
      status: 'PENDING',
      attempts: 0,
      createdAt: now,
      updatedAt: now,
    );
    await syncDao.enqueue(job);

    logI('Tarefa criada localmente e enfileirada para sync');
    return task;
  }

  Future<List<TaskModel>> listLocal() => taskDao.listAll();
}