import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/rest_client/rest_client_exception.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service_impl.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  late HomeRepository repository;
  late HomeService service;

  setUp(() {
    repository = MockHomeRepository();
    service = HomeServiceImpl(repository: repository);
  });

  group('Group test fetchUserData', () {
    test('Should fetchUserData with success', () async {
      // Arrange
      final userExpected =
          UserModel(userId: 1, name: 'Test', email: 'test@domain.com');
      when(() => repository.fetchUserData())
          .thenAnswer((_) async => userExpected);
      //Act
      final user = await service.fetchUserData();
      //Assert
      expect(user, userExpected);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => repository.fetchUserData())
          .thenThrow(Failure());
      //Act
      final call = service.fetchUserData;
      //Assert
      expect(call, throwsA(isA<Failure>()));
    });
  });
}
