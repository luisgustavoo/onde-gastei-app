import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service.dart';

class UserServiceImpl implements UserService {
  UserServiceImpl({required UserRepository repository})
      : _repository = repository;

  final UserRepository _repository;

  @override
  Future<UserModel> fetchUserData() => _repository.fetchUserData();

  @override
  Future<void> updateUserName(int userId, String newUserName) =>
      _repository.updateUserName(userId, newUserName);
}
