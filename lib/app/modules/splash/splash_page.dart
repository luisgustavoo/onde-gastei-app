import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.authController, Key? key}) : super(key: key);

  static const router = '/splash';

  final AuthController authController;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (await widget.authController.isLogged()) {
        await Navigator.of(context).pushReplacementNamed(AppPage.router);
      } else {
        await Navigator.of(context).pushReplacementNamed(LoginPage.router);
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
