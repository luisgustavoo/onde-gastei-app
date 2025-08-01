import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_loading.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_register_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({
    required this.categoriesController,
    required this.expensesController,
    required this.homeController,
    required this.dateFilter,
    super.key,
  });

  static const router = '/categories';
  final CategoriesController categoriesController;
  final ExpensesController expensesController;
  final HomeController homeController;
  final DateFilter dateFilter;

  @override
  Widget build(BuildContext context) {
    // final user = context.select<UserControllerImpl, UserModel?>(
    //   (userController) => userController.user,
    // );

    final user = context.read<UserControllerImpl>().user;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text(
            'Categorias',
            // style: TextStyle(fontFamily: 'Jost'),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final edited =
                    await Navigator.of(
                          context,
                        ).pushNamed(CategoriesRegisterPage.router)
                        as bool?;

                if (edited != null) {
                  if (edited == true) {
                    await categoriesController.findCategories(user.userId);
                  }
                }
              },
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 20.h,
              ),
            ),
          ],
        ),
        body: Consumer<CategoriesControllerImpl>(
          builder: (context, categoriesController, _) {
            if (categoriesController.state == CategoriesState.error) {
              return const Center(child: Text('Erro ao buscar categorias'));
            }

            if (categoriesController.state == CategoriesState.loading) {
              return const OndeGasteiLoading();
            }

            if (categoriesController.categoriesList.isEmpty) {
              return const Center(child: Text('Nenhuma informação'));
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categoriesController.categoriesList.length,
              itemBuilder: (_, index) {
                final category = categoriesController.categoriesList[index];

                return ListTile(
                  key: Key('list_tile_key_${index}_categories_page'),
                  onTap: () async {
                    final edited =
                        await Navigator.of(context).pushNamed(
                              CategoriesRegisterPage.router,
                              arguments: <String, dynamic>{
                                'category': category,
                                'editing': true,
                              },
                            )
                            as bool?;

                    if (edited != null) {
                      if (edited == true) {
                        final futures = [
                          homeController.fetchHomeData(
                            userId: user.userId,
                            initialDate: dateFilter.initialDate,
                            finalDate: dateFilter.finalDate,
                          ),
                          categoriesController.findCategories(user.userId),
                          expensesController.findExpensesByPeriod(
                            userId: user.userId,
                            initialDate: dateFilter.initialDate,
                            finalDate: dateFilter.finalDate,
                          ),
                        ];

                        await Future.wait(futures);
                      }
                    }
                  },
                  leading: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Color(category.colorCode),
                    child: Icon(
                      IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                      size: 20.h,
                    ),
                  ),
                  title: Text(
                    category.description,
                    style: TextStyle(fontSize: 13.sp),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
