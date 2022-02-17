import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service_impl.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

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
      when(() => repository.fetchUserData()).thenThrow(Failure());
      //Act
      final call = service.fetchUserData;
      //Assert
      expect(call, throwsA(isA<Failure>()));
    });
  });

  group('Group test findTotalExpensesByCategories', () {
    test('Should findTotalExpensesByCategories with success', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();
      final totalExpensesCategoriesExpected = [
        TotalExpensesCategoriesViewModel(
          totalValue: 1,
          category: const CategoryModel(
            id: 1,
            description: 'Test',
            iconCode: 1,
            colorCode: 1,
          ),
        )
      ];
      when(
        () => repository.findTotalExpensesByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => totalExpensesCategoriesExpected);
      //Act
      final totalExpensesCategories = await service
          .findTotalExpensesByCategories(userId, initialDate, finalDate);
      //Assert
      expect(totalExpensesCategories, totalExpensesCategoriesExpected);
    });

    test('Should throws exceptions', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();
      when(() => repository.findTotalExpensesByCategories(any(), any(), any()))
          .thenThrow(Failure());
      //Act
      final call = service.findTotalExpensesByCategories;
      //Assert
      expect(
        () => call(userId, initialDate, finalDate),
        throwsA(isA<Failure>()),
      );
    });
  });

  group('Group test findPercentageByCategories', () {
    test('Should findPercentageByCategories with success', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      final percentageCategoriesExpected = [
        const PercentageCategoriesViewModel(
          value: 1,
          percentage: 1,
          category: CategoryModel(
            id: 1,
            description: 'Test',
            iconCode: 1,
            colorCode: 1,
          ),
        )
      ];

      when(
        () => repository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenAnswer((_) async => percentageCategoriesExpected);
      //Act
      final percentageCategories = await service.findPercentageByCategories(
        userId,
        initialDate,
        finalDate,
      );

      //Assert
      expect(percentageCategories, percentageCategoriesExpected);
    });

    test('Should throws exception', () async {
      // Arrange
      const userId = 1;
      final initialDate = DateTime.now();
      final finalDate = DateTime.now();

      when(
        () => repository.findPercentageByCategories(
          userId,
          initialDate,
          finalDate,
        ),
      ).thenThrow(Failure());
      //Act
      final call = service.findPercentageByCategories;

      //Assert
      expect(
        () => call(userId, initialDate, finalDate),
        throwsA(isA<Failure>()),
      );
    });
  });
}
