import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services.dart';
import 'package:onde_gastei_app/app/modules/expenses/view_models/expenses_input_model.dart';

import '../../../../core/log/mock_log.dart';

class MockExpensesServices extends Mock implements ExpensesServices {}

class MockExpensesInputModel extends Mock implements ExpensesInputModel {}

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

    registerFallbackValue(MockExpensesInputModel());
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
}
