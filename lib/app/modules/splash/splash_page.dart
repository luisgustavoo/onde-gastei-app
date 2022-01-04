import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/core/pages/app_page.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.authController,required this.homeController, Key? key}) : super(key: key);

  static const router = '/splash';

  final AuthController authController;
  final HomeController homeController;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final initialDate = DateTime(DateTime.now().year, DateTime.now().month);
  final finalDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
  ).subtract(
    const Duration(days: 1),
  );

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (await widget.authController.isLogged()) {

        final user = await widget.homeController.fetchUserData();

        await widget.homeController.fetchHomeData(
          userId: user.userId,
          initialDate: initialDate,
          finalDate: finalDate,
        );
        await OndeGasteiNavigator.to!.pushReplacementNamed(AppPage.router);
      } else {
        await OndeGasteiNavigator.to!.pushReplacementNamed(LoginPage.router);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Logo(),
      ),
    );
  }
}
