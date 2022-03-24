import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/logs/log.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/controllers/details_expenses_categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/services/details_expenses_categories_service.dart';

import '../../../../core/log/mock_log.dart';

class MockDetailsExpensesCategoriesService extends Mock
    implements DetailsExpensesCategoriesService {}

void main() {
  late Log mockLog;
  late DetailsExpensesCategoriesService mockService;
  late DetailsExpensesCategoriesControllerImpl controller;

  setUp(() {
    mockService = MockDetailsExpensesCategoriesService();
    mockLog = MockLog();
    controller = DetailsExpensesCategoriesControllerImpl(
      service: mockService,
      log: mockLog,
    );
  });

  group('Group test findExpensesByCategories', () {
    test('Should find expenses by category with success', () async {
      // Arrange
      final expensesCategoriesListExpected = [
        ExpenseModel(
          expenseId: 76,
          description: 'Livro Como Fazer Amigos e Influenciar Pessoas',
          value: 28,
          date: DateTime(2022, 03, 10),
          category: const CategoryModel(
            id: 110050,
            description: 'Compras',
            iconCode: 58266,
            colorCode: 4294924066,
          ),
        )
      ];

      when(
        () => mockService.findExpensesByCategories(any(), any(), any(), any()),
      ).thenAnswer((_) async => expensesCategoriesListExpected);

      //Act
      final expensesCategoriesList = await controller.findExpensesByCategories(
        1,
        1,
        DateTime.now(),
        DateTime.now(),
      );

      //Assert
      expect(expensesCategoriesList, expensesCategoriesListExpected);
      verify(
        () => mockService.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });

    test('Should find expenses by category empty list', () async {
      // Arrange

      when(
        () => mockService.findExpensesByCategories(any(), any(), any(), any()),
      ).thenAnswer((_) async => <ExpenseModel>[]);

      //Act
      final expensesCategoriesList = await controller.findExpensesByCategories(
        1,
        1,
        DateTime.now(),
        DateTime.now(),
      );

      //Assert
      expect(expensesCategoriesList, <ExpenseModel>[]);
      verify(
        () => mockService.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });

    test('Should find expenses by category throws exception', () async {
      // Arrange

      when(
        () => mockService.findExpensesByCategories(any(), any(), any(), any()),
      ).thenThrow(Failure());

      //Act
      final call = controller.findExpensesByCategories;

      //Assert
      expect(
        () => call(
          1,
          1,
          DateTime.now(),
          DateTime.now(),
        ),
        throwsA(
          isA<Failure>(),
        ),
      );
      verify(
        () => mockService.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });
  });
}
