import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  late final Dio _dio;
  final Map<String, String> _sessionCookies = {};
  String? _userCode;

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
        if (_userCode != null && _userCode!.isNotEmpty) {
          options.headers['X-User-Code'] = _userCode!;
        }
        if (_sessionCookies.isNotEmpty) {
          options.headers['Cookie'] = _sessionCookies.entries
              .map((e) => '${e.key}=${e.value}')
              .join('; ');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        final setCookies = response.headers['set-cookie'];
        if (setCookies != null) {
          for (final raw in setCookies) {
            final firstPart = raw.split(';').first.trim();
            final eq = firstPart.indexOf('=');
            if (eq > 0) {
              final name = firstPart.substring(0, eq).trim();
              final value = firstPart.substring(eq + 1).trim();
              if (name.isNotEmpty && value.isNotEmpty) {
                _sessionCookies[name] = value;
              }
            }
          }
        }
        handler.next(response);
      },
    ));
  }

  void setUserCode(String? code) {
    _userCode = code;
  }

  void clearSession() {
    _sessionCookies.clear();
    _userCode = null;
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

