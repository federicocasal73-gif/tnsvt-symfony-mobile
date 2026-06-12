import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import 'feed_screen.dart';
import 'academia_screen.dart';
import 'tasks_screen.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';
import 'admin_screen.dart';

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

