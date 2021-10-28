import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/theme_extension.dart';
import 'package:onde_gastei_app/app/modules/login/controllers/login_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.loginController, Key? key}) : super(key: key);

  static const router = '/splash';

  final LoginController loginController;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(
      const Duration(seconds: 2),
    ).whenComplete(
      () => Navigator.of(context).pushNamed('/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Onde',
              style: TextStyle(
                fontSize: 36.sp,
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '?',
              style: TextStyle(
                fontSize: 72.sp,
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Gastei',
              style: TextStyle(
                fontSize: 36.sp,
                color: context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
