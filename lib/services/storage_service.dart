import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class StorageService {
  static const _kUserCode = 'tnsv_user_code';
  static const _kUserName = 'tnsv_user_name';
  static const _kIsAdmin = 'tnsv_is_admin';
  static const _kTaskCompletedPrefix = 'tnsv_task_completed_';

  Future<void> saveUser(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserCode, user.code);
    await prefs.setString(_kUserName, user.name);
    await prefs.setBool(_kIsAdmin, user.isAdmin);
  }

  Future<AppUser?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kUserCode);
    if (code == null) return null;
    return AppUser(
      code: code,
      name: prefs.getString(_kUserName) ?? 'Usuario',
      isAdmin: prefs.getBool(_kIsAdmin) ?? false,
    );
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserCode);
    await prefs.remove(_kUserName);
    await prefs.remove(_kIsAdmin);
  }

  Future<Set<String>> getCompletedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_kTaskCompletedPrefix));
    return keys.map((k) => k.substring(_kTaskCompletedPrefix.length)).toSet();
  }

  Future<void> setTaskCompleted(int taskId, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    if (completed) {
      await prefs.setBool('$_kTaskCompletedPrefix$taskId', true);
    } else {
      await prefs.remove('$_kTaskCompletedPrefix$taskId');
    }
  }
}

