import 'package:firebase_auth/firebase_auth.dart';

// import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_services_impl.dart';

import '../../../../core/local_security_storage/mock_local_security_storage.dart';
import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';
import '../mocks/mock_firebase_auth.dart';
import '../mocks/mock_user.dart';
import '../mocks/mock_user_credential.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LocalStorage localStorage;
  late LocalSecurityStorage localSecurityStorage;
  late Log log;
  late AuthRepository repository;
  late AuthServicesImpl service;
  late FirebaseAuth firebaseAuth;

  setUp(() {
    localStorage = MockLocalStorage();
    localSecurityStorage = MockLocalSecurityStorage();
    log = MockLog();
    repository = MockAuthRepository();
    firebaseAuth = MockFirebaseAuth();
    service = AuthServicesImpl(
      repository: repository,
      localStorage: localStorage,
      localSecurityStorage: localSecurityStorage,
      log: log,
      firebaseAuth: firebaseAuth,
    );
  });

  group('Group test register', () {
    test('Should register with success', () async {
      // Arrange
      const name = 'Bla bla';
      const email = 'bob@somedomain.com';
      const password = 'password';
      final mockUser = MockUser(uid: 'uid', displayName: 'Test');
      final credentialUser = MockUserCredential(mockUser: mockUser);
      when(() => repository.register(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => _);

      when(() => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => credentialUser);

      when(mockUser.sendEmailVerification).thenAnswer((_) async => _);
      //Act
      await service.register(name, email, password);

      //Assert
      verify(() => repository.register(name, email, password)).called(1);
      verify(() => firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).called(1);
    });

    test('Should firebaseAuth.user is null', () async {
      // Arrange
      const name = 'Bla bla';
      const email = 'bob@somedomain.com';
      const password = 'password';
      final credentialUser = MockUserCredential();
      when(() => repository.register(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => _);

      when(() => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => credentialUser);

      //Act
      await service.register(name, email, password);

      //Assert
      verify(() => repository.register(name, email, password)).called(1);
      verify(() => firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password)).called(1);
      verifyNever(() => MockUser().sendEmailVerification());
    });

    test('Should throws FirebaseAuthException', () async {
      // Arrange
      const name = 'Bla bla';
      const email = 'bob@somedomain.com';
      const password = 'password';

      when(() => repository.register(
            any(),
            any(),
            any(),
          )).thenAnswer((_) async => _);

      when(() => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(code: ''));

      //Act
      final call = service.register;

      //Assert
      expect(() => call(name, email, password),
          throwsA(isA<Failure>()));
      verify(() => repository.register(
            any(),
            any(),
            any(),
          )).called(1);
      verifyNever(() => MockUser().sendEmailVerification());
    });
  });
}
