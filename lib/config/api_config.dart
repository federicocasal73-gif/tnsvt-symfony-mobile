import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Compilable: `--dart-define=API_BASE_URL=http://192.168.1.100:8000`
  static const String _compileTimeUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// URL final del backend, elegida en este orden:
  /// 1. API_BASE_URL (si se pasó al compilar)
  /// 2. Web → http://localhost:8000
  /// 3. Otras plataformas → http://10.0.2.2:8000 (emulador Android)
  static String get baseUrl {
    if (_compileTimeUrl.isNotEmpty) return _compileTimeUrl;
    if (kIsWeb) return 'http://localhost:8000';
    return 'http://10.0.2.2:8000';
  }

  static const String academiaPasswordHint = 'Contraseña Academia';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
