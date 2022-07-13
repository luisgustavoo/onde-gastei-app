import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/exceptions/unverified_email_exception.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_not_found_exception.dart';
import 'package:onde_gastei_app/app/core/helpers/validators/validators.dart';
import 'package:onde_gastei_app/app/core/ui/logo.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    required AuthController authController,
    required UserController userController,
    Key? key,
  })  : _authController = authController,
        _userController = userController,
        super(key: key);

  static const router = '/login';

  final AuthController _authController;
  final UserController _userController;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _scaffoldMessagedKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final authControllerState = context.select<AuthControllerImpl, AuthState>(
      (authController) => authController.state,
    );

    return ScaffoldMessenger(
      key: _scaffoldMessagedKey,
      child: Scaffold(
        body: IgnorePointer(
          ignoring: authControllerState == AuthState.loading,
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
                    _buildForm(context, authControllerState),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Form _buildForm(BuildContext context, AuthState authControllerState) {
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
            validator: Validators.multiple([
              Validators.required('Email obrigatório'),
              Validators.email('Email inválido'),
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
            validator: Validators.multiple([
              Validators.required('Senha obrigatória'),
              Validators.min(
                6,
                'A senha tem que ter no mínimo 6 caracteres',
              ),
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
                onPressed: () {
                  _formKey.currentState?.validate();
                },
              ),
            ],
          ),
          SizedBox(
            height: 32.h,
          ),
          _buildSaveButton(context, authControllerState),
          SizedBox(
            height: 32.h,
          ),
          TextButton(
            key: const Key('register_button_key_login_page'),
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

  OndeGasteiButton _buildSaveButton(
    BuildContext context,
    AuthState authControllerState,
  ) {
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
          SnackBar? snackBar;

          try {
            await widget._authController.login(
              _emailController.text,
              _passwordController.text,
            );

            await widget._userController.fetchUserData();

            if (!mounted) {
              return;
            }

            await Navigator.of(context).pushReplacementNamed(AppPage.router);
          } on UserNotFoundException {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text('Login e senha inválidos!'),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );
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
          } on Exception {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text(
                'Erro ao realizar login tente novamente mais tarde!!!',
              ),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );
          }

          if (snackBar != null) {
            _scaffoldMessagedKey.currentState!.showSnackBar(snackBar);
          }
        }
      },
      isLoading: authControllerState == AuthState.loading,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
