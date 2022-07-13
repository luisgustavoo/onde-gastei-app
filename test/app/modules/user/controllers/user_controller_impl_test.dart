import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service.dart';

class MockUserService extends Mock implements UserService {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockLog extends Mock implements Log {}

void main() {
  late UserService mockUserService;
  late LocalStorage mockLocalStorage;
  late Log mockLog;
  late UserController controller;

  setUp(() {
    mockUserService = MockUserService();
    mockLocalStorage = MockLocalStorage();
    mockLog = MockLog();
    controller = UserControllerImpl(
      service: mockUserService,
      localStorage: mockLocalStorage,
      log: mockLog,
    );
  });

  group('Group test fetchUserData', () {
    test('Should fetchUserData with success', () async {
      //Arrange
      const userExpected = UserModel(
        userId: 1,
        name: 'Test',
        firebaseUserId: '123456',
      );

      when(() => mockUserService.fetchUserData())
          .thenAnswer((_) async => userExpected);

      //Act
      await controller.fetchUserData();

      //Assert
      verify(() => mockUserService.fetchUserData()).called(1);
    });

    test('Should fetchUserData with exception', () async {
      //Arrange

      when(() => mockUserService.fetchUserData()).thenThrow(Exception());

      //Act
      final call = controller.fetchUserData;

      //Assert
      expect(call, throwsA(isA<Failure>()));
      verify(() => mockUserService.fetchUserData()).called(1);
      verify(() => mockLog.error(any(), any(), any())).called(1);
    });
  });

  group('Group test updateUserName', () {
    test('Should updateUserName with success', () async {
      //Arrange
      const userExpected = UserModel(
        userId: 1,
        name: 'Test',
        firebaseUserId: '123456',
      );

      when(() => mockUserService.updateUserName(any(), any()))
          .thenAnswer((_) async => _);

      when(() => mockUserService.removeLocalUserData())
          .thenAnswer((_) async => _);

      when(() => mockUserService.fetchUserData())
          .thenAnswer((_) async => userExpected);

      //Act
      await controller.updateUserName(1, 'Test');

      //Assert
      verify(() => mockUserService.updateUserName(any(), any())).called(1);
      verify(() => mockUserService.removeLocalUserData()).called(1);
      verify(() => mockUserService.fetchUserData()).called(1);
    });

    test('Should updateUserName with exception', () async {
      //Arrange

      when(() => mockUserService.updateUserName(any(), any()))
          .thenThrow(Exception());

      //Act
      final call = controller.updateUserName;

      //Assert
      expect(call(1, 'Test'), throwsA(isA<Failure>()));
      verifyNever(() => mockUserService.removeLocalUserData());
      verifyNever(() => mockUserService.fetchUserData());
    });
  });

  group('Group test getLocalUser', () {
    test('Should get user with success', () async {
      //Arrange
      const localUser =
          UserModel(userId: 1, name: 'Test', firebaseUserId: '123456');
      when(() => mockLocalStorage.read<String>(any())).thenAnswer(
        (_) async => jsonEncode(
          localUser.toMap(),
        ),
      );

      //Act
      final user = await controller.getLocalUser();

      //Assert
      expect(user, localUser);
      verify(
        () => mockLocalStorage.read<String>(any()),
      ).called(1);
    });

    test('Should get user with exception', () async {
      //Arrange

      when(() => mockLocalStorage.read<String>(any())).thenThrow(Exception());

      //Act
      final call = controller.getLocalUser;

      //Assert
      expect(call, throwsA(isA<Failure>()));
      verify(
        () => mockLocalStorage.read<String>(any()),
      ).called(1);
      verify(
        () => mockLog.error(
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });
  });
}
