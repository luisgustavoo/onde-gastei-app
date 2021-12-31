import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/percentage_categories_view_model.dart';
import 'package:onde_gastei_app/app/modules/home/view_model/total_expenses_categories_view_model.dart';

class HomeServiceImpl implements HomeService {
  HomeServiceImpl({required HomeRepository repository})
      : _repository = repository;

  final HomeRepository _repository;

  @override
  Future<UserModel> fetchUserData() => _repository.fetchUserData();

  @override
  Future<List<TotalExpensesCategoriesViewModel>> findTotalExpensesByCategories(
          int userId, DateTime initialDate, DateTime finalDate) =>
      _repository.findTotalExpensesByCategories(userId, initialDate, finalDate);

  @override
  Future<List<PercentageCategoriesViewModel>> findPercentageByCategories(
          int userId, DateTime initialDate, DateTime finalDate) =>
      _repository.findPercentageByCategories(userId, initialDate, finalDate);
}
