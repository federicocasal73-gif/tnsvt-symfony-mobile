class SignalData {
  final String asset;
  final String dir;
  final String entry;
  final String sl;
  final String tp1;
  final String? tp2;
  final String status;

  SignalData({
    required this.asset,
    required this.dir,
    required this.entry,
    required this.sl,
    required this.tp1,
    this.tp2,
    this.status = 'Abierta',
  });

  factory SignalData.fromJson(Map<String, dynamic> json) {
    return SignalData(
      asset: json['asset'] ?? '',
      dir: json['dir'] ?? 'BUY',
      entry: json['entry'] ?? '',
      sl: json['sl'] ?? '',
      tp1: json['tp1'] ?? '',
      tp2: json['tp2'],
      status: json['status'] ?? 'Abierta',
    );
  }

  Map<String, dynamic> toJson() => {
        'asset': asset,
        'dir': dir,
        'entry': entry,
        'sl': sl,
        'tp1': tp1,
        if (tp2 != null && tp2!.isNotEmpty) 'tp2': tp2,
        'status': status,
      };
}

class Comment {
  final String? author;
  final String text;
  final String? photo;
  final String? createdAt;

  Comment({
    this.author,
    required this.text,
    this.photo,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      author: json['author'],
      text: json['text'] ?? '',
      photo: json['photo'],
      createdAt: json['created_at'],
    );
  }
}

class FeedPost {
  final int id;
  final String authorCode;
  final String authorName;
  final String category;
  final String text;
  final int likes;
  final List<Comment> comments;
  final SignalData? signal;
  final String? photo;
  final DateTime createdAt;

  FeedPost({
    required this.id,
    required this.authorCode,
    required this.authorName,
    required this.category,
    required this.text,
    required this.likes,
    required this.comments,
    this.signal,
    this.photo,
    required this.createdAt,
  });

  factory FeedPost.fromJson(Map<String, dynamic> json) {
    final commentsRaw = json['comments'];
    List<Comment> commentsList = [];
    if (commentsRaw is List) {
      commentsList = commentsRaw
          .whereType<Map<String, dynamic>>()
          .map((c) => Comment.fromJson(c))
          .toList();
    }
    SignalData? signalData;
    final sig = json['signal'];
    if (sig is Map<String, dynamic>) {
      signalData = SignalData.fromJson(sig);
    } else if (sig is String && sig.isNotEmpty) {
      try {
        signalData = SignalData.fromJson(Map<String, dynamic>.from(_parseJson(sig)));
      } catch (_) {}
    }

    return FeedPost(
      id: json['id'] ?? 0,
      authorCode: json['author_code'] ?? '',
      authorName: json['author_name'] ?? '?',
      category: json['cat'] ?? 'general',
      text: json['text'] ?? '',
      likes: json['likes'] ?? 0,
      comments: commentsList,
      signal: signalData,
      photo: json['photo'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  static dynamic _parseJson(String s) {
    try {
      return _jsonDecode(s);
    } catch (_) {
      return {};
    }
  }

  static dynamic _jsonDecode(String s) {
    final cleaned = s.replaceAll(RegExp(r'\\(.)'), r'$1');
    return _manualParse(cleaned);
  }

  static Map<String, dynamic> _manualParse(String s) {
    final out = <String, dynamic>{};
    final kvRegex = RegExp(r'"([^"]+)"\s*:\s*"([^"]*)"');
    for (final match in kvRegex.allMatches(s)) {
      out[match.group(1) ?? ''] = match.group(2) ?? '';
    }
    return out;
  }
}
