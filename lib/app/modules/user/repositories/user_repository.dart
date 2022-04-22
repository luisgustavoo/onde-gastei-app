import 'package:onde_gastei_app/app/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> fetchUserData();

  Future<void> updateUserName(int userId, String newUserName);

  Future<void> removeLocalUserData();
}
