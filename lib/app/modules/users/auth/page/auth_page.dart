import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/theme_extension.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({required this.authController, Key? key}) : super(key: key);

  static const router = '/auth';

  final AuthController authController;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (await widget.authController.isLogged()) {
        await Navigator.of(context).pushReplacementNamed('/login');
      }
    });
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
