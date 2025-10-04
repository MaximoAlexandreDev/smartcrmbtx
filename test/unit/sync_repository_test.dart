// Copyright (c) Maximo Tecnologia 2025
// Testes unitários para SyncRepository

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bitrix24/domain/repositories/sync_repository.dart';
import 'package:smart_bitrix24/data/models/sync_job.dart';
import 'package:smart_bitrix24/core/errors.dart';
import '../mocks/mock_daos.dart';
import '../mocks/mock_api_service.dart';

void main() {
  group('SyncRepository', () {
    late SyncRepository repository;
    late MockSyncDao mockSyncDao;
    late MockBitrixApiService mockApiService;

    setUp(() {
      mockSyncDao = MockSyncDao();
      mockApiService = MockBitrixApiService();
      repository = SyncRepository(
        syncDao: mockSyncDao,
        api: mockApiService,
        getAccessToken: () async => 'test_token',
      );
    });

    test('processQueue lança AuthError quando não há token', () async {
      final repoWithoutToken = SyncRepository(
        syncDao: mockSyncDao,
        api: mockApiService,
        getAccessToken: () async => null,
      );

      expect(
        () => repoWithoutToken.processQueue(),
        throwsA(isA<AuthError>()),
      );
    });

    test('processQueue processa jobs pendentes com sucesso', () async {
      mockSyncDao.jobs = [
        SyncJob(
          id: '1',
          method: 'tasks.task.add',
          payload: '{"fields": {"TITLE": "Test"}}',
          status: 'PENDING',
          attempts: 0,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];

      await repository.processQueue();

      expect(mockApiService.callCalled, isTrue);
      expect(mockSyncDao.markSuccessCalled, isTrue);
    });

    test('processQueue marca erro quando API falha', () async {
      mockSyncDao.jobs = [
        SyncJob(
          id: '1',
          method: 'tasks.task.add',
          payload: '{"fields": {"TITLE": "Test"}}',
          status: 'PENDING',
          attempts: 0,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      
      mockApiService.shouldFail = true;

      await repository.processQueue();

      expect(mockApiService.callCalled, isTrue);
      expect(mockSyncDao.markErrorCalled, isTrue);
    });

    test('processQueue respeita limite de batch', () async {
      // Criar 15 jobs pendentes
      for (int i = 0; i < 15; i++) {
        mockSyncDao.jobs.add(
          SyncJob(
            id: '$i',
            method: 'tasks.task.add',
            payload: '{"fields": {"TITLE": "Test $i"}}',
            status: 'PENDING',
            attempts: 0,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            updatedAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }

      await repository.processQueue(batch: 5);

      // Deve processar apenas 5
      expect(mockApiService.callCount, equals(5));
    });
  });
}
