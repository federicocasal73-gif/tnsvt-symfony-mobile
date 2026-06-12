import 'package:flutter/material.dart';
import '../config/theme.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✍️ Tareas Operativas')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: AppTheme.success),
            SizedBox(height: 16),
            Text('Tareas', style: TextStyle(color: AppTheme.goldBright, fontSize: 20)),
            SizedBox(height: 8),
            Text('Próximamente...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

