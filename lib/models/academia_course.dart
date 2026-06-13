class AcademiaLesson {
  final String? title;
  final String? description;
  final String? videoUrl;
  final int? duration;

  AcademiaLesson({this.title, this.description, this.videoUrl, this.duration});

  factory AcademiaLesson.fromJson(Map<String, dynamic> json) {
    return AcademiaLesson(
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      duration: json['duration'],
    );
  }
}

class AcademiaCourse {
  final int id;
  final String title;
  final String? subtitle;
  final String? emoji;
  final String? description;
  final String? videoUrl;
  final int orden;
  final bool locked;
  final List<AcademiaLesson> lessons;

  AcademiaCourse({
    required this.id,
    required this.title,
    this.subtitle,
    this.emoji,
    this.description,
    this.videoUrl,
    required this.orden,
    required this.locked,
    required this.lessons,
  });

  factory AcademiaCourse.fromJson(Map<String, dynamic> json) {
    final lessonsRaw = json['lecciones'] ?? json['lessons'];
    List<AcademiaLesson> lessonsList = [];
    if (lessonsRaw is List) {
      lessonsList = lessonsRaw
          .whereType<Map<String, dynamic>>()
          .map((l) => AcademiaLesson.fromJson(l))
          .toList();
    }
    return AcademiaCourse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      emoji: json['emoji'] ?? '📚',
      description: json['descripcion'] ?? json['description'],
      videoUrl: json['video_url'],
      orden: json['orden'] ?? 999,
      locked: json['locked'] ?? true,
      lessons: lessonsList,
    );
  }

  /// Extrae el ID de YouTube desde una URL tipo watch?v=ID, youtu.be/ID, embed/ID
  static String? extractYouTubeId(String? url) {
    if (url == null || url.isEmpty) return null;
    final patterns = [
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'^([a-zA-Z0-9_-]{11})$'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }
}
