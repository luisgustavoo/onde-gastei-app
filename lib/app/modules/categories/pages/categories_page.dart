import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_register_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  static const router = '/categories';

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final categoriesController = context.read<CategoriesControllerImpl>();
    final expensesController = context.read<ExpensesControllerImpl>();
    final homeController = context.read<HomeControllerImpl>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categorias'),
          actions: [
            IconButton(
              onPressed: () async {
                final edited = await Navigator.of(context)
                    .pushNamed<bool?>(CategoriesRegisterPage.router);

                if (edited != null) {
                  if (edited == true) {
                    await categoriesController
                        .findCategories(userModel!.userId);
                  }
                }
              },
              icon: Icon(
                Icons.add_circle,
                color: Theme.of(context).primaryColor,
                size: 30.sp,
              ),
            )
          ],
        ),
        body: Consumer<CategoriesControllerImpl>(
          builder: (context, categoriesController, _) {
            if (categoriesController.state == categoriesState.error) {
              return const Center(
                child: Text('Erro ao buscar categorias'),
              );
            }

            if (categoriesController.state == categoriesState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.w,
                ),
              );
            }

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: categoriesController.categoriesList.length,
              itemBuilder: (_, index) {
                final category = categoriesController.categoriesList[index];

                return ListTile(
                  key: Key('list_tile_key_${index}_categories_page'),
                  onTap: () async {
                    final edited = await Navigator.of(context).pushNamed<bool?>(
                      CategoriesRegisterPage.router,
                      arguments: <String, dynamic>{
                        'category': category,
                        'editing': true,
                      },
                    );

                    if (edited != null) {
                      if (edited == true) {
                        final futures = [
                          categoriesController
                              .findCategories(userModel!.userId),
                          expensesController.findExpensesByPeriod(
                            userId: userModel!.userId,
                            initialDate: dateFilter!.initialDate,
                            finalDate: dateFilter!.finalDate,
                          ),
                          homeController.fetchHomeData(
                            userId: userModel!.userId,
                            initialDate: dateFilter!.initialDate,
                            finalDate: dateFilter!.finalDate,
                          )
                        ];

                        await Future.wait(futures);
                      }
                    }
                  },
                  leading: CircleAvatar(
                    backgroundColor: Color(category.colorCode),
                    child: Icon(
                      IconData(category.iconCode, fontFamily: 'MaterialIcons'),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    category.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
