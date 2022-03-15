import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/controllers/app_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';
import 'package:provider/provider.dart';

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

  final pages = <Widget>[
    const HomePage(),
    const ExpensesPage(),
    const CategoriesPage(),
    // Container(
    //   color: Colors.yellow,
    //   child: Center(
    //     child: TextButton(
    //       onPressed: () async {
    //         // TODO(logout): Apenas para teste retirar depois

    //         final authController = context.read<AuthControllerImpl>();
    //         await authController.logout();

    //         if (!mounted) {
    //           return;
    //         }

    //         await Navigator.of(context).pushNamedAndRemoveUntil(
    //           SplashPage.router,
    //           (route) => false,
    //         );
    //       },
    //       child: const Text('Logout'),
    //     ),
    //   ),
    // ),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // TODO(buscardadosiniciaisdoapp):  CARREGAR OS DADOS DAS TELAS HOME, EXPENSES, CATEGORIES E PERFIL

      // userModel = await widget.appController.fetchUserData();

      if (userModel != null) {
        final futures = [
          widget.appController.findCategories(userModel!.userId),
          widget.appController.findExpenses(
            dateFilter!.initialDate,
            dateFilter!.finalDate,
            userModel!.userId,
          ),
          widget.appController.fetchHomeData(
            userId: userModel!.userId,
            initialDate: dateFilter!.initialDate,
            finalDate: dateFilter!.finalDate,
          ),
        ];

        await Future.wait(futures);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<AppController>(
        builder: (_, appController, __) => IndexedStack(
          index: appController.tabIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: Consumer<AppController>(
        builder: (context, appController, _) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            currentIndex: appController.tabIndex,
            onTap: (currentIndex) {
              widget.appController.tabIndex = currentIndex;
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
              final futures = [
                widget.appController.findExpenses(
                  dateFilter!.initialDate,
                  dateFilter!.finalDate,
                  userModel!.userId,
                ),
                widget.appController.fetchHomeData(
                  userId: userModel!.userId,
                  initialDate: dateFilter!.initialDate,
                  finalDate: dateFilter!.finalDate,
                ),
              ];

              await Future.wait(futures);

              // await widget.appController.findExpenses(
              //   dateFilter!.initialDate,
              //   dateFilter!.finalDate,
              //   userModel!.userId,
              // );
              // await widget.appController.fetchHomeData(
              //   userId: userModel!.userId,
              //   initialDate: dateFilter!.initialDate,
              //   finalDate: dateFilter!.finalDate,
              // );
            }
          }
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
