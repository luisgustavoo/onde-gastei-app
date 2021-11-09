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
  final _formKey = GlobalKey<FormState>();

  //final _emailKey = GlobalKey<FormFieldState>();
  //final _passwordKey = GlobalKey<FormFieldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                  height: 32.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OndeGasteiTextForm(
                        label: 'E-mail',
                        prefixIcon: const Icon(Icons.email_outlined),
                        controller: _emailController,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return 'Informe o email';
                            }

                            if (!value.contains('@')) {
                              return 'Email inválido';
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
                        prefixIcon: const Icon(Icons.lock_outline),
                        controller: _passwordController,
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
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.all(5),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Esqueceu a senha?',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      OndeGasteiButton(
                        Text(
                          'Entrar',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          _formKey.currentState!.validate();
                        },
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(5),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: const Text('Cadastre-se'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
