import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocalStorageImpl implements LocalStorage {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  @override
  Future<void> clear() async {
    final sp = await _instance;
    await sp.clear();
  }

  @override
  Future<bool> contains(String key) async {
    final sp = await _instance;
    return sp.containsKey(key);
  }

  @override
  Future<T?> read<T>(String key) async {
    final sp = await _instance;

    switch (T) {
      case String:
        sp.getString(key);
        break;
      case int:
        sp.getInt(key);
        break;
      case double:
        sp.getDouble(key);
        break;
      case bool:
        sp.getBool(key);
        break;
      case List:
        sp.getStringList(key);
        break;
    }
  }

  @override
  Future<void> remove(String key) async {
    final sp = await _instance;
    await sp.remove(key);
  }

  @override
  Future<void> write<T>(String key, T value) async {
    final sp = await _instance;

    switch (T) {
      case String:
        await sp.setString(key, value as String);
        break;
      case int:
        await sp.setInt(key, value as int);
        break;
      case bool:
        await sp.setBool(key, value as bool);
        break;
      case double:
        await sp.setDouble(key, value as double);
        break;
      case List:
        await sp.setStringList(key, value as List<String>);
        break;
    }
  }
}
