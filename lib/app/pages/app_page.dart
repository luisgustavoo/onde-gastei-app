import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/controllers/app_controller.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';
import 'package:onde_gastei_app/app/modules/splash/splash_page.dart';
import 'package:provider/provider.dart';

UserModel? userModel;

class AppPage extends StatefulWidget {
  const AppPage({
    required this.appController,
    Key? key,
  }) : super(key: key);
  static const router = '/app';

  final AppController appController;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 0;

  final initialDate = DateTime(DateTime.now().year, DateTime.now().month - 2);
  final finalDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
  ).subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // TODO(buscardadosiniciaisdoapp):  CARREGAR OS DADOS DAS TELAS HOME, EXPENSES, CATEGORIES E PERFIL

      userModel = await widget.appController.fetchUserData();

      if (userModel != null) {
        await widget.appController.findCategories(userModel!.userId);

        await widget.appController
            .findExpenses(initialDate, finalDate, userModel!.userId);

        // await widget.appController.fetchHomeData(
        //   userId: userModel!.userId,
        //   initialDate: initialDate,
        //   finalDate: finalDate,
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        onPageChanged: (pageIndex) {
          widget.appController.tabIndex = pageIndex;
        },
        controller: pageController,
        children: [
          const HomePage(),
          const ExpensesPage(),
          const CategoriesPage(),
          Container(
            color: Colors.yellow,
            child: Center(
              child: TextButton(
                onPressed: () async {
                  // TODO(logout): Apenas para teste retirar depois

                  final authController = context.read<AuthControllerImpl>();
                  await authController.logout();

                  if (!mounted) {
                    return;
                  }

                  await Navigator.of(context).pushNamedAndRemoveUntil(
                    SplashPage.router,
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Consumer<AppController>(
        builder: (context, appController, _) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: appController.tabIndex,
            onTap: (currentIndex) {
              pageController.animateToPage(
                currentIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final edited = await Navigator.of(context)
              .pushNamed(ExpensesRegisterPage.router) as bool?;
          if (edited != null) {
            if (edited) {
              await widget.appController
                  .findExpenses(initialDate, finalDate, userModel!.userId);
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
