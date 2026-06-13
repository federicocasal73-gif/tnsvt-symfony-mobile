import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/feed_post.dart';
import '../providers/auth_provider.dart';
import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import 'feed_compose_screen.dart';
import 'comments_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedProvider>().fetch();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<FeedProvider>().fetch(
        category: context.read<FeedProvider>().currentCategory);
  }

  void _changeCategory(String cat) {
    context.read<FeedProvider>().fetch(category: cat);
  }

  @override
  Widget build(BuildContext context) {
    final feed = context.watch<FeedProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📰 Feed'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _chip('all', 'Todos', feed.currentCategory),
                _chip('general', 'General', feed.currentCategory),
                _chip('señales', 'Señales', feed.currentCategory),
                _chip('resultados', 'Resultados', feed.currentCategory),
                _chip('proyecciones', 'Proyecciones', feed.currentCategory),
                _chip('pregunta', 'Preguntas', feed.currentCategory),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(feed, auth),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FeedComposeScreen()),
          );
          _refresh();
        },
        backgroundColor: AppTheme.gold,
        foregroundColor: Colors.black,
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildBody(FeedProvider feed, AuthProvider auth) {
    if (feed.loading && feed.posts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }

    if (feed.error != null && feed.posts.isEmpty) {
      return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Error: ${feed.error}',
                  style: const TextStyle(color: AppTheme.danger),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _refresh,
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (feed.posts.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Icon(Icons.feed, size: 64, color: AppTheme.textMuted),
                SizedBox(height: 12),
                Text('No hay posts',
                    style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                SizedBox(height: 4),
                Text('Tocá el botón + para crear el primero',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: feed.posts.length,
      itemBuilder: (_, i) {
        final post = feed.posts[i];
        return PostCard(
          post: post,
          currentUserCode: auth.user?.code ?? '',
          isAdmin: auth.isAdmin,
          onLike: () => feed.toggleLike(post.id, 'toggle'),
          onComment: () => _openComments(post, auth),
          onViewComments: () => _openComments(post, auth),
          onDelete: (post.authorCode == (auth.user?.code ?? '') || auth.isAdmin)
              ? () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('¿Eliminar post?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar',
                              style: TextStyle(color: AppTheme.danger)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) feed.deletePost(post.id);
                }
              : null,
        );
      },
    );
  }

  void _openComments(FeedPost post, AuthProvider auth) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentsScreen(
          post: post,
          currentUserCode: auth.user?.code ?? '',
        ),
      ),
    ).then((_) => _refresh());
  }

  Widget _chip(String value, String label, String current) {
    final active = value == current;
    final accent = _accentFor(value);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_iconFor(value), size: 12, color: active ? Colors.black : accent),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        selected: active,
        onSelected: (_) => _changeCategory(value),
        selectedColor: AppTheme.gold,
        backgroundColor: AppTheme.surface,
        labelStyle: TextStyle(
          fontFamily: AppTheme.labelFont,
          color: active ? Colors.black : AppTheme.textSecondary,
          fontSize: 10,
          fontWeight: active ? FontWeight.bold : FontWeight.w600,
          letterSpacing: 1,
        ),
        side: BorderSide(
          color: active ? AppTheme.gold : accent.withOpacity(0.5),
        ),
      ),
    );
  }

  IconData _iconFor(String value) {
    switch (value) {
      case 'señales':
        return Icons.bolt;
      case 'resultados':
        return Icons.emoji_events;
      case 'proyecciones':
        return Icons.trending_up;
      case 'pregunta':
        return Icons.help_outline;
      case 'general':
        return Icons.forum;
      default:
        return Icons.all_inclusive;
    }
  }

  Color _accentFor(String value) {
    switch (value) {
      case 'señales':
        return AppTheme.gold;
      case 'resultados':
        return AppTheme.success;
      case 'proyecciones':
        return AppTheme.violet;
      case 'pregunta':
        return AppTheme.violet;
      case 'general':
        return AppTheme.textSecondary;
      default:
        return AppTheme.gold;
    }
  }
}
