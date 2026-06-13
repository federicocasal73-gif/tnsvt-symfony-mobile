import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/chat.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../services/api_service.dart';
import 'chat_room_screen.dart';

class ChatNewDmScreen extends StatefulWidget {
  const ChatNewDmScreen({super.key});

  @override
  State<ChatNewDmScreen> createState() => _ChatNewDmScreenState();
}

class _ChatNewDmScreenState extends State<ChatNewDmScreen> {
  final _searchCtrl = TextEditingController();
  List<ChatUser> _users = [];
  List<ChatUser> _filtered = [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    setState(() => _loading = true);
    try {
      final api = context.read<ApiService>();
      final data = await api.get('/api/chat/users',
          query: {'user_code': user.code});
      if (data is List) {
        _users = data
            .whereType<Map<String, dynamic>>()
            .map((j) => ChatUser.fromJson(j))
            .toList();
        _filtered = _users.where((u) => !u.isMe).toList();
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  void _filter(String q) {
    _query = q.toLowerCase();
    setState(() {
      _filtered = _users
          .where((u) => !u.isMe)
          .where((u) =>
              _query.isEmpty ||
              u.name.toLowerCase().contains(_query) ||
              u.code.toLowerCase().contains(_query))
          .toList();
    });
  }

  Future<void> _select(ChatUser u) async {
    final chat = context.read<ChatProvider>();
    final conv = await chat.startDmWith(u.code);
    if (!mounted) return;
    if (conv == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ No se pudo crear la conversación')),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ChatRoomScreen(conv: conv)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('✉️ Nuevo mensaje')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchCtrl,
              autofocus: true,
              onChanged: _filter,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Buscar usuario...',
                hintStyle: TextStyle(color: AppTheme.textMuted),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          const Divider(color: AppTheme.surfaceLight, height: 1),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }
    if (_filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'No hay usuarios disponibles',
            style: TextStyle(color: AppTheme.textMuted),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: _filtered.length,
      itemBuilder: (_, i) {
        final u = _filtered[i];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppTheme.violet,
            child: Text(
              u.name.isNotEmpty ? u.name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            u.name.isEmpty ? u.code : u.name,
            style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
          ),
          subtitle: Text(
            u.code,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
          ),
          trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
          onTap: () => _select(u),
        );
      },
    );
  }
}
