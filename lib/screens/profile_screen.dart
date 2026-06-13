import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  ({String codename, String status, IconData icon, Color color}) _persona(
      String code, bool isAdmin) {
    if (isAdmin) {
      return (
        codename: 'Administrador Soberano',
        status: 'Conexión Soberana',
        icon: Icons.workspace_premium,
        color: AppTheme.gold,
      );
    }
    if (code.startsWith('EXEC')) {
      return (
        codename: 'Ejecutor Sagrado',
        status: 'Conexión Activa',
        icon: Icons.flash_on,
        color: AppTheme.gold,
      );
    }
    if (code == 'DEMO') {
      return (
        codename: 'Alma Electa',
        status: 'Conexión Divina',
        icon: Icons.auto_awesome,
        color: AppTheme.violet,
      );
    }
    return (
      codename: 'Alma en Forja',
      status: 'Conexión en Crecimiento',
      icon: Icons.local_fire_department,
      color: AppTheme.violet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final isAdmin = auth.isAdmin;
    final code = user?.code ?? '';
    final persona = _persona(code, isAdmin);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(persona.icon, color: persona.color, size: 18),
            const SizedBox(width: 8),
            const Text('PERFIL'),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    persona.color.withOpacity(0.4),
                    persona.color.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surface,
                    border: Border.all(color: persona.color, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: persona.color.withOpacity(0.4),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontFamily: AppTheme.displayFont,
                        color: AppTheme.goldBright,
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              persona.codename,
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                color: persona.color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              persona.status,
              style: const TextStyle(
                fontFamily: AppTheme.labelFont,
                color: AppTheme.violet,
                fontSize: 11,
                letterSpacing: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${user?.name ?? ''} · ${user?.code ?? ''}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isAdmin
                    ? AppTheme.gold.withOpacity(0.2)
                    : AppTheme.violet.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isAdmin ? AppTheme.gold : AppTheme.violet,
                ),
              ),
              child: Text(
                isAdmin ? '👑 ADMIN' : 'ALUMNO',
                style: TextStyle(
                  color: isAdmin ? AppTheme.goldBright : AppTheme.violet,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline, color: AppTheme.gold),
              title: const Text('Versión',
                  style: TextStyle(color: AppTheme.textPrimary)),
              subtitle: const Text('T.N.S.V.T Mobile v0.7',
                  style: TextStyle(color: AppTheme.textSecondary)),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.api, color: AppTheme.violet),
              title: const Text('API Backend',
                  style: TextStyle(color: AppTheme.textPrimary)),
              subtitle: Text('http://10.0.2.2:8000',
                  style: TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await auth.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('CERRAR SESIÓN'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.danger,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

