import 'package:onde_gastei_app/app/models/confirm_login_model.dart';

abstract class AuthRepository {
  Future<void> register(String name, String email, String password);

  Future<String> login(String email, String password);

  Future<ConfirmLoginModel> confirmLogin();
}
