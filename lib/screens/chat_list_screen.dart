import 'package:flutter/material.dart';
import '../config/theme.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💬 Chat de Ejecutores')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble, size: 64, color: AppTheme.violet),
            SizedBox(height: 16),
            Text('Chat', style: TextStyle(color: AppTheme.goldBright, fontSize: 20)),
            SizedBox(height: 8),
            Text('Próximamente...', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}

