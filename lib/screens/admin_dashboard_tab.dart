import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/admin_provider.dart';

class AdminDashboardTab extends StatelessWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    if (admin.loading && admin.dashboard == null) {
      return Material(
        color: AppTheme.background,
        child: const Center(
          child: CircularProgressIndicator(color: AppTheme.gold),
        ),
      );
    }
    final d = admin.dashboard;
    if (d == null) {
      return Material(
        color: AppTheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
              const SizedBox(height: 12),
              Text('Error: ${admin.error ?? "sin datos"}',
                  style: const TextStyle(color: AppTheme.danger)),
            ],
          ),
        ),
      );
    }

    return Material(
      color: AppTheme.background,
      child: RefreshIndicator(
        onRefresh: () => admin.fetchDashboard(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.6,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _statCard('Total', d.totalUsers, AppTheme.goldBright, Icons.people),
                _statCard('Activos', d.activeUsers, AppTheme.success, Icons.check_circle),
                _statCard('Inactivos', d.inactiveUsers, AppTheme.danger, Icons.block),
                _statCard('Alumnos', d.students, AppTheme.violet, Icons.school),
              ],
            ),
            const SizedBox(height: 24),
            const Text('ÚLTIMOS ACCESOS',
                style: TextStyle(
                  color: AppTheme.gold,
                  fontSize: 11,
                  letterSpacing: 2,
                )),
            const SizedBox(height: 8),
            if (d.recentLogins.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('Sin accesos recientes',
                      style: TextStyle(color: AppTheme.textMuted)),
                ),
              )
            else
              ...d.recentLogins.map((r) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: r.code == 'ADMIN01'
                            ? AppTheme.gold
                            : AppTheme.violet,
                        child: Text(
                          r.name.isNotEmpty ? r.name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                            Text(r.code,
                                style: const TextStyle(
                                  color: AppTheme.textMuted,
                                  fontSize: 10,
                                )),
                          ],
                        ),
                      ),
                      if (r.lastLogin != null)
                        Text(r.lastLogin!,
                            style: const TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 10,
                            )),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(label.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  )),
            ],
          ),
          Text('$value',
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
