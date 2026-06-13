import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import '../services/notification_service.dart';

class PushPermissionBanner extends StatefulWidget {
  const PushPermissionBanner({super.key});

  @override
  State<PushPermissionBanner> createState() => _PushPermissionBannerState();
}

class _PushPermissionBannerState extends State<PushPermissionBanner> {
  static const _dismissKey = 'push_banner_dismissed_v1';
  bool _dismissed = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _dismissed = prefs.getBool(_dismissKey) ?? false;
      _loading = false;
    });
  }

  Future<void> _dismissForever() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissKey, true);
    if (!mounted) return;
    setState(() => _dismissed = true);
  }

  Future<void> _enable() async {
    final ok = await NotificationService.instance.requestPermission();
    if (!mounted) return;
    if (ok) {
      await _dismissForever();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _dismissed) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.violet.withOpacity(0.12),
        border: Border.all(color: AppTheme.violet.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined, color: AppTheme.goldBright, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Activá notificaciones para recibir alertas de señales y mensajes incluso con la app cerrada.',
              style: TextStyle(
                fontFamily: AppTheme.labelFont,
                color: AppTheme.textPrimary,
                fontSize: 10,
                letterSpacing: 0.5,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: _enable,
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.gold,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              minimumSize: const Size(0, 0),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('ACTIVAR',
                style: TextStyle(
                    fontFamily: AppTheme.labelFont,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: _dismissForever,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              minimumSize: const Size(0, 0),
            ),
            child: Text('AHORA NO',
                style: TextStyle(
                    fontFamily: AppTheme.labelFont,
                    color: AppTheme.textMuted,
                    fontSize: 9,
                    letterSpacing: 1)),
          ),
        ],
      ),
    );
  }
}
