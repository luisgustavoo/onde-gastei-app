import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';

class AuthController extends ChangeNotifier {
  AuthController({required SharedPreferencesLocalStorageImpl localStorage})
      : _localStorage = localStorage;

  final SharedPreferencesLocalStorageImpl _localStorage;

  Future<bool> isLogged() async {
    final user = await _localStorage.read<String>('user');
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }
}
