import 'package:onde_gastei_app/app/modules/profile/repositories/profile_repository.dart';
import 'package:onde_gastei_app/app/modules/profile/services/profile_service.dart';

class ProfileServiceImpl implements ProfileService {
  ProfileServiceImpl({required ProfileRepository repository})
      : _repository = repository;

  final ProfileRepository _repository;

  @override
  Future<void> updateUserName(int userId, String newUserName) => _repository.updateUserName(userId, newUserName);
}
