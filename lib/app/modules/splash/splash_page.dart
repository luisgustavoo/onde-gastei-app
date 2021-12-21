import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';

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
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (await widget.authController.isLogged()) {
        await OndeGasteiNavigator.to!.pushReplacementNamed('/home');
      } else {
        await OndeGasteiNavigator.to!.pushReplacementNamed('/login');
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
