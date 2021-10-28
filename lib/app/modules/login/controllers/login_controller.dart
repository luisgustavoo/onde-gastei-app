import 'package:flutter/foundation.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';

class LoginController extends ChangeNotifier {
  LoginController({required this.localStorage});

  SharedPreferencesLocalStorageImpl localStorage;

  Future<bool> isLogged() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }
}
