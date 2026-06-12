import 'package:flutter/material.dart';
import '../config/theme.dart';

class AcademiaScreen extends StatelessWidget {
  const AcademiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎓 Academia')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: AppTheme.violet),
            SizedBox(height: 16),
            Text('Academia', style: TextStyle(color: AppTheme.goldBright, fontSize: 20)),
            SizedBox(height: 8),
            Text('Próximamente...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

