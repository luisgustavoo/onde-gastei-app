import 'package:onde_gastei_app/app/models/user_model.dart';

abstract class HomeService {
  Future<UserModel> fetchUserData();
}
