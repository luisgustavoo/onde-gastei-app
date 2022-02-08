import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/register_categories_page.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  static const router = '/category';

  @override
  Widget build(BuildContext context) {
    final categoriesController = context.read<CategoriesControllerImpl>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categorias'),
          actions: [
            IconButton(
              onPressed: () async {
                final edited = await Navigator.of(context)
                    .pushNamed(RegisterCategoriesPage.router);

                if (edited != null) {
                  if (edited is bool && edited == true) {
                    await categoriesController
                        .findCategories(userModel?.userId ?? 0);
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
              itemBuilder: (context, index) {
                final category = categoriesController.categoriesList[index];

                return ListTile(
                  key: Key('list_tile_key_${index}_categories_page'),
                  onTap: () async {
                    final edited = await Navigator.of(context).pushNamed(
                      RegisterCategoriesPage.router,
                      arguments: <String, dynamic>{
                        'category': category,
                        'editing': true,
                      },
                    );

                    if (edited != null) {
                      if (edited is bool && edited == true) {
                        await categoriesController
                            .findCategories(userModel?.userId ?? 0);
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
