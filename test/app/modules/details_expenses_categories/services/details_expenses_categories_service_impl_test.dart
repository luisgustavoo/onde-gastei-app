import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/repositories/details_expenses_categories_repository.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/services/details_expenses_categories_service_impl.dart';

class MockDetailsExpensesCategoriesRepository extends Mock
    implements DetailsExpensesCategoriesRepository {}

void main() {
  late DetailsExpensesCategoriesRepository mockRepository;
  late DetailsExpensesCategoriesServiceImpl service;

  setUp(() {
    mockRepository = MockDetailsExpensesCategoriesRepository();
    service = DetailsExpensesCategoriesServiceImpl(repository: mockRepository);
  });

  group('Group test findExpensesByCategories', () {
    test('Should Expenses by category  with success', () async {
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
        ),
      ];

      when(
        () => mockRepository.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).thenAnswer((_) async => expensesCategoriesListExpected);

      //Act
      final expensesCategoriesList = await service.findExpensesByCategories(
        1,
        1,
        DateTime.now(),
        DateTime.now(),
      );
      //Assert
      expect(expensesCategoriesList, expensesCategoriesListExpected);
      verify(
        () => mockRepository.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });

    test('Should Expenses by category  throws Failure', () async {
      // Arrange
      when(
        () => mockRepository.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).thenThrow(Failure());

      //Act
      final call = service.findExpensesByCategories;
      //Assert
      expect(
        () => call(
          1,
          1,
          DateTime.now(),
          DateTime.now(),
        ),
        throwsA(isA<Failure>()),
      );

      verify(
        () => mockRepository.findExpensesByCategories(
          any(),
          any(),
          any(),
          any(),
        ),
      ).called(1);
    });
  });
}
