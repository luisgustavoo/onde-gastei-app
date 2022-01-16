import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/pages/app_page.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:provider/provider.dart';
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
    final scaffoldMessage = ScaffoldMessenger.of(context);

    final state = context.select<AuthControllerImpl, authState>(
            (autController) => autController.state);

    return Scaffold(
      body: IgnorePointer(
        ignoring: state == authState.loading,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                  ),
                  const Logo(
                    key: Key('logo_key_login_page'),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  _buildForm(state, context, scaffoldMessage),
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Form _buildForm(authState state, BuildContext context,
      ScaffoldMessengerState scaffoldMessage) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          OndeGasteiTextForm(
            key: const Key('email_key_login_page'),
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
            key: const Key('password_key_login_page'),
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
          _buildOndeGasteiButton(context, state, scaffoldMessage),
          SizedBox(
            height: 32.h,
          ),
          TextButton(
            key: const Key('register_buttn_key_login_page'),
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
    );
  }

  OndeGasteiButton _buildOndeGasteiButton(BuildContext context, authState state,
      ScaffoldMessengerState scaffoldMessage) {
    return OndeGasteiButton(
      Text(
        'Entrar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      key: const Key('button_login_key_login_page'),
      onPressed: () async {
        final formValid = _formKey.currentState?.validate() ?? false;
        if (formValid) {
          SnackBar snackBar;

          try {
            await widget._authController.login(
              _emailController.text,
              _passwordController.text,
            );

            await Navigator.of(context).pushReplacementNamed(AppPage.router);
          } on UserNotFoundException {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Login e senha inválidos!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );

            scaffoldMessage.showSnackBar(snackBar);
          } on UnverifiedEmailException {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'E-mail não verificado!\n\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'Acesse o seu e-mail para fazer a verificação',
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );

            scaffoldMessage.showSnackBar(snackBar);
          } on Exception {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Erro ao realizar login tente novamente mais tarde!!!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );

            scaffoldMessage.showSnackBar(snackBar);
          }
        }
      },
      isLoading: state == authState.loading,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
