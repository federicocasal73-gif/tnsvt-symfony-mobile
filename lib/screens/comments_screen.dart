import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/feed_post.dart';
import '../providers/feed_provider.dart';
import '../services/image_service.dart';

class CommentsScreen extends StatefulWidget {
  final FeedPost post;
  final String currentUserCode;

  const CommentsScreen({
    super.key,
    required this.post,
    required this.currentUserCode,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _textCtrl = TextEditingController();
  final _imageService = ImageService();
  String? _photoBase64;
  bool _sending = false;

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty && _photoBase64 == null) return;
    setState(() => _sending = true);
    final feed = context.read<FeedProvider>();
    final ok = await feed.addComment(
      widget.post.id,
      text,
      photo: _photoBase64,
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      _textCtrl.clear();
      setState(() => _photoBase64 = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error al enviar comentario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💬 ${widget.post.comments.length} comentarios'),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.post.comments.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mode_comment,
                            size: 64, color: AppTheme.textMuted),
                        SizedBox(height: 8),
                        Text('Sin comentarios',
                            style: TextStyle(color: AppTheme.textSecondary)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.post.comments.length,
                    itemBuilder: (_, i) => _commentTile(widget.post.comments[i]),
                  ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _commentTile(Comment c) {
    final time = c.createdAt != null
        ? _formatTime(DateTime.parse(c.createdAt!).toLocal())
        : '';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppTheme.violet,
                child: Text(
                  (c.author ?? '?').isNotEmpty
                      ? c.author![0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                c.author ?? '?',
                style: const TextStyle(
                  color: AppTheme.gold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (time.isNotEmpty) ...[
                const Spacer(),
                Text(time,
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
              ],
            ],
          ),
          if (c.text.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(c.text,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13)),
          ],
          if (c.photo != null && c.photo!.isNotEmpty) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(
                ImageService.base64ToBytes(c.photo!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
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
              _photoBase64 == null ? Icons.add_photo_alternate : Icons.delete,
              color: _photoBase64 == null ? AppTheme.textSecondary : AppTheme.danger,
            ),
            onPressed: _sending
                ? null
                : () async {
                    if (_photoBase64 == null) {
                      final b64 = await _imageService.pickImageAsBase64();
                      if (b64 != null) setState(() => _photoBase64 = b64);
                    } else {
                      setState(() => _photoBase64 = null);
                    }
                  },
          ),
          Expanded(
            child: TextField(
              controller: _textCtrl,
              enabled: !_sending,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Escribí un comentario...',
                hintStyle: const TextStyle(color: AppTheme.textMuted),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

  String _formatTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = _monthName(dt.month);
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$d $m $hh:$mm';
  }

  String _monthName(int m) {
    const months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
    ];
    return months[(m - 1).clamp(0, 11)];
  }
}
