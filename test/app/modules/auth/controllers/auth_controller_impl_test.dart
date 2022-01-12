import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_service.dart';

import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late AuthService service;
  late Log log;
  late LocalStorage localStorage;
  late AuthController controller;

  setUp(() {
    service = MockAuthService();
    log = MockLog();
    localStorage = MockLocalStorage();
    controller = AuthControllerImpl(
        service: service, log: log, localStorage: localStorage);
  });

  group('Group test isLogged', () {
    test('Should user is logged', () async {
      // Arrange
      const localUser = '''
        {
            "id_usuario": 1,
            "nome": "test",
            "email": "test"
        }
      ''';
      when(() => localStorage.read<String>('user'))
          .thenAnswer((_) async => localUser);
      //Act
      final isLogged = await controller.isLogged();

      //Assert
      expect(isLogged, isTrue);
      verify(() => localStorage.read<String>('user')).called(1);
    });

    test('Should user is not logged', () async {
      // Arrange
      when(() => localStorage.read<String>('user'))
          .thenAnswer((_) async => null);
      //Act
      final isLogged = await controller.isLogged();

      //Assert
      expect(isLogged, isFalse);
      verify(() => localStorage.read<String>('user')).called(1);
    });
  });

  group('Group test register', () {
    test('Should register user with success', () async {
      // Arrange
      const name = 'Test';
      const email = 'test@test.com';
      const password = 'password';

      when(() => service.register(any(), any(), any()))
          .thenAnswer((_) async => _);

      //Act
      await controller.register(name, email, password);

      //Assert
      verify(() => service.register(any(), any(), any())).called(1);
    });

    test('Should throws UserExistsException', () async {
      // Arrange
      const name = 'Test';
      const email = 'test@test.com';
      const password = 'password';

      when(() => service.register(any(), any(), any()))
          .thenThrow(UserExistsException());

      //Act
      await controller.register(name, email, password);

      //Assert
      verify(() => service.register(any(), any(), any())).called(1);
      verify(() => log.error(
          'Email já cadastrado, por favor escolha outro e-mail',
          any(),
          any())).called(1);
    });

    test('Should throws generic exception', () async {
      // Arrange
      const name = 'Test';
      const email = 'test@test.com';
      const password = 'password';

      when(() => service.register(any(), any(), any())).thenThrow(Exception());

      //Act
      await controller.register(name, email, password);

      //Assert
      verify(() => service.register(any(), any(), any())).called(1);
      verify(() => log.error('Erro ao registrar usuário', any(), any()))
          .called(1);
    });
  });

  group('Group test login', () {
    test('Should login with success', () async {
      // Arrange
      const email = 'Test';
      const password = 'password';
      when(() => service.login(any(), any())).thenAnswer((_) async => _);
      //Act
      await controller.login(email, password);

      //Assert
      verify(() => service.login(any(), any())).called(1);
    });

    test('Should throws UserNotFoundException', () async {
      // Arrange
      const email = 'Test';
      const password = 'password';
      when(() => service.login(any(), any()))
          .thenThrow(UserNotFoundException());
      //Act
      await controller.login(email, password);

      //Assert
      verify(() => log.error('Login e senha inválidos', any(), any()))
          .called(1);
    });

    test('Should throws UnverifiedEmailException', () async {
      // Arrange
      const email = 'Test';
      const password = 'password';
      when(() => service.login(any(), any()))
          .thenThrow(UnverifiedEmailException());
      //Act
      await controller.login(email, password);

      //Assert
      verify(() => log.error('E-mail não verificado!', any(), any())).called(1);
    });

    test('Should throws generic exception', () async {
      // Arrange
      const email = 'Test';
      const password = 'password';
      when(() => service.login(any(), any())).thenThrow(Exception());
      //Act
      await controller.login(email, password);

      //Assert
      verify(() => log.error(
          'Erro ao realizar login tente novamente mais tarde!!!',
          any(),
          any())).called(1);
    });
  });
}