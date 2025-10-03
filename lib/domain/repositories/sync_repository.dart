// Repositório de sincronização: consome fila e chama a API Bitrix.

import 'dart:convert';
import '../../core/errors.dart';
import '../../data/bitrix/bitrix_api_service.dart';
import '../../data/local/sync_dao.dart';
import '../../data/models/sync_job.dart';

class SyncRepository {
  final SyncDao syncDao;
  final BitrixApiService api;
  final Future<String?> Function() getAccessToken;

  SyncRepository({
    required this.syncDao,
    required this.api,
    required this.getAccessToken,
  });

  Future<void> processQueue({int batch = 10}) async {
    final token = await getAccessToken();
    if (token == null) throw AuthError('Sem token para sincronização');

    final jobs = await syncDao.pending(limit: batch);
    for (final job in jobs) {
      try {
        final payload = jsonDecode(job.payload) as Map<String, dynamic>;
        await api.call(
          method: job.method,
          params: payload,
          accessToken: token,
        );
        await syncDao.markSuccess(job.id);
      } catch (e) {
        final attempts = job.attempts + 1;
        await syncDao.markError(job.id, e.toString(), attempts);
      }
    }
  }
}