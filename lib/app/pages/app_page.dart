import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';
import 'package:onde_gastei_app/app/modules/splash/splash_page.dart';
import 'package:provider/provider.dart';

UserModel? userModel;

class AppPage extends StatefulWidget {
  const AppPage(
      {required this.homeController,
      required this.categoriesController,
      Key? key})
      : super(key: key);
  static const router = '/app';

  final HomeController homeController;
  final CategoriesController categoriesController;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 0;

  final initialDate = DateTime(DateTime.now().year, DateTime.now().month);
  final finalDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
  ).subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      userModel = await widget.homeController.fetchUserData();
      await widget.categoriesController.findCategories(userModel!.userId);

      await widget.homeController.fetchHomeData(
        userId: userModel?.userId ?? 0,
        initialDate: initialDate,
        finalDate: finalDate,
      );
      /*
       CARREGAR OS DADOS DAS TELAS
       HOME, EXPENSES, CATEGORIES E PERFIL
      */
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return Scaffold(
      body: PageView(
        onPageChanged: (pageIndex) {
          setState(() {
            currentIndex = pageIndex;
          });
        },
        controller: pageController,
        children: [
          HomePage(homeController: widget.homeController),
          Container(
            color: Colors.red,
          ),
          const CategoriesPage(),
          Container(
            color: Colors.yellow,
            child: Center(
              child: TextButton(
                onPressed: () async {
                  final localStorage =
                      context.read<SharedPreferencesLocalStorageImpl>();
                  await localStorage.logout();
                  await Navigator.of(context).pushNamedAndRemoveUntil(
                      SplashPage.router, (route) => false);
                },
                child: const Text('Logout'),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (currentIndex) {
          pageController.animateToPage(currentIndex,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Extrato',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
