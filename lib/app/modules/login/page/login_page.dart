import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/modules/login/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.loginController, Key? key}) : super(key: key);

  static const router = '/login';

  final LoginController loginController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/home');
          },
          child: const Text('Home'),
        ),
      ),
    );
  }
}
