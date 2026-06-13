import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final userCode = auth.userCode;
    if (userCode == null) {
      setState(() => _loading = false);
      return;
    }
    final list = await NotificationService.instance.fetchAll(userCode);
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  Future<void> _markAllAsRead() async {
    final auth = context.read<AuthProvider>();
    final userCode = auth.userCode;
    if (userCode == null) return;
    await NotificationService.instance.markAllAsRead(userCode);
    if (!mounted) return;
    setState(() {
      _items = _items.map((n) => {...n, 'read': true}).toList();
    });
  }

  Future<void> _onTapItem(Map<String, dynamic> notif) async {
    final id = notif['id'] as int?;
    if (id != null) {
      await NotificationService.instance.markAsRead(id);
    }
    if (!mounted) return;
    setState(() {
      final idx = _items.indexWhere((n) => n['id'] == id);
      if (idx != -1) {
        _items[idx] = {..._items[idx], 'read': true};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          if (_items.any((n) => n['read'] == false))
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Marcar leídas',
                style: TextStyle(color: AppTheme.goldBright),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppTheme.goldBright,
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.goldBright))
            : _items.isEmpty
                ? _Empty()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => Divider(
                      color: AppTheme.textMuted.withOpacity(0.15),
                      height: 1,
                    ),
                    itemBuilder: (context, i) {
                      final n = _items[i];
                      return _NotifTile(notif: n, onTap: () => _onTapItem(n));
                    },
                  ),
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final Map<String, dynamic> notif;
  final VoidCallback onTap;
  const _NotifTile({required this.notif, required this.onTap});

  IconData get _icon {
    switch (notif['type']) {
      case 'dm':
        return Icons.chat_bubble_outline;
      case 'comment':
        return Icons.comment_outlined;
      case 'mention':
        return Icons.alternate_email;
      case 'task':
        return Icons.task_alt_outlined;
      case 'academia':
        return Icons.school_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color get _color {
    switch (notif['type']) {
      case 'dm':
        return AppTheme.violet;
      case 'comment':
        return AppTheme.goldBright;
      case 'mention':
        return AppTheme.goldBright;
      case 'task':
        return AppTheme.warning;
      case 'academia':
        return AppTheme.success;
      default:
        return AppTheme.textSecondary;
    }
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'ahora';
      if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'hace ${diff.inHours} h';
      if (diff.inDays < 7) return 'hace ${diff.inDays} d';
      return DateFormat('dd/MM HH:mm').format(dt);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRead = notif['read'] == true;
    return Material(
      color: isRead ? AppTheme.background : AppTheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(_icon, color: _color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notif['text'] ?? '',
                      style: TextStyle(
                        color: isRead ? AppTheme.textSecondary : AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notif['ts']),
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              if (!isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 14),
                  decoration: const BoxDecoration(
                    color: AppTheme.goldBright,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        const Icon(Icons.notifications_off_outlined, color: AppTheme.textMuted, size: 64),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'No tenés notificaciones',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
