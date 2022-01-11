import 'package:onde_gastei_app/app/models/user_model.dart';

abstract class HomeController {
  Future<UserModel> fetchUserData();

  Future<void> fetchHomeData({
    required int userId,
    required DateTime initialDate,
    required DateTime finalDate,
  });

}
