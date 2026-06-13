import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/chat.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../services/image_service.dart';

class ChatRoomScreen extends StatefulWidget {
  final ChatConversation conv;
  const ChatRoomScreen({super.key, required this.conv});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _ctrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _imageService = ImageService();
  String? _photoBase64;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().openConversation(widget.conv.id);
    });
  }

  @override
  void dispose() {
    context.read<ChatProvider>().closeConversation();
    _ctrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final b64 = await _imageService.pickImageAsBase64();
    if (b64 != null) setState(() => _photoBase64 = b64);
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty && _photoBase64 == null) return;
    setState(() => _sending = true);
    final ok = await context.read<ChatProvider>().sendMessage(
          widget.conv.id,
          text,
          photo: _photoBase64,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      _ctrl.clear();
      setState(() => _photoBase64 = null);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final me = auth.user?.code;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor:
                  widget.conv.isGroup ? AppTheme.gold : AppTheme.violet,
              child: Text(
                widget.conv.displayName.isNotEmpty
                    ? widget.conv.displayName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conv.displayName,
                    style: const TextStyle(
                      color: AppTheme.goldBright,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.conv.isGroup ? 'Grupo de Ejecutores' : 'Mensaje directo',
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chat.activeMessages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mode_comment,
                            size: 64, color: AppTheme.textMuted),
                        SizedBox(height: 8),
                        Text('Sin mensajes',
                            style: TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemCount: chat.activeMessages.length,
                    itemBuilder: (_, i) {
                      final m = chat.activeMessages[i];
                      return _MessageBubble(
                        msg: m,
                        isMe: m.senderCode == me,
                      );
                    },
                  ),
          ),
          if (_photoBase64 != null) _photoPreview(),
          _composer(),
        ],
      ),
    );
  }

  Widget _photoPreview() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: AppTheme.surface,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.memory(
              ImageService.base64ToBytes(_photoBase64!),
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Text('Foto adjunta',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.danger),
            onPressed: () => setState(() => _photoBase64 = null),
          ),
        ],
      ),
    );
  }

  Widget _composer() {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.violet, width: 0.5)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              color: _sending ? AppTheme.textMuted : AppTheme.textSecondary,
            ),
            onPressed: _sending ? null : _pickPhoto,
          ),
          Expanded(
            child: TextField(
              controller: _ctrl,
              enabled: !_sending,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Escribí un mensaje...',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppTheme.gold),
            onPressed: _sending ? null : _send,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final bool isMe;
  const _MessageBubble({required this.msg, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final initial = (msg.senderName ?? '?').isNotEmpty
        ? msg.senderName![0].toUpperCase()
        : '?';

    final bubble = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isMe
            ? AppTheme.gold.withOpacity(0.15)
            : AppTheme.surfaceLight,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(14),
          topRight: const Radius.circular(14),
          bottomLeft: Radius.circular(isMe ? 14 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 14),
        ),
        border: Border.all(
          color: isMe
              ? AppTheme.gold.withOpacity(0.4)
              : AppTheme.violet.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe && msg.senderName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                msg.senderName!,
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (msg.content.isNotEmpty)
            Text(
              msg.content,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                height: 1.3,
              ),
            ),
          if (msg.photo != null && msg.photo!.isNotEmpty) ...[
            if (msg.content.isNotEmpty) const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(
                ImageService.base64ToBytes(msg.photo!),
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: AppTheme.violet,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(child: bubble),
        ],
      ),
    );
  }
}
