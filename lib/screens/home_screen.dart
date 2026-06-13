import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';
import 'feed_screen.dart';
import 'academia_screen.dart';
import 'macro_screen.dart';
import 'tasks_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';
import 'notifications_screen.dart';
import 'hub_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final tabs = <_TabItem>[
      _TabItem(
        icon: Icons.feed_outlined,
        activeIcon: Icons.feed,
        label: 'Feed',
        screen: const FeedScreen(),
      ),
      _TabItem(
        icon: Icons.school_outlined,
        activeIcon: Icons.school,
        label: 'Academia',
        screen: const AcademiaScreen(),
      ),
      _TabItem(
        icon: Icons.show_chart_outlined,
        activeIcon: Icons.show_chart,
        label: 'Macro',
        screen: const MacroScreen(),
      ),
      _TabItem(
        icon: Icons.task_alt_outlined,
        activeIcon: Icons.task_alt,
        label: 'Tareas',
        screen: const TasksScreen(),
      ),
      _TabItem(
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble,
        label: 'Chat',
        screen: const ChatListScreen(),
      ),
      _TabItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Perfil',
        screen: const ProfileScreen(),
      ),
    ];

    final isAdmin = auth.isAdmin;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'T.N.S.V.T',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                color: AppTheme.goldBright,
              ),
            ),
            Text(
              'Reino del Cristo Íntegro',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 10,
                color: AppTheme.violet,
                letterSpacing: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_tree_outlined),
            tooltip: 'Hub Central',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const HubScreen()));
            },
          ),
          ValueListenableBuilder<int>(
            valueListenable: NotificationService.instance.unreadCount,
            builder: (context, count, _) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
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
                          border: Border.all(color: AppTheme.surface, width: 1.5),
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
        ],
      ),
      body: tabs[_currentIndex].screen,
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AdminScreen()));
              },
              backgroundColor: AppTheme.gold,
              foregroundColor: Colors.black,
              child: const Icon(Icons.admin_panel_settings),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          for (final t in tabs)
            BottomNavigationBarItem(
              icon: Icon(t.icon),
              activeIcon: Icon(t.activeIcon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final Widget screen;

  _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.screen,
  });
}

