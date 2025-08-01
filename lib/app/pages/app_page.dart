import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/user/pages/user_page.dart';
import 'package:provider/provider.dart';

class AppPage extends StatefulWidget {
  const AppPage({
    required this.userController,
    required this.homeController,
    required this.expensesController,
    required this.categoriesController,
    super.key,
  });
  static const router = '/app';

  final UserController userController;
  final HomeController homeController;
  final ExpensesController expensesController;
  final CategoriesController categoriesController;

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  int currentIndex = 0;
  final dateFilter = DateFilter(
    initialDate: DateTime(DateTime.now().year, DateTime.now().month),
    finalDate: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(const Duration(days: 1)),
  );

  late UserModel user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = context.read<UserControllerImpl>().user;

      final futures = [
        widget.homeController.fetchHomeData(
          userId: user.userId,
          initialDate: dateFilter.initialDate,
          finalDate: dateFilter.finalDate,
        ),
        widget.categoriesController.findCategories(user.userId),
        widget.expensesController.findExpensesByPeriod(
          userId: user.userId,
          initialDate: dateFilter.initialDate,
          finalDate: dateFilter.finalDate,
        ),
      ];

      await Future.wait(futures);
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarIconBrightness: Brightness.dark,
    //     statusBarColor: Colors.transparent,
    //   ),
    // );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        key: ValueKey<int>(currentIndex),
        index: currentIndex,
        children: [
          HomePage(
            homeController: widget.homeController,
            expensesController: widget.expensesController,
            dateFilter: dateFilter,
          ),
          ExpensesPage(
            expensesController: widget.expensesController,
            homeController: widget.homeController,
            dateFilter: dateFilter,
          ),
          CategoriesPage(
            categoriesController: widget.categoriesController,
            expensesController: widget.expensesController,
            homeController: widget.homeController,
            dateFilter: dateFilter,
          ),
          UserPage(userController: widget.userController),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (index) async {
          setState(() {
            currentIndex = index;
          });
          // widget.appController.tabIndex = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 20.h),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined, size: 20.h),
            label: 'Despesas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined, size: 20.h),
            label: 'Categorias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 20.h),
            label: 'Perfil',
          ),
        ],
      ),

      // Consumer<AppController>(
      //   builder: (context, appController, _) {
      //     return BottomNavigationBar(
      //       type: BottomNavigationBarType.fixed,
      //       elevation: 0,
      //       currentIndex: appController.tabIndex,
      //       onTap: (index) async {
      //         setState(() {
      //           currentIndex = index;
      //         });
      //         // widget.appController.tabIndex = index;
      //       },
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Icon(
      //             Icons.home_outlined,
      //           ),
      //           label: 'Home',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.list_alt_outlined),
      //           label: 'Extrato',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.category_outlined),
      //           label: 'Categorias',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.person_outline),
      //           label: 'Perfil',
      //         ),
      //       ],
      //     );
      //   },
      // ),
      floatingActionButton: SizedBox(
        height: 46.h,
        width: 46.w,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () async {
              final edited =
                  await Navigator.of(
                        context,
                      ).pushNamed(ExpensesRegisterPage.router)
                      as bool?;
              if (edited != null) {
                if (edited) {
                  final futures = [
                    widget.homeController.fetchHomeData(
                      userId: user.userId,
                      initialDate: dateFilter.initialDate,
                      finalDate: dateFilter.finalDate,
                    ),
                    // widget.categoriesController.findCategories(user.userId),
                    widget.expensesController.findExpensesByPeriod(
                      userId: user.userId,
                      initialDate: dateFilter.initialDate,
                      finalDate: dateFilter.finalDate,
                    ),
                  ];

                  await Future.wait(futures);
                }
              }
            },
            child: Icon(Icons.add, size: 20.sp),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
