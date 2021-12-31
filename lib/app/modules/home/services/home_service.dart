import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

abstract class HomeService {
  Future<UserModel> fetchUserData();

  Future<List<TotalExpensesCategoriesViewModel>> findTotalExpensesByCategories(
      int userId, DateTime initialDate, DateTime finalDate);

  Future<List<PercentageCategoriesViewModel>> findPercentageByCategories(
      int userId, DateTime initialDate, DateTime finalDate);
}
