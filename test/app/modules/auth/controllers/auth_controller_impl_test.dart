import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
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
}
