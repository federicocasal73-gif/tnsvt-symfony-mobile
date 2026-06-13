import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/admin_provider.dart';
import 'admin_dashboard_tab.dart';
import 'admin_users_tab.dart';
import 'admin_tasks_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AdminProvider>();
      p.fetchDashboard();
      p.fetchUsers();
      p.fetchTasks();
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('⚙️ Panel Admin'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppTheme.gold,
          indicatorWeight: 2,
          labelColor: AppTheme.goldBright,
          unselectedLabelColor: AppTheme.textMuted,
          labelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'DASH'),
            Tab(icon: Icon(Icons.people), text: 'ALUMNOS'),
            Tab(icon: Icon(Icons.task), text: 'TAREAS'),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          AdminDashboardTab(),
          AdminUsersTab(),
          AdminTasksTab(),
        ],
      ),
    );
  }
}
