import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../config/theme.dart';
import '../models/academia_course.dart';

class AcademiaVideoScreen extends StatefulWidget {
  final AcademiaCourse course;
  final String youtubeId;

  const AcademiaVideoScreen({
    super.key,
    required this.course,
    required this.youtubeId,
  });

  @override
  State<AcademiaVideoScreen> createState() => _AcademiaVideoScreenState();
}

class _AcademiaVideoScreenState extends State<AcademiaVideoScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.background)
      ..loadRequest(Uri.parse(
        'https://www.youtube.com/embed/${widget.youtubeId}?rel=0&modestbranding=1&playsinline=1',
      ))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _loading = false),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        title: Text(
          '${widget.course.emoji} ${widget.course.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading)
                  const Center(
                    child: CircularProgressIndicator(color: AppTheme.gold),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  widget.course.title,
                  style: const TextStyle(
                    color: AppTheme.goldBright,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.course.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    widget.course.subtitle!,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                if (widget.course.description != null)
                  Text(
                    widget.course.description!,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                if (widget.course.lessons.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'LECCIONES',
                    style: TextStyle(
                      color: AppTheme.gold,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.course.lessons.map((l) => Card(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: ListTile(
                          dense: true,
                          leading: const Icon(Icons.play_circle_outline,
                              color: AppTheme.gold),
                          title: Text(l.title ?? 'Lección',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13,
                              )),
                          subtitle: l.description != null
                              ? Text(l.description!,
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 11,
                                  ))
                              : null,
                          trailing: l.duration != null
                              ? Text('${l.duration}m',
                                  style: const TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 11,
                                  ))
                              : null,
                        ),
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
