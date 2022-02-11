import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';

import '../../../../core/log/mock_log.dart';

class MockExpensesServices extends Mock implements ExpensesServices {}

class MockExpenseModel extends Mock implements ExpenseModel {}

void main() {
  late ExpensesServices mockServices;
  late Log mockLog;
  late ExpensesController controller;

  setUp(() {
    mockServices = MockExpensesServices();
    mockLog = MockLog();
    controller = ExpensesControllerImpl(
      services: mockServices,
      log: mockLog,
    );

    registerFallbackValue(MockExpenseModel());
  });

  group('Group test register', () {
    test('Should register expense with success', () async {
      // Arrange
      when(() => mockServices.register(any())).thenAnswer((_) async => _);

      //Act
      await controller.register(
        description: 'Test',
        value: 1,
        date: DateTime.now(),
        categoryId: 1,
        userId: 1,
      );

      //Assert
      verify(() => mockServices.register(any())).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => mockServices.register(any())).thenThrow(Exception());

      //Act
      final call = controller.register;

      //Assert
      expect(
        () => call(
          description: 'Test',
          value: 1,
          date: DateTime.now(),
          categoryId: 1,
          userId: 1,
        ),
        throwsA(isA<Failure>()),
      );
      verify(() => mockServices.register(any())).called(1);
    });
  });

  group('Group test update', () {
    test('Should update expense with success', () async {
      // Arrange
      when(() => mockServices.update(any(), any())).thenAnswer((_) async => _);

      //Act
      await controller.update(
        description: 'Test',
        value: 1,
        date: DateTime.now(),
        categoryId: 1,
        expenseId: 1,
      );

      //Assert
      verify(() => mockServices.update(any(), any())).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => mockServices.update(any(), any())).thenThrow(Exception());

      //Act
      final call = controller.update;

      //Assert
      expect(
        () => call(
          description: 'Test',
          value: 1,
          date: DateTime.now(),
          categoryId: 1,
          userId: 1,
          expenseId: 1,
        ),
        throwsA(isA<Failure>()),
      );
      verify(() => mockServices.update(any(), any())).called(1);
    });
  });

  group('Group test delete', () {
    test('Should delete expense with success', () async {
      // Arrange
      when(() => mockServices.delete(any())).thenAnswer((_) async => _);

      //Act
      await controller.delete(
        expenseId: 1,
      );

      //Assert
      verify(
        () => mockServices.delete(any()),
      ).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => mockServices.delete(any())).thenThrow(Exception());

      //Act
      final call = controller.delete;

      //Assert
      expect(
        () => call(
          expenseId: 1,
        ),
        throwsA(isA<Failure>()),
      );
      verify(() => mockServices.delete(any())).called(1);
    });
  });
}
