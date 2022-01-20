import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/pages/home_page.dart';

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

  @override
  void initState() {
    super.initState();

    /*
       CARREGAR OS DADOS DAS TELAS
       HOME, EXPENSES, CATEGORIES E PERFIL
    */
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
          CategoriesPage(
            categoriesController: widget.categoriesController,
          ),
          Container(
            color: Colors.yellow,
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
            label: 'Categoria',
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
