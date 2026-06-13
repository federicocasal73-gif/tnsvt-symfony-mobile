import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  late final Dio _dio;
  String? _sessionCookie;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_sessionCookie != null) {
          options.headers['Cookie'] = _sessionCookie!;
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        final cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          _sessionCookie = cookies.first.split(';').first;
        }
        handler.next(response);
      },
    ));
  }

  void clearSession() {
    _sessionCookie = null;
  }

  Future<Map<String, dynamic>> login(String code, {String? password}) async {
    final body = <String, dynamic>{'code': code};
    if (password != null && password.isNotEmpty) body['password'] = password;
    final response = await _dio.post('/api/auth/login', data: body);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> checkAuth() async {
    final response = await _dio.get('/api/auth/check');
    return response.data as Map<String, dynamic>;
  }

  Future<void> logout() async {
    try {
      await _dio.post('/api/auth/logout');
    } catch (_) {}
    clearSession();
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get(path, queryParameters: query);
    return response.data;
  }

  Future<dynamic> deleteWithQuery(String path, Map<String, dynamic> query) async {
    final response = await _dio.delete(path, queryParameters: query);
    return response.data;
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
    final response = await _dio.post(path, data: body, queryParameters: query);
    return response.data;
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body, Map<String, dynamic>? query}) async {
    final response = await _dio.put(path, data: body, queryParameters: query);
    return response.data;
  }

  Future<dynamic> delete(String path) async {
    final response = await _dio.delete(path);
    return response.data;
  }
}

