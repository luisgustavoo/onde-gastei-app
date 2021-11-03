import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const router = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  height: 100.h,
                ),
                const Logo(),
                SizedBox(
                  height: 60.h,
                ),
                const BuildLoginForm(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BuildLoginForm extends StatefulWidget {
  const BuildLoginForm({Key? key}) : super(key: key);

  @override
  _BuildLoginFormState createState() => _BuildLoginFormState();
}

class _BuildLoginFormState extends State<BuildLoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          OndeGasteiTextForm(
            label: 'E-mail',
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Informe o email';
                }
              }
            },
          ),
          SizedBox(
            height: 32.h,
          ),
          OndeGasteiTextForm(
            label: 'Senha',
            obscureText: true,
            validator: (value) {
              if (value != null) {
                if (value.isEmpty) {
                  return 'Informe a senha';
                }
                if (value.length < 4) {
                  return 'A senha deve no mínimo 4 caracteres';
                }
              }
            },
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Esqueceu a senha?',
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 32.h,
          ),
          OndeGasteiButton(
            const Text(
              'Entrar',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(
            height: 32.h,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/register');
            },
            child: const Text('Cadastre-se'),
          ),
        ],
      ),
    );
  }
}
