import 'package:flutter/foundation.dart';
import '../models/trade.dart';
import '../services/api_service.dart';

class JournalProvider extends ChangeNotifier {
  final ApiService _api;
  JournalProvider(this._api);

  List<Trade> trades = [];
  bool loading = false;
  String? error;

  int get wins => trades.where((t) => t.isWin).length;
  int get losses => trades.where((t) => t.isLoss).length;
  int get opens => trades.where((t) => t.isOpen).length;
  double get totalPnl => trades.fold(0.0, (sum, t) => sum + t.pnl);
  double get winRate =>
      (wins + losses) == 0 ? 0 : (wins / (wins + losses)) * 100;

  Future<void> fetch(String userCode) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final data = await _api.get('/api/journal', query: {'user_code': userCode});
      final list = (data as List)
          .map((e) => Trade.fromJson(e as Map<String, dynamic>))
          .toList();
      list.sort((a, b) {
        final ad = a.date ?? DateTime(1970);
        final bd = b.date ?? DateTime(1970);
        return bd.compareTo(ad);
      });
      trades = list;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }

  Future<bool> create(String userCode, Map<String, dynamic> data) async {
    try {
      final body = {...data, 'user_code': userCode};
      await _api.post('/api/journal', body: body);
      await fetch(userCode);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(String userCode, int id, Map<String, dynamic> data) async {
    try {
      await _api.put('/api/journal/$id', body: data);
      await fetch(userCode);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String userCode, int id) async {
    try {
      await _api.delete('/api/journal/$id');
      await fetch(userCode);
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
