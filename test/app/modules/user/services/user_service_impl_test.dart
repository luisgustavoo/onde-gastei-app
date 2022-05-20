import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service_impl.dart';

class MockProfileRepository extends Mock implements UserRepository {}

void main() {
  late UserRepository mockProfileRepository;
  late UserServiceImpl service;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    service = UserServiceImpl(repository: mockProfileRepository);
  });

  group('Group test updateUserName', () {
    test('Should update user name with success', () async {
      // Arrange
      when(
        () => mockProfileRepository.updateUserName(any(), any()),
      ).thenAnswer((_) async => _);
      //Act
      await service.updateUserName(1, 'Test');

      //Assert
      verify(
        () => mockProfileRepository.updateUserName(
          any(),
          any(),
        ),
      ).called(1);
    });

    test('Should update user name throws exception', () async {
      // Arrange
      when(
        () => mockProfileRepository.updateUserName(any(), any()),
      ).thenThrow(Failure());
      //Act
      final call = service.updateUserName;

      //Assert
      expect(() => call(1, 'Test'), throwsA(isA<Failure>()));
      verify(
        () => mockProfileRepository.updateUserName(
          any(),
          any(),
        ),
      ).called(1);
    });
  });
}
