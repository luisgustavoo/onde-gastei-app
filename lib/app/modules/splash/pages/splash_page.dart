import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_loading.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    required this.userController,
    super.key,
  });

  static const router = '/splash';

  final UserController userController;

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final nav = Navigator.of(context);
      await widget.userController.getLocalUser().then((user) {
        if (user != null) {
          nav.pushReplacementNamed(
            AppPage.router,
          );
        } else {
          nav.pushReplacementNamed(LoginPage.router);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: OndeGasteiLoading(),
        // Image.asset('assets/images/splash.png', height: 72.h),
      ),
    );
  }
}
