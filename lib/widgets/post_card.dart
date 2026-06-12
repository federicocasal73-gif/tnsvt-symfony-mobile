import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/feed_post.dart';
import 'signal_card.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
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
    required this.onViewComments,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              if ((isAuthor || isAdmin) && onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppTheme.danger, size: 18),
                  onPressed: onDelete,
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
              _actionButton(
                icon: Icons.thumb_up_outlined,
                label: '${post.likes}',
                onTap: onLike,
                color: AppTheme.textSecondary,
              ),
              const SizedBox(width: 18),
              _actionButton(
                icon: Icons.mode_comment_outlined,
                label: '${post.comments.length}',
                onTap: onViewComments,
                color: AppTheme.textSecondary,
              ),
              const Spacer(),
              TextButton(
                onPressed: onComment,
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
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
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
