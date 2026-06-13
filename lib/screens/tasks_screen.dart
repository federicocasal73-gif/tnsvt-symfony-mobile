import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/task_item.dart';
import '../providers/tasks_provider.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final p = context.read<TasksProvider>();
      await p.init();
      if (p.tasks.isEmpty) await p.fetch();
    });
  }

  Future<void> _refresh() async {
    await context.read<TasksProvider>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('✍️ Tareas Operativas'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.gold),
              ),
              child: Text(
                '${tasks.doneCount} / ${tasks.total} completadas',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _build(tasks),
      ),
    );
  }

  Widget _build(TasksProvider tasks) {
    if (tasks.loading && tasks.tasks.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }
    if (tasks.error != null && tasks.tasks.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
                const SizedBox(height: 8),
                Text('Error: ${tasks.error}',
                    style: const TextStyle(color: AppTheme.danger),
                    textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _refresh,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ],
      );
    }
    if (tasks.tasks.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Icon(Icons.task_alt, size: 64, color: AppTheme.success),
                SizedBox(height: 8),
                Text('No hay tareas cargadas',
                    style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: tasks.tasks.length,
      itemBuilder: (_, i) => _TaskTile(task: tasks.tasks[i]),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final TaskItem task;
  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksProvider>();
    final isDone = tasks.isCompleted(task.id);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDone
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.violet.withOpacity(0.15),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => tasks.toggle(task.id),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Checkbox
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDone ? AppTheme.success : Colors.transparent,
                    border: Border.all(
                      color: isDone ? AppTheme.success : AppTheme.textMuted,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.black, size: 18)
                      : null,
                ),
                const SizedBox(width: 12),
                // Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.gold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#${task.orden}',
                              style: const TextStyle(
                                color: AppTheme.gold,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                color: isDone
                                    ? AppTheme.textMuted
                                    : AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                decoration: isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (task.description != null && task.description!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: TextStyle(
                            color: isDone
                                ? AppTheme.textMuted
                                : AppTheme.textSecondary,
                            fontSize: 12,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
