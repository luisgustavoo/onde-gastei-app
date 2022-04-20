import 'package:onde_gastei_app/app/models/user_model.dart';

abstract class UserService {
  Future<UserModel> fetchUserData();

  Future<void> updateUserName(int userId, String newUserName);
}
