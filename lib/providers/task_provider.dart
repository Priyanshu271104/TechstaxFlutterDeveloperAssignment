import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

final taskProvider =
    StateNotifierProvider<TaskNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  TaskNotifier() : super(const AsyncLoading()) {
  _listenToTasks();
}
void _listenToTasks() {
  final user = _client.auth.currentUser;
  if (user == null) return;

  _client
      .from('tasks')
      .stream(primaryKey: ['id'])
      .eq('user_id', user.id)
      .listen((data) {
    final tasks = data.map((e) => Task.fromJson(e)).toList();
    state = AsyncData(tasks);
  });
}

  final _client = Supabase.instance.client;
  Future<void> updateTask(String id, String newTitle) async {
  await _client
      .from('tasks')
      .update({'title': newTitle})
      .eq('id', id);

  await fetchTasks();
}

  Future<void> fetchTasks() async {
    try {
      state = const AsyncLoading();

      final user = _client.auth.currentUser;
      if (user == null) return;

      final response = await _client
          .from('tasks')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: true);

      final tasks = (response as List)
          .map((e) => Task.fromJson(e))
          .toList();

      state = AsyncData(tasks);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addTask(String title) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('tasks').insert({
      'title': title,
      'user_id': user.id,
    });

    await fetchTasks();
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
    await fetchTasks();
  }

  Future<void> toggleTask(Task task) async {
    await _client
        .from('tasks')
        .update({'is_completed': !task.isCompleted})
        .eq('id', task.id);

    await fetchTasks();
  }
}