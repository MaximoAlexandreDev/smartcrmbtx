// Estado de tarefas (lista e criação).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/repositories/task_repository.dart';
import '../data/models/task.dart';

class TaskState {
  final List<TaskModel> items;
  final bool loading;
  final String? error;

  TaskState({
    required this.items,
    required this.loading,
    this.error,
  });

  TaskState copyWith({
    List<TaskModel>? items,
    bool? loading,
    String? error,
  }) {
    return TaskState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  static TaskState initial() => TaskState(items: [], loading: false);
}

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _repo;

  TaskNotifier(this._repo) : super(TaskState.initial()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final tasks = await _repo.listLocal();
      state = state.copyWith(items: tasks, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> create(String title, {String? description}) async {
    try {
      await _repo.createLocal(title: title, description: description);
      await load();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}