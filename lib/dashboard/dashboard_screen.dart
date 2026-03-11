import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import 'task_tile.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini TaskHub"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              final notifier = ref.read(themeProvider.notifier);
              notifier.state =
                  notifier.state == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
            },
          ),
          IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    await Supabase.instance.client.auth.signOut();
  },
),
        ],
      ),
      body: taskState.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text("Error: $e")),
        data: (tasks) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: tasks.isEmpty
              ? Center(
    key: const ValueKey("empty"),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.task_alt,
          size: 80,
          color: Theme.of(context)
              .colorScheme
              .primary
              .withOpacity(0.5),
        ),
        const SizedBox(height: 16),
        const Text(
          "No Tasks Yet",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Tap + to create your first task",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
)
              : RefreshIndicator(
  onRefresh: () =>
      ref.read(taskProvider.notifier).fetchTasks(),
  child: ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: tasks.length,
    itemBuilder: (context, index) {
      final task = tasks[index];

      return TaskTile(
        task: task,
        onDelete: () =>
            ref.read(taskProvider.notifier).deleteTask(task.id),
        onToggle: () =>
            ref.read(taskProvider.notifier).toggleTask(task),
      );
    },
  ),
)
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: ModalRoute.of(dialogContext)!.animation!,
            curve: Curves.easeOutBack,
          ),
          child: AlertDialog(
            title: const Text("Add Task"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter task title",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (controller.text.trim().isEmpty) return;

                  await ref
                      .read(taskProvider.notifier)
                      .addTask(controller.text.trim());

                  Navigator.pop(dialogContext);
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }
}