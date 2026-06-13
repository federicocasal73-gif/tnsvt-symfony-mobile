import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api;
  final StorageService _storage;

  AppUser? _user;
  bool _loading = false;
  String? _error;

  AuthProvider(this._api, this._storage);

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> tryRestoreSession() async {
    _user = await _storage.loadUser();
    if (_user != null) {
      try {
        final res = await _api.checkAuth();
        if (res['authenticated'] == true && res['user'] != null) {
          _user = AppUser.fromJson(res['user']);
          await _storage.saveUser(_user!);
        } else {
          // Sesión expirada en backend
          await _storage.clearUser();
          _api.clearSession();
          _user = null;
        }
      } catch (_) {
        // Si falla la red, dejamos al usuario logueado localmente
      }
    }
    notifyListeners();
  }

  Future<bool> login(String code, {String? password}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.login(code, password: password);
      if (res['success'] == true && res['user'] != null) {
        _user = AppUser.fromJson(res['user']);
        await _storage.saveUser(_user!);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['error'] ?? 'Código inválido';
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = _parseError(e);
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _api.logout();
    await _storage.clearUser();
    _user = null;
    notifyListeners();
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('Contraseña')) return 'Contraseña incorrecta';
    if (msg.contains('SocketException') || msg.contains('Connection')) {
      return 'No se pudo conectar al servidor';
    }
    return 'Error: $msg';
  }
}

