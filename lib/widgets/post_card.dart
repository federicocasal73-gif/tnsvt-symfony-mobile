import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/feed_post.dart';
import 'signal_card.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final FeedPost post;
  final String currentUserCode;
  final bool isAdmin;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback? onDelete;
  final VoidCallback onViewComments;

  const PostCard({
    super.key,
    required this.post,
    required this.currentUserCode,
    required this.isAdmin,
    required this.onLike,
    required this.onComment,
    required this.onDelete,
    required this.onViewComments,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  String? _myReaction; // 'like' | 'love' | 'fire' | null
  final Map<String, int> _localReacts = {'like': 0, 'love': 0, 'fire': 0};

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _localReacts['like'] = widget.post.likes;
  }

  @override
  void didUpdateWidget(covariant PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likes != widget.post.likes) {
      _localReacts['like'] = widget.post.likes;
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _setReaction(String r) async {
    setState(() {
      if (_myReaction == r) {
        if (r == 'like') {
          _localReacts['like'] = (_localReacts['like'] ?? 1) - 1;
        } else {
          _localReacts[r] = (_localReacts[r] ?? 0) - 1;
        }
        _myReaction = null;
      } else {
        if (_myReaction == 'like' && r != 'like') {
          _localReacts['like'] = (_localReacts['like'] ?? 1) - 1;
        }
        if (_myReaction != null && _myReaction != 'like') {
          _localReacts[_myReaction!] = (_localReacts[_myReaction!] ?? 1) - 1;
        }
        if (r == 'like') {
          _localReacts['like'] = (_localReacts['like'] ?? 0) + 1;
        } else {
          _localReacts[r] = (_localReacts[r] ?? 0) + 1;
        }
        _myReaction = r;
        if (r == 'like') {
          _animCtrl.forward(from: 0).then((_) => _animCtrl.reverse());
        }
      }
    });
    if (r == 'like') widget.onLike();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final currentUserCode = widget.currentUserCode;
    final isAdmin = widget.isAdmin;
    final isAuthor = post.authorCode == currentUserCode;
    final isSignal = post.signal != null;
    final categoryColor = _categoryColor(post.category);
    final timeStr = _formatTime(post.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: categoryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: isAuthor ? AppTheme.gold : AppTheme.violet,
                child: Text(
                  post.authorName.isNotEmpty
                      ? post.authorName[0].toUpperCase()
                      : '?',
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
                        Text(
                          post.authorName,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (isAuthor)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              '• vos',
                              style: TextStyle(
                                color: AppTheme.gold,
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      timeStr,
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: categoryColor, width: 0.5),
                ),
                child: Text(
                  _categoryLabel(post.category),
                  style: TextStyle(
                    color: categoryColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              if ((isAuthor || isAdmin) && widget.onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 18),
                  onPressed: widget.onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
            ],
          ),
          const SizedBox(height: 10),

          // Signal (si existe)
          if (isSignal) SignalCard(signal: post.signal!),

          // Texto
          if (post.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSignal ? 10 : 0),
              child: Text(
                post.text,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),

          // Foto
          if (post.photo != null && post.photo!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                post.photo!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 80,
                  color: AppTheme.surfaceLight,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: AppTheme.textMuted),
                  ),
                ),
              ),
            ),
          ],

          // Actions
          const SizedBox(height: 10),
          Row(
            children: [
              _reactButton('like', Icons.thumb_up,
                  _localReacts['like'] ?? post.likes, _myReaction == 'like'),
              const SizedBox(width: 14),
              _reactButton('love', Icons.favorite,
                  _localReacts['love'] ?? 0, _myReaction == 'love', color: AppTheme.danger),
              const SizedBox(width: 14),
              _reactButton('fire', Icons.local_fire_department,
                  _localReacts['fire'] ?? 0, _myReaction == 'fire', color: AppTheme.warning),
              const Spacer(),
              _actionButton(
                icon: Icons.mode_comment_outlined,
                label: '${post.comments.length}',
                onTap: widget.onViewComments,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: widget.onComment,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 32),
                ),
                child: const Text(
                  'Comentar',
                  style: TextStyle(color: AppTheme.gold, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool animate = false,
  }) {
    final iconWidget = Icon(icon, size: 16, color: color);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            animate
                ? ScaleTransition(
                    scale: Tween<double>(begin: 1.0, end: 1.5).animate(
                      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
                    ),
                    child: iconWidget,
                  )
                : iconWidget,
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reactButton(String key, IconData icon, int count, bool active,
      {Color? color}) {
    final base = color ?? AppTheme.gold;
    final c = active ? base : AppTheme.textSecondary;
    return InkWell(
      onTap: () => _setReaction(key),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: c),
            const SizedBox(width: 4),
            Text('$count',
                style: TextStyle(
                  color: c,
                  fontSize: 12,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'general':
        return 'GENERAL';
      case 'señales':
        return 'SEÑAL';
      case 'resultados':
        return 'RESULTADO';
      case 'proyecciones':
        return 'PROYECCIÓN';
      case 'pregunta':
        return 'PREGUNTA';
      default:
        return cat.toUpperCase();
    }
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'general':
        return AppTheme.violet;
      case 'señales':
        return AppTheme.success;
      case 'resultados':
        return AppTheme.warning;
      case 'proyecciones':
        return AppTheme.goldBright;
      case 'pregunta':
        return const Color(0xFF60A5FA);
      default:
        return AppTheme.textMuted;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'hace ${diff.inDays}d';
    return DateFormat('d MMM', 'es').format(dt);
  }
}
