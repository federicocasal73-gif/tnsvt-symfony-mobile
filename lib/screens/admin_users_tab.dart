import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/admin.dart';
import '../providers/admin_provider.dart';

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();

    if (admin.loading && admin.users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () => admin.fetchUsers(),
          child: admin.users.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 80),
                    Center(
                      child: Column(
                        children: [
                          Icon(Icons.people,
                              size: 64, color: AppTheme.textMuted),
                          SizedBox(height: 8),
                          Text('No hay usuarios',
                              style: TextStyle(color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
                  itemCount: admin.users.length,
                  itemBuilder: (_, i) => _UserTile(user: admin.users[i]),
                ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.small(
            onPressed: () => _showUserForm(context, null),
            backgroundColor: AppTheme.gold,
            foregroundColor: Colors.black,
            child: const Icon(Icons.person_add),
          ),
        ),
      ],
    );
  }

  void _showUserForm(BuildContext context, AdminUser? user) {
    final admin = context.read<AdminProvider>();
    final codeCtrl = TextEditingController(text: user?.code ?? '');
    final nameCtrl = TextEditingController(text: user?.name ?? '');
    final isEdit = user != null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, 20 + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEdit ? '✏️ Editar usuario' : '➕ Nuevo alumno',
                style: const TextStyle(
                  color: AppTheme.goldBright,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            TextField(
              controller: codeCtrl,
              textCapitalization: TextCapitalization.characters,
              enabled: !isEdit,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Código',
                labelStyle: TextStyle(color: AppTheme.textMuted),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                labelStyle: TextStyle(color: AppTheme.textMuted),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final code = codeCtrl.text.trim().toUpperCase();
                    final name = nameCtrl.text.trim();
                    if (code.isEmpty || name.isEmpty) return;
                    final ok = isEdit
                        ? await admin.updateUser(user.id,
                            code: code, name: name)
                        : await admin.createUser(code, name);
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(isEdit
                                ? '✅ Usuario actualizado'
                                : '✅ Alumno creado')),
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
    );
  }
}

class _UserTile extends StatelessWidget {
  final AdminUser user;
  const _UserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.isAdmin;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: user.active
              ? (isAdmin ? AppTheme.gold : AppTheme.violet).withOpacity(0.2)
              : AppTheme.danger.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isAdmin ? AppTheme.gold : AppTheme.violet,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(user.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    if (isAdmin)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('👑',
                            style: TextStyle(fontSize: 9)),
                      ),
                  ],
                ),
                Text(user.code,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: user.active
                  ? AppTheme.success.withOpacity(0.15)
                  : AppTheme.danger.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              user.active ? '🟢' : '🔴',
              style: const TextStyle(fontSize: 10),
            ),
          ),
          if (!isAdmin)
            IconButton(
              icon: Icon(
                user.active ? Icons.lock : Icons.lock_open,
                color: user.active ? AppTheme.danger : AppTheme.success,
                size: 18,
              ),
              onPressed: () =>
                  context.read<AdminProvider>().toggleUserActive(user.id),
              tooltip: user.active ? 'Desactivar' : 'Activar',
            ),
        ],
      ),
    );
  }
}
