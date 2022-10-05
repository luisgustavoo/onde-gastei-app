import 'package:onde_gastei_app/app/models/user_model.dart';

abstract class UserController {
  Future<void> fetchUserData();

  Future<void> updateUserName(int userId, String newUserName);

  Future<UserModel?> getLocalUser();

  Future<void> deleteAccountUser(int userId);

  void logout();
}
