import 'package:onde_gastei_app/app/models/user_model.dart';

abstract class AuthController {
  Future<void> register(String name, String email, String password);

  Future<void> login(String email, String password);

  Future<void> logout();

  Future<UserModel> fetchUserData();
}
