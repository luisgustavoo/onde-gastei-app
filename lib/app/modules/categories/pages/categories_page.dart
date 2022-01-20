import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/register_update_categories_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({required this.categoriesController, Key? key})
      : super(key: key);

  static const router = '/category';

  final CategoriesController categoriesController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(RegisterUpdateCategoriesPage.router);
            },
            icon: Icon(
              Icons.add_circle,
              color: Theme.of(context).primaryColor,
              size: 30.sp,
            ),
          )
        ],
      ),
    ));
  }
}
