import 'package:flutter/foundation.dart';
import '../models/feed_post.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class FeedProvider extends ChangeNotifier {
  final ApiService _api;
  final AuthProvider _auth;

  List<FeedPost> _posts = [];
  String _currentCategory = 'all';
  bool _loading = false;
  String? _error;

  FeedProvider(this._api, this._auth);

  List<FeedPost> get posts => _posts;
  String get currentCategory => _currentCategory;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetch({String category = 'all'}) async {
    _currentCategory = category;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.get('/api/feed',
          query: category != 'all' ? {'category': category} : null);
      if (data is List) {
        _posts = data
            .whereType<Map<String, dynamic>>()
            .map((j) => FeedPost.fromJson(j))
            .toList();
      } else {
        _posts = [];
      }
    } catch (e) {
      _error = e.toString();
      _posts = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> createPost({
    required String text,
    required String category,
    SignalData? signal,
    String? photo,
  }) async {
    final user = _auth.user;
    if (user == null) return false;

    final body = <String, dynamic>{
      'author_code': user.code,
      'author_name': user.name,
      'text': text,
      'cat': signal != null ? 'señales' : category,
    };
    if (signal != null) body['signal'] = signal.toJson();
    if (photo != null) body['photo'] = photo;

    try {
      await _api.post('/api/feed', body: body);
      await fetch(category: _currentCategory);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleLike(int postId, String action) async {
    final user = _auth.user;
    if (user == null) return false;
    try {
      await _api.post('/api/feed/$postId/like',
          body: {'author_code': user.code, 'action': action});
      await fetch(category: _currentCategory);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deletePost(int postId) async {
    final user = _auth.user;
    if (user == null) return false;
    try {
      await _api.deleteWithQuery('/api/feed/$postId', {'author_code': user.code});
      await fetch(category: _currentCategory);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addComment(int postId, String text, {String? photo}) async {
    final user = _auth.user;
    if (user == null) return false;
    try {
      final body = <String, dynamic>{
        'author': user.code,
        'text': text,
      };
      if (photo != null) body['photo'] = photo;
      await _api.post('/api/feed/$postId/comment', body: body);
      await fetch(category: _currentCategory);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
