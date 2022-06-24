import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.userController, Key? key}) : super(key: key);

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
      await widget.userController.getLocalUser().then((user) {
        if (user != null) {
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
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/splash.png', height: 72.h),
      ),
    );
  }
}
