import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required AuthController authController, Key? key})
      : _authController = authController,
        super(key: key);

  static const router = '/login';

  final AuthController _authController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

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
                        controller: _emailController,
                        label: 'E-mail',
                        prefixIcon: const Icon(Icons.email_outlined),
                        textInputType: TextInputType.emailAddress,
                        validator: Validatorless.multiple([
                          Validatorless.required('Email obrigatório'),
                          Validatorless.email('E-mail inválido'),
                        ]),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      OndeGasteiTextForm(
                        controller: _passwordController,
                        label: 'Senha',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: Validatorless.multiple([
                          Validatorless.required('Senha obrigatória'),
                          Validatorless.min(
                              6, 'A senha tem que ter no mínimo 6 caracteres'),
                        ]),
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
                        onPressed: () async {
                          final formValid =
                              _formKey.currentState?.validate() ?? false;
                          if (formValid) {
                            await widget._authController.login(
                                _emailController.text,
                                _passwordController.text);
                          }
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
                          Navigator.of(context).pushNamed(RegisterPage.router);
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
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
