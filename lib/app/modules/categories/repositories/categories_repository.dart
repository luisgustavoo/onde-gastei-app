import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/categories/view_model/category_input_model.dart';

abstract class CategoriesRepository {
  Future<void> register(CategoryModel categoryModel);
  Future<void> updateCategory(int categoryId, CategoryInputModel categoryInputModel);
}
