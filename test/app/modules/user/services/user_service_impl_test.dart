import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service_impl.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository mockUserRepository;
  late UserServiceImpl service;

  setUp(() {
    mockUserRepository = MockUserRepository();
    service = UserServiceImpl(repository: mockUserRepository);
  });

  group('Group test fetchUserData', () {
    test('Should fetch user data with success', () async {
      const userExpected = UserModel(
        userId: 1,
        name: 'Test',
        email: 'test@domain.com',
        firebaseUserId: '123456',
      );
      when(() => mockUserRepository.fetchUserData()).thenAnswer(
        (_) async => userExpected,
      );

      final user = await service.fetchUserData();

      expect(user, userExpected);
      verify(() => mockUserRepository.fetchUserData()).called(1);
    });

    test('Should fetch user data with exception', () {
      when(() => mockUserRepository.fetchUserData()).thenThrow(Failure());

      final call = service.fetchUserData;

      expect(
        call,
        throwsA(
          isA<Failure>(),
        ),
      );
      verify(() => mockUserRepository.fetchUserData()).called(1);
    });
  });

  group('Group test updateUserName', () {
    test('Should update user name with success', () async {
      // Arrange
      when(
        () => mockUserRepository.updateUserName(any(), any()),
      ).thenAnswer((_) async => _);
      //Act
      await service.updateUserName(1, 'Test');

      //Assert
      verify(
        () => mockUserRepository.updateUserName(
          any(),
          any(),
        ),
      ).called(1);
    });

    test('Should update user name with exception', () async {
      // Arrange
      when(
        () => mockUserRepository.updateUserName(any(), any()),
      ).thenThrow(Failure());
      //Act
      final call = service.updateUserName;

      //Assert
      expect(() => call(1, 'Test'), throwsA(isA<Failure>()));
      verify(
        () => mockUserRepository.updateUserName(
          any(),
          any(),
        ),
      ).called(1);
    });
  });

  group('Group test removeLocalUserData', () {
    test('Should remove user data with success', () async {
      // Arrange
      when(
        () => mockUserRepository.removeLocalUserData(),
      ).thenAnswer((_) async => _);

      //Act
      await service.removeLocalUserData();

      //Assert
      verify(
        () => mockUserRepository.removeLocalUserData(),
      ).called(1);
    });
  });
}
