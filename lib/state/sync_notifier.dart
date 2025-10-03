// Estado de sincronização: dispara processamento da fila.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/sync_repository.dart';

class SyncState {
  final bool syncing;
  final String? lastResult;

  SyncState({required this.syncing, this.lastResult});

  SyncState copyWith({bool? syncing, String? lastResult}) {
    return SyncState(
      syncing: syncing ?? this.syncing,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  static SyncState initial() => SyncState(syncing: false);
}

class SyncNotifier extends StateNotifier<SyncState> {
  final SyncRepository _repo;

  SyncNotifier(this._repo) : super(SyncState.initial());

  Future<void> sync() async {
    state = state.copyWith(syncing: true, lastResult: null);
    try {
      await _repo.processQueue(batch: 20);
      state = state.copyWith(syncing: false, lastResult: 'Sincronização concluída');
    } catch (e) {
      state = state.copyWith(syncing: false, lastResult: 'Erro: $e');
    }
  }
}