// Providers globais (Riverpod) de serviços e estados.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/config.dart';
import '../data/bitrix/auth_service.dart';
import '../data/bitrix/bitrix_api_service.dart';
import '../data/local/sync_dao.dart';
import '../data/local/task_dao.dart';
import '../domain/repositories/sync_repository.dart';
import '../domain/repositories/task_repository.dart';
import 'auth_notifier.dart';
import 'sync_notifier.dart';
import 'task_notifier.dart';

// Serviços base
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final bitrixApiProvider = Provider<BitrixApiService>((ref) {
  return BitrixApiService(AppConfig.portalDomain);
});

// DAOs
final taskDaoProvider = Provider<TaskDao>((ref) => TaskDao());
final syncDaoProvider = Provider<SyncDao>((ref) => SyncDao());

// Repositórios
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.read(taskDaoProvider), ref.read(syncDaoProvider));
});

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  return SyncRepository(
    syncDao: ref.read(syncDaoProvider),
    api: ref.read(bitrixApiProvider),
    getAccessToken: () => ref.read(authServiceProvider).getAccessToken(),
  );
});

// Estados (notifiers)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref.read(syncRepositoryProvider));
});

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  return TaskNotifier(ref.read(taskRepositoryProvider));
});