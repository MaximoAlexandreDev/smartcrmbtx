// Copyright (c) Maximo Tecnologia 2025
// Testes unitários para TaskRepository

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bitrix24/domain/repositories/task_repository.dart';
import 'package:smart_bitrix24/data/models/task.dart';
import '../mocks/mock_daos.dart';

void main() {
  group('TaskRepository', () {
    late TaskRepository repository;
    late MockTaskDao mockTaskDao;
    late MockSyncDao mockSyncDao;

    setUp(() {
      mockTaskDao = MockTaskDao();
      mockSyncDao = MockSyncDao();
      repository = TaskRepository(mockTaskDao, mockSyncDao);
    });

    test('createLocal cria tarefa e enfileira sync job', () async {
      final task = await repository.createLocal(
        title: 'Test Task',
        description: 'Test Description',
      );

      expect(task.title, equals('Test Task'));
      expect(task.description, equals('Test Description'));
      expect(task.status, equals('open'));
      expect(task.id, isNotEmpty);
      expect(mockTaskDao.insertCalled, isTrue);
      expect(mockSyncDao.enqueueCalled, isTrue);
    });

    test('createLocal sem descrição funciona corretamente', () async {
      final task = await repository.createLocal(
        title: 'Test Task Without Description',
      );

      expect(task.title, equals('Test Task Without Description'));
      expect(task.description, isNull);
      expect(task.status, equals('open'));
      expect(mockTaskDao.insertCalled, isTrue);
      expect(mockSyncDao.enqueueCalled, isTrue);
    });

    test('listLocal retorna todas as tarefas', () async {
      mockTaskDao.tasks = [
        TaskModel(
          id: '1',
          title: 'Task 1',
          status: 'open',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
        TaskModel(
          id: '2',
          title: 'Task 2',
          status: 'closed',
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      final tasks = await repository.listLocal();
      expect(tasks.length, equals(2));
      expect(tasks[0].title, equals('Task 1'));
      expect(tasks[1].title, equals('Task 2'));
    });
  });
}
