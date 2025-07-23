import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';

import '../../../../core/log/mock_log.dart';

class MockExpensesServices extends Mock implements ExpensesServices {}

// class MockExpenseModel extends Mock implements ExpenseModel {}
class MockExpenseModel extends ExpenseModel {
  const MockExpenseModel({
    required super.description,
    required super.value,
    required super.date,
    required super.category,
  });
}

void main() {
  late ExpensesServices mockServices;
  late Log mockLog;
  late ExpensesController controller;

  setUp(() {
    mockServices = MockExpensesServices();
    mockLog = MockLog();
    controller = ExpensesControllerImpl(services: mockServices, log: mockLog);

    registerFallbackValue(
      MockExpenseModel(
        description: 'Test 1',
        value: 1,
        date: DateTime.now(),
        category: const CategoryModel(
          id: 1,
          description: 'Test',
          iconCode: 1,
          colorCode: 1,
          userId: 1,
        ),
      ),
    );
  });

  group('Group test register', () {
    test('Should register expense with success', () async {
      // Arrange
      when(
        () => mockServices.register(any()),
      ).thenAnswer((invocation) async => invocation);

      //Act
      await controller.register(
        description: 'Test',
        value: 1,
        date: DateTime.now(),
        local: 'Test',
        category: const CategoryModel(
          id: 1,
          description: 'Test',
          colorCode: 1,
          iconCode: 1,
          userId: 1,
        ),
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
          local: 'Test',
          category: const CategoryModel(
            id: 1,
            description: 'Test',
            colorCode: 1,
            iconCode: 1,
            userId: 1,
          ),
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
      when(
        () => mockServices.update(any(), any()),
      ).thenAnswer((invocation) async => invocation);

      //Act
      await controller.update(
        description: 'Test',
        value: 1,
        date: DateTime.now(),
        local: 'Test',
        category: const CategoryModel(
          id: 1,
          description: 'Test',
          colorCode: 1,
          iconCode: 1,
          userId: 1,
        ),
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
          local: 'Test',
          category: const CategoryModel(
            id: 1,
            description: 'Test',
            colorCode: 1,
            iconCode: 1,
            userId: 1,
          ),
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
      when(
        () => mockServices.delete(any()),
      ).thenAnswer((invocation) async => invocation);

      //Act
      await controller.delete(expenseId: 1);

      //Assert
      verify(() => mockServices.delete(any())).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => mockServices.delete(any())).thenThrow(Exception());

      //Act
      final call = controller.delete;

      //Assert
      expect(() => call(expenseId: 1), throwsA(isA<Failure>()));
      verify(() => mockServices.delete(any())).called(1);
    });
  });
}
