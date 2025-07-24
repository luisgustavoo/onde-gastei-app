import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

class MockCategoriesRepository extends Mock implements CategoriesRepository {}

void main() {
  late CategoriesRepository repository;
  late CategoriesService service;

  setUp(() {
    repository = MockCategoriesRepository();
    service = CategoriesServiceImpl(repository: repository);
  });

  group('Group test register', () {
    test('Should register with success', () async {
      // Arrange
      const categoryModel = CategoryModel(
        id: 1,
        description: 'Test',
        iconCode: 1,
        colorCode: 1,
      );
      when(
        () => repository.register(categoryModel),
      ).thenAnswer((invocation) async => invocation);
      //Act
      await service.register(categoryModel);

      //Assert
      verify(() => repository.register(categoryModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      const categoryModel = CategoryModel(
        id: 1,
        description: 'Test',
        iconCode: 1,
        colorCode: 1,
      );
      when(() => repository.register(categoryModel)).thenThrow(Failure());
      //Act
      final call = service.register;

      //Assert
      expect(() => call(categoryModel), throwsA(isA<Failure>()));
      verify(() => repository.register(categoryModel)).called(1);
    });
  });

  group('Group test updateCategory', () {
    test('Should update category with success', () async {
      // Arrange
      const categoryInputModel = CategoryInputModel(
        description: 'Test',
        iconCode: 1,
        colorCode: 1,
      );
      when(
        () => repository.updateCategory(1, categoryInputModel),
      ).thenAnswer((invocation) async => invocation);
      //Act
      await service.updateCategory(1, categoryInputModel);

      //Assert
      verify(() => repository.updateCategory(1, categoryInputModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      const categoryInputModel = CategoryInputModel(
        description: 'Test',
        iconCode: 1,
        colorCode: 1,
      );
      when(
        () => repository.updateCategory(1, categoryInputModel),
      ).thenThrow(Failure());
      //Act
      final call = service.updateCategory;

      //Assert
      expect(() => call(1, categoryInputModel), throwsA(isA<Failure>()));
      verify(() => repository.updateCategory(1, categoryInputModel)).called(1);
    });
  });

  group('group test delete category', () {
    test('Should deleteCategory with success', () async {
      // Arrange
      when(
        () => repository.deleteCategory(1),
      ).thenAnswer((invocation) async => invocation);
      //Act
      await service.deleteCategory(1);

      //Assert
      verify(() => repository.deleteCategory(1)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      when(() => repository.deleteCategory(1)).thenThrow(Failure());
      //Act
      final call = service.deleteCategory;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
      verify(() => repository.deleteCategory(1)).called(1);
    });
  });

  group('Group test findCategories', () {
    test('Should find categories with success', () async {
      //Arrange
      const categoriesExpected = [
        CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1),
      ];
      when(
        () => repository.findCategories(any()),
      ).thenAnswer((_) async => categoriesExpected);
      //Act
      await service.findCategories(1);

      //Assert
      verify(() => service.findCategories(any())).called(1);
    });
  });

  group('Group test expenseQuantityByCategoryId', () {
    test('Should to fetch the amount of expenses from a category', () async {
      //Arrange
      when(
        () => repository.expenseQuantityByCategoryId(1),
      ).thenAnswer((_) async => 1);

      //Act
      final quantity = await service.expenseQuantityByCategoryId(1);

      //Assert
      expect(quantity, 1);
    });

    test('Should return exception', () async {
      //Arrange
      when(
        () => repository.expenseQuantityByCategoryId(1),
      ).thenThrow(Failure());

      //Act
      final call = service.expenseQuantityByCategoryId;

      //Assert
      expect(() => call(1), throwsA(isA<Failure>()));
    });
  });
}
