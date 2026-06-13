import 'package:flutter/foundation.dart';
import '../models/admin.dart';
import '../models/task_item.dart';
import '../services/api_service.dart';

class AdminProvider extends ChangeNotifier {
  final ApiService _api;

  AdminDashboardStats? _dashboard;
  List<AdminUser> _users = [];
  List<TaskItem> _tasks = [];
  bool _loading = false;
  String? _error;

  AdminProvider(this._api);

  AdminDashboardStats? get dashboard => _dashboard;
  List<AdminUser> get users => _users;
  List<TaskItem> get tasks => _tasks;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchDashboard() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _api.get('/api/admin/dashboard');
      if (data is Map<String, dynamic>) {
        _dashboard = AdminDashboardStats.fromJson(data);
      }
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _api.get('/api/admin/users');
      if (data is List) {
        _users = data
            .whereType<Map<String, dynamic>>()
            .map((j) => AdminUser.fromJson(j))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> fetchTasks() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await _api.get('/api/admin/tasks');
      if (data is List) {
        _tasks = data
            .whereType<Map<String, dynamic>>()
            .map((j) => TaskItem.fromJson(j))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> createUser(String code, String name) async {
    try {
      await _api.post('/api/admin/users', body: {'code': code, 'name': name});
      await fetchUsers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUser(int id,
      {String? code, String? name, bool? active}) async {
    try {
      final body = <String, dynamic>{};
      if (code != null) body['code'] = code;
      if (name != null) body['name'] = name;
      if (active != null) body['active'] = active;
      await _api.put('/api/admin/users/$id', body: body);
      await fetchUsers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleUserActive(int id) async {
    try {
      await _api.put('/api/admin/users/$id/toggle-active');
      await fetchUsers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createTask(
      String title, String? description, int orden, bool active) async {
    try {
      await _api.post('/api/admin/tasks', body: {
        'title': title,
        'description': description,
        'orden': orden,
        'active': active,
      });
      await fetchTasks();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(int id,
      {String? title, String? description, int? orden, bool? active}) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (orden != null) body['orden'] = orden;
      if (active != null) body['active'] = active;
      await _api.put('/api/admin/tasks/$id', body: body);
      await fetchTasks();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleTaskActive(int id) async {
    try {
      await _api.put('/api/admin/tasks/$id/toggle-active');
      await fetchTasks();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(int id) async {
    try {
      await _api.delete('/api/admin/tasks/$id');
      await fetchTasks();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
