import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  late ExpensesRepository repository;
  late ExpensesServices services;

  setUp(() {
    repository = MockExpensesRepository();
    services = ExpensesServicesImpl(repository: repository);
  });

  group('Group test register', () {
    test('Should register expense with success', () async {
      // Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
        userId: 1,
      );
      when(() => repository.register(expensesInputModel))
          .thenAnswer((_) async => _);
      //Act
      await services.register(expensesInputModel);

      //Assert
      verify(() => repository.register(expensesInputModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
        userId: 1,
      );
      when(() => repository.register(expensesInputModel)).thenThrow(Failure());
      //Act
      final call = services.register;

      //Assert
      expect(() => call(expensesInputModel), throwsA(isA<Failure>()));
      verify(() => repository.register(expensesInputModel)).called(1);
    });
  });

  group('Group test update', () {
    test('Should update expense with success', () async {
      // Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
        userId: 1,
      );
      when(() => repository.update(expensesInputModel, 1))
          .thenAnswer((_) async => _);
      //Act
      await services.update(expensesInputModel, 1);

      //Assert
      verify(() => repository.update(expensesInputModel, 1)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      final expensesInputModel = ExpensesInputModel(
        description: 'Test',
        date: DateTime.now(),
        value: 1,
        categoryId: 1,
        userId: 1,
      );
      when(() => repository.update(expensesInputModel, 1)).thenThrow(Failure());
      //Act
      final call = services.update;

      //Assert
      expect(() => call(expensesInputModel, 1), throwsA(isA<Failure>()));
      verify(() => repository.update(expensesInputModel, 1)).called(1);
    });
  });

  group('Group test delete', () {
    test('Should delete expense with success', () async {
      // Arrange
      when(() => repository.delete(any())).thenAnswer((_) async => _);
      //Act
      await services.delete(1);

      //Assert
      verify(() => repository.delete(any())).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => repository.delete(any())).thenThrow(Failure());
      //Act
      final call = services.delete;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
      verify(() => repository.delete(any())).called(1);
    });
  });
}
