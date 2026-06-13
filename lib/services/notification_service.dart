import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final ApiService _api = ApiService();
  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);

  bool _initialized = false;
  String? _fcmToken;
  String? _userCode;
  StreamSubscription<RemoteMessage>? _foregroundSub;

  bool get isInitialized => _initialized;
  String? get fcmToken => _fcmToken;

  Future<void> init() async {
    if (_initialized) return;
    try {
      await Firebase.initializeApp();
      _initialized = true;
      debugPrint('Firebase initialized');
    } catch (e) {
      debugPrint('Firebase init failed: $e');
      return;
    }

    _foregroundSub = FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<bool> requestPermission() async {
    if (!_initialized) return false;
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    final granted = settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
    debugPrint('Notification permission: ${settings.authorizationStatus}');
    return granted;
  }

  Future<String?> getToken() async {
    if (!_initialized) return null;
    try {
      _fcmToken = await FirebaseMessaging.instance.getToken();
      debugPrint('FCM token obtained: ${_fcmToken?.substring(0, 20)}...');
      return _fcmToken;
    } catch (e) {
      debugPrint('FCM getToken failed: $e');
      return null;
    }
  }

  Future<void> registerDeviceForUser(String userCode, {String? deviceModel}) async {
    _userCode = userCode;
    final granted = await requestPermission();
    if (!granted) {
      debugPrint('Notification permission not granted, skipping register');
      return;
    }
    final token = await getToken();
    if (token == null) return;

    try {
      await _api.post('/api/devices/register', body: {
        'user_code': userCode,
        'fcm_token': token,
        'platform': defaultTargetPlatform.name,
        'device_model': deviceModel ?? 'unknown',
      });
      debugPrint('Device registered for user $userCode');
    } catch (e) {
      debugPrint('Device register failed: $e');
    }
  }

  Future<void> unregisterDevice() async {
    if (_fcmToken == null) return;
    try {
      await _api.post('/api/devices/unregister', body: {'fcm_token': _fcmToken});
    } catch (e) {
      debugPrint('Device unregister failed: $e');
    }
  }

  Future<int> refreshUnreadCount(String userCode) async {
    try {
      final data = await _api.get('/api/notifications/count', query: {'user_code': userCode});
      if (data is Map && data['count'] is int) {
        unreadCount.value = data['count'] as int;
        return unreadCount.value;
      }
    } catch (e) {
      debugPrint('refreshUnreadCount failed: $e');
    }
    return 0;
  }

  Future<void> markAsRead(int id) async {
    try {
      await _api.put('/api/notifications/$id/read');
    } catch (e) {
      debugPrint('markAsRead failed: $e');
    }
  }

  Future<void> markAllAsRead(String userCode) async {
    try {
      await _api.put('/api/notifications/read-all', query: {'user_code': userCode});
      unreadCount.value = 0;
    } catch (e) {
      debugPrint('markAllAsRead failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAll(String userCode) async {
    try {
      final data = await _api.get('/api/notifications', query: {'user_code': userCode});
      if (data is List) {
        return data.whereType<Map<String, dynamic>>().toList();
      }
    } catch (e) {
      debugPrint('fetchAll failed: $e');
    }
    return [];
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Foreground FCM: ${message.notification?.title} / ${message.notification?.body}');
    final userCode = _userCode;
    if (userCode != null) {
      refreshUnreadCount(userCode);
    }
  }

  Future<void> dispose() async {
    await _foregroundSub?.cancel();
  }
}
