import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.homeController, Key? key}) : super(key: key);

  static const router = '/home';

  final HomeController homeController;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      user = await widget.homeController.fetchUserData();

      final dateFormat = DateFormat('yyyy-MM-dd');

      final firstDay = DateTime(DateTime.now().year, DateTime.now().month);

      final initialDate = dateFormat.format(firstDay);

      await widget.homeController.fetchHomeData(
        userId: user!.userId,
        initialDate: DateTime(DateTime.now().year, DateTime.now().month),
        finalDate: DateTime(
          DateTime.now().year,
          DateTime.now().month + 1,
        ).subtract(const Duration(days: 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: Consumer<HomeControllerImpl>(
        builder: (context, homeController, _) {
          if (user == null) {
            return const Center(
              child: SizedBox(),
            );
          }

          return ListView(
            children: [
              Row(
                children: [Text('Olá ${user!.name}')],
              )
            ],
          );
        },
      ),
    );
  }
}
