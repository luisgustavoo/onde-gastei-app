import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service_impl.dart';

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
      const categoryModel =
          CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1);
      when(() => repository.register(categoryModel)).thenAnswer((_) async => _);
      //Act
      await service.register(categoryModel);

      //Assert
      verify(() => repository.register(categoryModel)).called(1);
    });

    test('Should throws exception', () async {
      // Arrange
      const categoryModel =
          CategoryModel(id: 1, description: 'Test', iconCode: 1, colorCode: 1);
      when(() => repository.register(categoryModel)).thenThrow(Failure());
      //Act
      final call = service.register;

      //Assert
      expect(() => call(categoryModel), throwsA(isA<Failure>()));
      verify(() => repository.register(categoryModel)).called(1);
    });
  });
}
