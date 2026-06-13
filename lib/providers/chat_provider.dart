import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';

class ChatProvider extends ChangeNotifier {
  final ApiService _api;
  final AuthProvider _auth;

  List<ChatConversation> _conversations = [];
  List<ChatMessage> _activeMessages = [];
  ChatConversation? _activeConv;
  bool _loading = false;
  String? _error;
  Timer? _pollTimer;

  ChatProvider(this._api, this._auth);

  List<ChatConversation> get conversations => _conversations;
  List<ChatMessage> get activeMessages => _activeMessages;
  ChatConversation? get activeConv => _activeConv;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> loadConversations({bool silent = false}) async {
    final user = _auth.user;
    if (user == null) return;
    if (!silent) {
      _loading = true;
      _error = null;
      notifyListeners();
    }

    try {
      final data = await _api.get('/api/chat/conversations',
          query: {'user_code': user.code});
      if (data is List) {
        _conversations = data
            .whereType<Map<String, dynamic>>()
            .map((j) => ChatConversation.fromJson(j))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    }
    if (!silent) {
      _loading = false;
    }
    notifyListeners();
  }

  Future<void> openConversation(int convId) async {
    final user = _auth.user;
    if (user == null) return;
    _activeConv = _conversations.firstWhere((c) => c.id == convId);
    notifyListeners();

    await loadMessages(convId);
    await markRead(convId);

    // Polling cada 5s
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await loadMessages(convId, silent: true);
      await loadConversations(silent: true);
    });
  }

  Future<void> loadMessages(int convId, {bool silent = false}) async {
    final user = _auth.user;
    if (user == null) return;
    if (!silent) {
      _loading = true;
      notifyListeners();
    }
    try {
      final data = await _api.get(
        '/api/chat/conversations/$convId/messages',
        query: {'user_code': user.code, 'limit': '50'},
      );
      if (data is List) {
        _activeMessages = data
            .whereType<Map<String, dynamic>>()
            .map((j) => ChatMessage.fromJson(j))
            .toList();
      }
    } catch (e) {
      if (!silent) _error = e.toString();
    }
    if (!silent) {
      _loading = false;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> markRead(int convId) async {
    final user = _auth.user;
    if (user == null) return;
    try {
      await _api.post('/api/chat/conversations/$convId/read',
          body: {'user_code': user.code});
    } catch (_) {}
  }

  Future<bool> sendMessage(int convId, String content, {String? photo}) async {
    final user = _auth.user;
    if (user == null) return false;
    if (content.trim().isEmpty && photo == null) return false;
    try {
      final body = <String, dynamic>{
        'user_code': user.code,
        'content': content.trim(),
      };
      if (photo != null) body['photo'] = photo;
      final res = await _api.post('/api/chat/conversations/$convId/messages', body: body);
      if (res is Map<String, dynamic>) {
        final msg = ChatMessage.fromJson(res);
        _activeMessages = [..._activeMessages, msg];
        notifyListeners();
        await loadConversations(silent: true);
        return true;
      }
      await loadMessages(convId, silent: true);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<ChatConversation?> startDmWith(String otherCode) async {
    final user = _auth.user;
    if (user == null) return null;
    try {
      final res = await _api.post('/api/chat/conversations', body: {
        'user_code': user.code,
        'other_code': otherCode,
      });
      if (res is Map<String, dynamic>) {
        final conv = ChatConversation.fromJson(res);
        final idx = _conversations.indexWhere((c) => c.id == conv.id);
        if (idx >= 0) {
          _conversations[idx] = conv;
        } else {
          _conversations.insert(0, conv);
        }
        notifyListeners();
        return conv;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
    return null;
  }

  void closeConversation() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _activeConv = null;
    _activeMessages = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }
}
