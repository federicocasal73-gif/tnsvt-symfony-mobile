import 'package:flutter/material.dart';
import '../config/theme.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📰 Feed'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.feed, size: 64, color: AppTheme.gold.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text('Feed', style: TextStyle(color: AppTheme.goldBright, fontSize: 20)),
            const SizedBox(height: 8),
            const Text('Próximamente...',
                style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

