import 'package:flutter/material.dart';
import '../config/theme.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ Panel Admin')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.admin_panel_settings, size: 64, color: AppTheme.gold),
            SizedBox(height: 16),
            Text('Panel Admin', style: TextStyle(color: AppTheme.goldBright, fontSize: 20)),
            SizedBox(height: 8),
            Text('Próximamente...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

