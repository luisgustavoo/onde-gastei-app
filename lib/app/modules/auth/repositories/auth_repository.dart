import 'package:onde_gastei_app/app/modules/auth/view_models/confirm_login_model.dart';

abstract class AuthRepository {
  Future<void> register(String name, String firebaseUserId);

  Future<String> login(String firebaseUserId);

  Future<ConfirmLoginModel> confirmLogin();
}
