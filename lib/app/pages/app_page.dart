import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/controllers/app_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: IndexedStack(
          key: ValueKey<int>(currentIndex),
          index: currentIndex,
          children: const [
            HomePage(),
            ExpensesPage(),
            CategoriesPage(),
          ],
        ),

        // Consumer<AppController>(
        //   key: ValueKey<int>(currentIndex),
        //   builder: (_, appController, __) {
        //     return IndexedStack(
        //       index: appController.tabIndex,
        //       children: pages,
        //     );
        //   },
        // ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final edited = await Navigator.of(context)
              .pushNamed<bool?>(ExpensesRegisterPage.router);
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
