import 'package:firebase_auth/firebase_auth.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
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

    dynamic value;

    switch (T) {
      case const (String):
        value = sp.getString(key);
        return value as T?;
      case const (int):
        value = sp.getInt(key);
        return value as T?;
      case const (double):
        value = sp.getDouble(key);
        return value as T?;
      case const (bool):
        value = sp.getBool(key);
        return value as T?;
      case const (List):
        value = sp.getStringList(key);
        return value as T?;
      default:
        return value as T?;
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
      case const (String):
        await sp.setString(key, value as String);
        break;
      case const (int):
        await sp.setInt(key, value as int);
        break;
      case const (bool):
        await sp.setBool(key, value as bool);
        break;
      case const (double):
        await sp.setDouble(key, value as double);
        break;
      case const (List):
        await sp.setStringList(key, value as List<String>);
        break;
    }
  }

  @override
  Future<void> logout() async {
    // remove(Constants.localUserKey);
    await clear();
    await FirebaseAuth.instance.signOut();
    await OndeGasteiNavigator.to!
        .pushNamedAndRemoveUntil(LoginPage.router, (route) => false);
  }
}
