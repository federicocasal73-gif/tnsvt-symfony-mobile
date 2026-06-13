import 'package:flutter/foundation.dart';
import '../models/academia_course.dart';
import '../services/api_service.dart';

class AcademiaProvider extends ChangeNotifier {
  final ApiService _api;

  List<AcademiaCourse> _courses = [];
  bool _loading = false;
  String? _error;

  AcademiaProvider(this._api);

  List<AcademiaCourse> get courses => _courses;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetch() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _api.get('/api/academia');
      if (data is List) {
        _courses = data
            .whereType<Map<String, dynamic>>()
            .map((j) => AcademiaCourse.fromJson(j))
            .toList();
      } else {
        _courses = [];
      }
    } catch (e) {
      _error = e.toString();
      _courses = [];
    }

    _loading = false;
    notifyListeners();
  }
}
