import 'package:flutter_test/flutter_test.dart';
import 'package:mini_taskhub/dashboard/task_model.dart';

void main() {
  test('Task fromJson works correctly', () {
    final json = {
      'id': '1',
      'title': 'Test Task',
      'is_completed': false,
    };

    final task = Task.fromJson(json);

    expect(task.id, '1');
    expect(task.title, 'Test Task');
    expect(task.isCompleted, false);
  });
}