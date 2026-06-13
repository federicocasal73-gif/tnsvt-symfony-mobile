import 'package:flutter/foundation.dart';
import '../models/task_item.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class TasksProvider extends ChangeNotifier {
  final ApiService _api;
  final StorageService _storage;

  List<TaskItem> _tasks = [];
  Set<int> _completed = {};
  bool _loading = false;
  String? _error;

  TasksProvider(this._api, this._storage);

  List<TaskItem> get tasks => _tasks;
  Set<int> get completed => _completed;
  int get total => _tasks.length;
  int get doneCount => _completed.length;
  bool get loading => _loading;
  String? get error => _error;

  bool isCompleted(int id) => _completed.contains(id);

  Future<void> init() async {
    _completed = (await _storage.getCompletedTasks())
        .map(int.parse)
        .toSet();
  }

  Future<void> fetch() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.get('/api/tasks');
      if (data is List) {
        _tasks = data
            .whereType<Map<String, dynamic>>()
            .map((j) => TaskItem.fromJson(j))
            .toList();
      } else {
        _tasks = [];
      }
    } catch (e) {
      _error = e.toString();
      _tasks = [];
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> toggle(int id) async {
    if (_completed.contains(id)) {
      _completed.remove(id);
      await _storage.setTaskCompleted(id, false);
    } else {
      _completed.add(id);
      await _storage.setTaskCompleted(id, true);
    }
    notifyListeners();
  }
}
