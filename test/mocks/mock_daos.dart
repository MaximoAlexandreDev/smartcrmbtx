// Copyright (c) Maximo Tecnologia 2025
// Mock classes para testes

import 'package:smart_bitrix24/data/local/task_dao.dart';
import 'package:smart_bitrix24/data/local/sync_dao.dart';
import 'package:smart_bitrix24/data/models/task.dart';
import 'package:smart_bitrix24/data/models/sync_job.dart';

class MockTaskDao extends TaskDao {
  bool insertCalled = false;
  List<TaskModel> tasks = [];

  @override
  Future<void> insert(TaskModel task) async {
    insertCalled = true;
    tasks.add(task);
  }

  @override
  Future<List<TaskModel>> listAll() async {
    return tasks;
  }
}

class MockSyncDao extends SyncDao {
  bool enqueueCalled = false;
  bool markSuccessCalled = false;
  bool markErrorCalled = false;
  List<SyncJob> jobs = [];

  @override
  Future<void> enqueue(SyncJob job) async {
    enqueueCalled = true;
    jobs.add(job);
  }

  @override
  Future<List<SyncJob>> pending({int limit = 10}) async {
    return jobs.where((j) => j.status == 'PENDING').take(limit).toList();
  }

  @override
  Future<void> markSuccess(String id) async {
    markSuccessCalled = true;
    final index = jobs.indexWhere((j) => j.id == id);
    if (index != -1) {
      jobs[index] = SyncJob(
        id: jobs[index].id,
        method: jobs[index].method,
        payload: jobs[index].payload,
        status: 'SUCCESS',
        attempts: jobs[index].attempts,
        createdAt: jobs[index].createdAt,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  @override
  Future<void> markError(String id, String error, int attempts) async {
    markErrorCalled = true;
    final index = jobs.indexWhere((j) => j.id == id);
    if (index != -1) {
      jobs[index] = SyncJob(
        id: jobs[index].id,
        method: jobs[index].method,
        payload: jobs[index].payload,
        status: 'ERROR',
        attempts: attempts,
        createdAt: jobs[index].createdAt,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        error: error,
      );
    }
  }
}
