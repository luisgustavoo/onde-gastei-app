import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  Future<bool> isLogged() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return true;
  }
}
