import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/task_item.dart';
import '../providers/admin_provider.dart';

class AdminTasksTab extends StatelessWidget {
  const AdminTasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    return Material(
      color: AppTheme.background,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () => admin.fetchTasks(),
            child: admin.loading && admin.tasks.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.gold),
                  )
                : admin.tasks.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 80),
                          Center(
                            child: Column(
                              children: [
                                Icon(Icons.task,
                                    size: 64, color: AppTheme.textMuted),
                                SizedBox(height: 8),
                                Text('No hay tareas',
                                    style:
                                        TextStyle(color: AppTheme.textSecondary)),
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                        itemCount: admin.tasks.length,
                        itemBuilder: (_, i) => _TaskTile(
                          task: admin.tasks[i],
                          onEdit: (ctx, t) => _showTaskForm(ctx, t),
                        ),
                      ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.small(
              onPressed: () => _showTaskForm(context, null),
              backgroundColor: AppTheme.gold,
              foregroundColor: Colors.black,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskForm(BuildContext context, TaskItem? task) {
    final admin = context.read<AdminProvider>();
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    final ordenCtrl = TextEditingController(text: '${task?.orden ?? 99}');
    bool active = task?.active ?? true;
    final isEdit = task != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
              20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isEdit ? '✏️ Editar tarea' : '➕ Nueva tarea',
                  style: const TextStyle(
                    color: AppTheme.goldBright,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ordenCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  labelText: 'Orden',
                  labelStyle: TextStyle(color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: active,
                onChanged: (v) => setState(() => active = v),
                title: const Text('Activa',
                    style: TextStyle(color: AppTheme.textPrimary)),
                activeColor: AppTheme.gold,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEdit)
                    TextButton.icon(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: ctx,
                          builder: (_) => AlertDialog(
                            title: const Text('¿Eliminar?'),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, false),
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, true),
                                  child: const Text('Sí',
                                      style: TextStyle(
                                          color: AppTheme.danger))),
                            ],
                          ),
                        );
                        if (confirm == true && ctx.mounted) {
                          Navigator.pop(ctx);
                          await admin.deleteTask(task.id);
                        }
                      },
                      icon: const Icon(Icons.delete,
                          color: AppTheme.danger),
                      label: const Text('Eliminar',
                          style: TextStyle(color: AppTheme.danger)),
                    ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final title = titleCtrl.text.trim();
                      if (title.isEmpty) return;
                      final orden = int.tryParse(ordenCtrl.text) ?? 99;
                      bool ok;
                      if (isEdit) {
                        ok = await admin.updateTask(task.id,
                            title: title,
                            description: descCtrl.text.trim(),
                            orden: orden,
                            active: active);
                      } else {
                        ok = await admin.createTask(
                            title, descCtrl.text.trim(), orden, active);
                      }
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(isEdit
                                  ? '✅ Tarea actualizada'
                                  : '✅ Tarea creada')),
                        );
                      }
                    },
                    child: Text(isEdit ? 'Guardar' : 'Crear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final TaskItem task;
  final void Function(BuildContext, TaskItem) onEdit;

  const _TaskTile({required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: task.active
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.danger.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('#${task.orden}',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    color: task.active
                        ? AppTheme.textPrimary
                        : AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    decoration: task.active
                        ? null
                        : TextDecoration.lineThrough,
                  ),
                ),
                if (task.description != null && task.description!.isNotEmpty)
                  Text(task.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      )),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              task.active ? Icons.lock : Icons.lock_open,
              color: task.active ? AppTheme.danger : AppTheme.success,
              size: 18,
            ),
            onPressed: () =>
                context.read<AdminProvider>().toggleTaskActive(task.id),
            tooltip: task.active ? 'Desactivar' : 'Activar',
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.gold, size: 18),
            onPressed: () => onEdit(context, task),
            tooltip: 'Editar',
          ),
        ],
      ),
    );
  }
}
