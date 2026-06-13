import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';
import '../widgets/push_permission_banner.dart';
import 'feed_screen.dart';
import 'academia_screen.dart';
import 'macro_screen.dart';
import 'tasks_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';
import 'notifications_screen.dart';
import 'trading_journal_screen.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.isAdmin;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('HUB CENTRAL'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Desconectar',
          onPressed: () async {
            await auth.logout();
            if (context.mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            }
          },
        ),
        actions: [
          ValueListenableBuilder<int>(
            valueListenable: NotificationService.instance.unreadCount,
            builder: (context, count, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    tooltip: 'Notificaciones',
                    onPressed: () async {
                      final userCode = context.read<AuthProvider>().userCode;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                      );
                      if (userCode != null) {
                        await NotificationService.instance.refreshUnreadCount(userCode);
                      }
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppTheme.danger,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: AppTheme.background, width: 1.5),
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat',
            onPressed: () => _go(context, const ChatListScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.assessment_outlined),
            tooltip: 'Trading Journal',
            onPressed: () => _go(context, const TradingJournalScreen()),
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined, color: AppTheme.gold),
              tooltip: 'Panel Admin',
              onPressed: () => _go(context, const AdminScreen()),
            ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil',
            onPressed: () => _go(context, const ProfileScreen()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const PushPermissionBanner(),
            const SizedBox(height: 8),
            Text(
              'Dios / Identidad',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 12,
                color: AppTheme.violet,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest.shortestSide.clamp(280.0, 500.0);
                  return Center(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: Size(size, size),
                            painter: _HubLinesPainter(),
                          ),
                          const _HexagonCenter(),
                          _Node(
                            alignment: const Alignment(-0.95, -0.55),
                            label: 'PSICOLOGÍA\nBIOLÓGICA',
                            icon: Icons.psychology_outlined,
                            onTap: () => _go(context, const FeedScreen()),
                          ),
                          _Node(
                            alignment: const Alignment(0.95, -0.55),
                            label: 'ANÁLISIS DE\nLIQUIDEZ',
                            icon: Icons.water_drop_outlined,
                            onTap: () => _go(context, const MacroScreen()),
                          ),
                          _Node(
                            alignment: const Alignment(-0.95, 0.55),
                            label: 'FLUJO\nMACROECONÓMICO',
                            icon: Icons.public,
                            onTap: () => _go(context, const MacroScreen()),
                          ),
                          _Node(
                            alignment: const Alignment(0.95, 0.55),
                            label: 'FIBONACCI\nSAGRADO',
                            icon: Icons.auto_awesome,
                            onTap: () => _go(context, const AcademiaScreen()),
                          ),
                          _Node(
                            alignment: const Alignment(0, 0.98),
                            label: 'GATILLO 2 STEPS',
                            icon: Icons.flash_on,
                            onTap: () => _go(context, const TasksScreen()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'T.N.S.V.T',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 28,
                color: AppTheme.goldBright,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Domina tu mente. Regula tu cuerpo. Ejecuta con fe.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.labelFont,
                  fontSize: 10,
                  color: AppTheme.textMuted,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _HexagonCenter extends StatelessWidget {
  const _HexagonCenter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppTheme.goldBright.withOpacity(0.25),
            AppTheme.violet.withOpacity(0.15),
            Colors.transparent,
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.goldBright, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.goldBright.withOpacity(0.3),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '✝',
                  style: TextStyle(
                    fontFamily: AppTheme.displayFont,
                    fontSize: 30,
                    color: AppTheme.goldBright,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'EL CRISTO',
                  style: TextStyle(
                    fontFamily: AppTheme.displayFont,
                    fontSize: 11,
                    color: AppTheme.goldBright,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ÍNTEGRO',
                  style: TextStyle(
                    fontFamily: AppTheme.displayFont,
                    fontSize: 11,
                    color: AppTheme.goldBright,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
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

class _Node extends StatelessWidget {
  final Alignment alignment;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _Node({
    required this.alignment,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.violet.withOpacity(0.4)),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppTheme.violet.withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppTheme.goldBright, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppTheme.labelFont,
                  fontSize: 8,
                  color: AppTheme.goldBright,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppTheme.violet.withOpacity(0.25)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    final nodes = [
      const Alignment(-0.95, -0.55),
      const Alignment(0.95, -0.55),
      const Alignment(-0.95, 0.55),
      const Alignment(0.95, 0.55),
      const Alignment(0, 0.98),
    ];

    final god = Offset(center.dx, center.dy - size.height * 0.42);

    for (final n in nodes) {
      final dx = center.dx + n.x * size.width / 2;
      final dy = center.dy + n.y * size.height / 2;
      final p = Offset(dx, dy);
      canvas.drawLine(god, p, paint);
      canvas.drawLine(center, p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
