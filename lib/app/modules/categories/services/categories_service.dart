import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

abstract class CategoriesService {
  Future<void> register(CategoryModel categoryModel);
  Future<void> updateCategory(int categoryId, CategoryInputModel categoryInputModel);
  Future<void> deleteCategory(int categoryId);
}