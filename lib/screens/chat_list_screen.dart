import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/chat.dart';
import '../providers/chat_provider.dart';
import 'chat_room_screen.dart';
import 'chat_new_dm_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<ChatProvider>();
      if (p.conversations.isEmpty) p.loadConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('💬 Chat de Ejecutores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatNewDmScreen()),
              );
              if (mounted) {
                await context.read<ChatProvider>().loadConversations();
              }
            },
            tooltip: 'Nuevo mensaje',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<ChatProvider>().loadConversations(),
        child: _build(chat),
      ),
    );
  }

  Widget _build(ChatProvider chat) {
    if (chat.loading && chat.conversations.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }
    if (chat.conversations.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                const Icon(Icons.chat_bubble,
                    size: 64, color: AppTheme.violet),
                const SizedBox(height: 8),
                const Text('No hay conversaciones',
                    style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: chat.conversations.length,
      itemBuilder: (_, i) => _ConvTile(conv: chat.conversations[i]),
    );
  }
}

class _ConvTile extends StatelessWidget {
  final ChatConversation conv;
  const _ConvTile({required this.conv});

  @override
  Widget build(BuildContext context) {
    final preview = conv.lastMessage;
    String previewText = '—';
    if (preview != null) {
      final sender = preview.senderName ?? '';
      if (preview.photo != null) {
        previewText = sender.isNotEmpty ? '$sender: 📷 Foto' : '📷 Foto';
      } else if (preview.content.isNotEmpty) {
        previewText = sender.isNotEmpty
            ? '$sender: ${preview.content}'
            : preview.content;
      }
    }

    final initial = conv.displayName.isNotEmpty
        ? conv.displayName[0].toUpperCase()
        : '?';
    final isGroup = conv.isGroup;
    final unread = conv.unreadCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatRoomScreen(conv: conv)),
            );
            if (context.mounted) {
              await context.read<ChatProvider>().loadConversations();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      isGroup ? AppTheme.gold : AppTheme.violet,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isGroup)
                            const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.group, color: AppTheme.gold, size: 12),
                            ),
                          Expanded(
                            child: Text(
                              conv.displayName,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        previewText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: unread > 0
                              ? AppTheme.textPrimary
                              : AppTheme.textMuted,
                          fontSize: 12,
                          fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (unread > 0)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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
