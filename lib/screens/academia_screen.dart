import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/academia_course.dart';
import '../providers/academia_provider.dart';
import 'academia_video_screen.dart';

class AcademiaScreen extends StatefulWidget {
  const AcademiaScreen({super.key});

  @override
  State<AcademiaScreen> createState() => _AcademiaScreenState();
}

class _AcademiaScreenState extends State<AcademiaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = context.read<AcademiaProvider>();
      if (p.courses.isEmpty) p.fetch();
    });
  }

  Future<void> _refresh() async {
    await context.read<AcademiaProvider>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    final academia = context.watch<AcademiaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('🎓 Academia')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _build(academia),
      ),
    );
  }

  Widget _build(AcademiaProvider academia) {
    if (academia.loading && academia.courses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.gold),
      );
    }
    if (academia.error != null && academia.courses.isEmpty) {
      return ListView(
        children: [
          const SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.danger, size: 48),
                const SizedBox(height: 8),
                Text('Error: ${academia.error}',
                    style: const TextStyle(color: AppTheme.danger),
                    textAlign: TextAlign.center),
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
    if (academia.courses.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 60),
          Center(
            child: Column(
              children: [
                Icon(Icons.school, size: 64, color: AppTheme.violet),
                SizedBox(height: 8),
                Text('No hay cursos cargados',
                    style: TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemCount: academia.courses.length,
      itemBuilder: (_, i) => _CourseCard(course: academia.courses[i]),
    );
  }
}

class _CourseCard extends StatelessWidget {
  final AcademiaCourse course;
  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final ytId = AcademiaCourse.extractYouTubeId(course.videoUrl);
    final isLocked = course.locked && ytId == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('🔒 Curso bloqueado')),
            );
            return;
          }
          if (ytId != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AcademiaVideoScreen(course: course, youtubeId: ytId),
              ),
            );
          } else {
            _showDetail(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLocked
                  ? AppTheme.violet.withOpacity(0.2)
                  : AppTheme.gold.withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceLight,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      course.emoji ?? '📚',
                      style: const TextStyle(fontSize: 48),
                    ),
                    if (isLocked)
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.gold, width: 1.5),
                        ),
                        child: const Icon(Icons.lock,
                            color: AppTheme.gold, size: 20),
                      ),
                    if (ytId != null && !isLocked)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.black, size: 28),
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '#${course.orden}',
                          style: const TextStyle(
                            color: AppTheme.gold,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        height: 1.2,
                      ),
                    ),
                    if (course.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        course.subtitle!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${course.emoji} ${course.title}',
                style: const TextStyle(
                  color: AppTheme.goldBright,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            if (course.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(course.subtitle!,
                  style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
            ],
            const SizedBox(height: 16),
            Text(course.description ?? 'Sin descripción',
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.5)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
