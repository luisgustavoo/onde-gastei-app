import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/splash/controllers/splash_controller.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.splashController, Key? key})
      : super(key: key);

  static const router = '/splash';

  final SplashController splashController;

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    final initialDate = DateTime(DateTime.now().year, DateTime.now().month);
    final finalDate = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(
      const Duration(days: 1),
    );

    dateFilter = DateFilter(initialDate: initialDate, finalDate: finalDate);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.splashController.getUser().then((user) {
        if (user != null) {
          userModel = user;
          Navigator.of(context).pushReplacementNamed(
            AppPage.router,
          );
        } else {
          Navigator.of(context).pushReplacementNamed(LoginPage.router);
        }
      });
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
