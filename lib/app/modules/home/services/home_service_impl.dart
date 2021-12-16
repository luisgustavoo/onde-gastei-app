import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';

class HomeServiceImpl implements HomeService {
  HomeServiceImpl({required HomeRepository repository})
      : _repository = repository;

  final HomeRepository _repository;

  @override
  Future<UserModel> fetchUserData() => _repository.fetchUserData();

  @override
  Future<void> refreshToken() => _repository.refreshToken();
}
