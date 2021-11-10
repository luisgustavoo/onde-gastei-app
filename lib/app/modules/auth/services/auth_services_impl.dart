import 'package:firebase_auth/firebase_auth.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';

class AuthServicesImpl implements AuthService {
  AuthServicesImpl({
    required AuthRepository repository,
    required Log log,
  })  : _repository = repository,
        _log = log;

  final AuthRepository _repository;
  final Log _log;

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      await _repository.register(name, email, password);
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if(user.user != null){
        await user.user?.sendEmailVerification();
      }

    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao registrar usuário no FirebaseAuth', e, s);
      throw Failure(message: 'Erro ao registrar usuário no FirebaseAuth');
    }
  }
}
