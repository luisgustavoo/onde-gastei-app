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
      case String:
        value = sp.getString(key);
        return value as T?;
      case int:
        value = sp.getInt(key);
        return value as T?;
      case double:
        value = sp.getDouble(key);
        return value as T?;
      case bool:
        value = sp.getBool(key);
        return value as T?;
      // ignore: strict_raw_type
      case List:
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
      // ignore: strict_raw_type
      case List:
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
