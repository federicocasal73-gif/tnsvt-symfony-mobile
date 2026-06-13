import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';
import '../widgets/push_permission_banner.dart';
import 'home_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';
import 'notifications_screen.dart';
import 'trading_journal_screen.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _enterApp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

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
                            painter: _HubLinesPainter(pulse: _pulseAnim),
                          ),
                          ..._buildIlluminatedNodes(size),
                          _HexagonCenter(onTap: _enterApp),
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

  List<Widget> _buildIlluminatedNodes(double size) {
    final nodes = const [
      _NodeSpec(Alignment(-0.95, -0.55), 'PSICOLOGÍA\nBIOLÓGICA', Icons.psychology_outlined),
      _NodeSpec(Alignment(0.95, -0.55), 'ANÁLISIS DE\nLIQUIDEZ', Icons.water_drop_outlined),
      _NodeSpec(Alignment(-0.95, 0.55), 'FLUJO\nMACROECONÓMICO', Icons.public),
      _NodeSpec(Alignment(0.95, 0.55), 'FIBONACCI\nSAGRADO', Icons.auto_awesome),
      _NodeSpec(Alignment(0, 0.98), 'GATILLO 2 STEPS', Icons.flash_on),
    ];
    return [
      for (int i = 0; i < nodes.length; i++)
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (context, _) {
            final phase = (i / nodes.length);
            final t = (_pulseAnim.value + phase) % 1.0;
            final glow = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.0, 1.0);
            return _Node(
              alignment: nodes[i].alignment,
              label: nodes[i].label,
              icon: nodes[i].icon,
              glow: glow,
            );
          },
        ),
    ];
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _NodeSpec {
  final Alignment alignment;
  final String label;
  final IconData icon;
  const _NodeSpec(this.alignment, this.label, this.icon);
}

class _HexagonCenter extends StatelessWidget {
  final VoidCallback onTap;
  const _HexagonCenter({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppTheme.goldBright.withOpacity(0.35),
              AppTheme.violet.withOpacity(0.20),
              Colors.transparent,
            ],
          ),
        ),
        child: Center(
          child: Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.goldBright, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.goldBright.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
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
                  SizedBox(height: 4),
                  Text(
                    'TOCA PARA ENTRAR',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 7,
                      color: AppTheme.violet,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
  final double glow;

  const _Node({
    required this.alignment,
    required this.label,
    required this.icon,
    required this.glow,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(
            color: AppTheme.violet.withOpacity(0.3 + 0.4 * glow),
            width: 1 + glow,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppTheme.violet.withOpacity(0.15 + 0.35 * glow),
              blurRadius: 8 + 12 * glow,
              spreadRadius: 1 + 2 * glow,
            ),
            BoxShadow(
              color: AppTheme.goldBright.withOpacity(0.1 * glow),
              blurRadius: 14 * glow,
              spreadRadius: 1 * glow,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Color.lerp(AppTheme.textMuted, AppTheme.goldBright, glow),
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppTheme.labelFont,
                fontSize: 8,
                color: Color.lerp(AppTheme.textMuted, AppTheme.goldBright, glow),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HubLinesPainter extends CustomPainter {
  final Animation<double> pulse;
  _HubLinesPainter({required this.pulse}) : super(repaint: pulse);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final nodes = [
      const Alignment(-0.95, -0.55),
      const Alignment(0.95, -0.55),
      const Alignment(-0.95, 0.55),
      const Alignment(0.95, 0.55),
      const Alignment(0, 0.98),
    ];

    final god = Offset(center.dx, center.dy - size.height * 0.42);

    for (int i = 0; i < nodes.length; i++) {
      final n = nodes[i];
      final dx = center.dx + n.x * size.width / 2;
      final dy = center.dy + n.y * size.height / 2;
      final p = Offset(dx, dy);

      final phase = (i / nodes.length);
      final t = (pulse.value + phase) % 1.0;
      final glow = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = Color.lerp(
          AppTheme.violet.withOpacity(0.18),
          AppTheme.goldBright.withOpacity(0.6),
          glow,
        )!
        ..strokeWidth = 0.8 + 1.4 * glow
        ..style = PaintingStyle.stroke;

      canvas.drawLine(god, p, paint);
      canvas.drawLine(center, p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
