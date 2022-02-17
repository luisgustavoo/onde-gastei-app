import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services_impl.dart';

class MockExpensesRepository extends Mock implements ExpensesRepository {}

void main() {
  late ExpensesRepository repository;
  late ExpensesServices services;

  final expenseModel = ExpenseModel(
    description: 'Test',
    date: DateTime.now(),
    value: 1,
    userId: 1,
    category: const CategoryModel(
      id: 1,
      description: 'Test',
      colorCode: 1,
      iconCode: 1,
      userId: 1,
    ),
  );

  setUp(() {
    repository = MockExpensesRepository();
    services = ExpensesServicesImpl(repository: repository);
  });

  group('Group test register', () {
    test('Should register expense with success', () async {
      // Arrange
      when(() => repository.register(expenseModel)).thenAnswer((_) async => _);
      //Act
      await services.register(expenseModel);

      //Assert
      verify(() => repository.register(expenseModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => repository.register(expenseModel)).thenThrow(Failure());
      //Act
      final call = services.register;

      //Assert
      expect(() => call(expenseModel), throwsA(isA<Failure>()));
      verify(() => repository.register(expenseModel)).called(1);
    });
  });

  group('Group test update', () {
    test('Should update expense with success', () async {
      // Arrange
      when(() => repository.update(expenseModel, 1)).thenAnswer((_) async => _);
      //Act
      await services.update(expenseModel, 1);

      //Assert
      verify(() => repository.update(expenseModel, 1)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => repository.update(expenseModel, 1)).thenThrow(Failure());
      //Act
      final call = services.update;

      //Assert
      expect(() => call(expenseModel, 1), throwsA(isA<Failure>()));
      verify(() => repository.update(expenseModel, 1)).called(1);
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
