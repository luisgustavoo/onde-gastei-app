import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_security_storage.dart';
import 'package:onde_gastei_app/app/core/local_storages/local_storage.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/confirm_login_model.dart';
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
      const email = 'teste@somedomain.com';
      const password = 'password';
      final mockFirebaseUser = MockUser(uid: 'uid', displayName: 'Test');
      final mockCredentialFirebaseUser =
          MockUserCredential(mockUser: mockFirebaseUser);
      when(
        () => repository.register(
          any(),
          any(),
          any(),
        ),
      ).thenAnswer((_) async => _);

      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockCredentialFirebaseUser);

      when(mockFirebaseUser.sendEmailVerification).thenAnswer((_) async => _);
      //Act
      await service.register(name, email, password);

      //Assert
      expect(mockCredentialFirebaseUser.user, isNotNull);
      verify(() => repository.register(name, email, password)).called(1);
      verify(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
    });

    test('Should Firebase User is null', () async {
      // Arrange
      const name = 'Test';
      const email = 'test@somedomain.com';
      const password = 'password';
      final mockCredentialFirebaseUser = MockUserCredential();
      when(
        () => repository.register(
          any(),
          any(),
          any(),
        ),
      ).thenAnswer((_) async => _);

      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockCredentialFirebaseUser);

      //Act
      await service.register(name, email, password);

      //Assert
      expect(mockCredentialFirebaseUser.user, isNull);
      verify(() => repository.register(name, email, password)).called(1);
      verify(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
      verifyNever(() => MockUser().sendEmailVerification());
    });

    test('Should throws FirebaseAuthException', () async {
      // Arrange
      const name = 'Test';
      const email = 'test@somedomain.com';
      const password = 'password';

      when(
        () => repository.register(
          any(),
          any(),
          any(),
        ),
      ).thenAnswer((_) async => _);

      when(
        () => firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: ''));

      //Act
      final call = service.register;

      //Assert
      expect(() => call(name, email, password), throwsA(isA<Failure>()));
      verify(
        () => repository.register(
          any(),
          any(),
          any(),
        ),
      ).called(1);
      verifyNever(() => MockUser().sendEmailVerification());
    });
  });

  group('Group test login', () {
    test('Should login with success', () async {
      // Arrange
      const email = 'test@somedomain.com';
      const password = 'password';
      final mockFirebaseUser = MockUser(uid: 'uid', displayName: 'Test');
      final mockCredentialFirebaseUser =
          MockUserCredential(mockUser: mockFirebaseUser);

      final confirmLoginModel = ConfirmLoginModel(
        accessToken: 'Bearer test',
        refreshToken: 'Bearer test',
      );

      when(() => mockCredentialFirebaseUser.user?.emailVerified)
          .thenReturn(true);

      when(() => repository.login(any(), any()))
          .thenAnswer((_) async => 'Bearer test');

      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockCredentialFirebaseUser);

      when(() => repository.confirmLogin())
          .thenAnswer((_) async => confirmLoginModel);

      when(() => localStorage.write(any(), any<String>()))
          .thenAnswer((_) async => _);

      when(() => localSecurityStorage.write(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      await service.login(email, password);

      //Assert
      expect(mockCredentialFirebaseUser.user, isNotNull);
      verify(() => repository.login(any(), any())).called(1);
      verify(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
      verify(() => mockFirebaseUser.emailVerified).called(1);
    });

    test('Should Firebase User is null', () async {
      // Arrange
      const email = 'test@somedomain.com';
      const password = 'password';
      final mockCredentialFirebaseUser = MockUserCredential();

      final confirmLoginModel = ConfirmLoginModel(
        accessToken: 'Bearer test',
        refreshToken: 'Bearer test',
      );

      when(() => repository.login(any(), any()))
          .thenAnswer((_) async => 'Bearer test');

      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockCredentialFirebaseUser);

      when(() => repository.confirmLogin())
          .thenAnswer((_) async => confirmLoginModel);

      when(() => localStorage.write(any(), any<String>()))
          .thenAnswer((_) async => _);

      when(() => localSecurityStorage.write(any(), any()))
          .thenAnswer((_) async => _);
      //Act
      await service.login(email, password);

      //Assert
      expect(mockCredentialFirebaseUser.user, isNull);
      verify(() => repository.login(any(), any())).called(1);
      verify(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).called(1);
    });

    test(
        'Should Firebase User email is not verified (UnverifiedEmailException)',
        () async {
      const email = 'test@somedomain.com';
      const password = 'password';
      final mockFirebaseUser = MockUser(uid: 'uid', displayName: 'Test');
      final mockCredentialFirebaseUser =
          MockUserCredential(mockUser: mockFirebaseUser);

      when(() => mockCredentialFirebaseUser.user!.emailVerified)
          .thenReturn(false);

      when(() => repository.login(email, password))
          .thenAnswer((_) async => 'Bearer test');

      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenAnswer((_) async => mockCredentialFirebaseUser);

      //Act
      final call = service.login;

      //Assert

      expect(
        () => call(email, password),
        throwsA(isA<UnverifiedEmailException>()),
      );
      expect(mockCredentialFirebaseUser.user, isNotNull);
    });

    test('Should Should throws FirebaseAuthException', () async {
      // Arrange
      const email = 'test@somedomain.com';
      const password = 'password';

      when(() => repository.login(email, password))
          .thenAnswer((_) async => 'Bearer test');

      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(FirebaseAuthException(code: ''));

      //Act
      final call = service.login;

      //Assert
      expect(() => call(email, password), throwsA(isA<Failure>()));
    });

    test('Should generic exception', () async {
      // Arrange
      const email = 'test@somedomain.com';
      const password = 'password';

      when(() => repository.login(email, password))
          .thenAnswer((_) async => 'Bearer test');

      when(
        () => firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ),
      ).thenThrow(Exception());

      //Act
      final call = service.login;

      //Assert
      expect(() => call(email, password), throwsA(isA<Failure>()));
    });
  });
}
