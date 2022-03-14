import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/splash/controllers/splash_controller.dart';

import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';

void main() {
  late LocalStorage mockLocalStorage;
  late Log mockLog;
  late SplashController controller;

  setUp(() {
    mockLocalStorage = MockLocalStorage();
    mockLog = MockLog();
    controller = SplashController(localStorage: mockLocalStorage, log: mockLog);
  });

  group('Group test getUser', () {
    test('Should user is logged', () async {
      // Arrange
      const localUser =
          '''
        {
            "id_usuario": 1,
            "nome": "test",
            "email": "test@domain.com"
        }
      ''';
      final userExpected = UserModel(
        userId: 1,
        name: 'test',
        email: 'test@domain.com',
      );

      when(() => mockLocalStorage.read<String>('user'))
          .thenAnswer((_) async => localUser);
      //Act
      final user = await controller.getUser();

      //Assert
      expect(user, isNotNull);
      expect(user, userExpected);
      verify(() => mockLocalStorage.read<String>('user')).called(1);
    });

    test('Should user is not logged', () async {
      // Arrange
      when(() => mockLocalStorage.read<String>('user'))
          .thenAnswer((_) async => null);
      //Act
      final user = await controller.getUser();

      //Assert
      expect(user, isNull);
      verify(() => mockLocalStorage.read<String>('user')).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => mockLocalStorage.read<String>('user')).thenThrow(Exception());
      //Act
      final call = controller.getUser;

      //Assert
      expect(call, throwsA(isA<Failure>()));
    });
  });
}
