import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/helpers/validators/validators.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required AuthController authController, super.key})
    : _authController = authController;

  static const String router = '/register';

  final AuthController _authController;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authControllerState = context.select<AuthControllerImpl, AuthState>(
      (authController) => authController.state,
    );

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: IgnorePointer(
            ignoring: authControllerState == AuthState.loading,
            child: ListView(
              children: [_buildForm(context, authControllerState)],
            ),
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
          Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: OndeGasteiTextForm(
              key: const Key('name_key_register_page'),
              controller: nameController,
              label: 'Como quer ser chamado?',
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: OndeGasteiTextForm(
              key: const Key('email_key_register_page'),
              controller: emailController,
              label: 'E-mail',
              prefixIcon: const Icon(Icons.email_outlined),
              textInputType: TextInputType.emailAddress,
              validator: Validators.multiple([
                Validators.required('Email obrigatório'),
                Validators.email('E-mail inválido'),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: OndeGasteiTextForm(
              key: const Key('password_key_register_page'),
              controller: passwordController,
              label: 'Senha',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
              validator: Validators.multiple([
                Validators.required('Senha obrigatória'),
                Validators.min(6, 'A senha tem que ter no mínimo 6 caracteres'),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: OndeGasteiTextForm(
              key: const Key('confirm_password_key_register_page'),
              controller: confirmPasswordController,
              label: 'Confirmar senha',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
              validator: Validators.multiple([
                Validators.required('Confirmar senha obrigatório'),
                Validators.compare(
                  passwordController,
                  'Senha e confirmar senha não são iguais',
                ),
              ]),
            ),
          ),
          SizedBox(height: 32.h),
          _buildOndeGasteiButton(context, authControllerState),
        ],
      ),
    );
  }

  OndeGasteiButton _buildOndeGasteiButton(
    BuildContext context,
    AuthState authControllerState,
  ) {
    return OndeGasteiButton(
      width: MediaQuery.sizeOf(context).width,
      Text(
        'Cadastrar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      key: const Key('register_button_key_register_page'),
      onPressed: () async {
        final formValid = _formKey.currentState?.validate() ?? false;

        if (formValid) {
          SnackBar snackBar;

          try {
            await widget._authController.register(
              nameController.text,
              emailController.text,
              passwordController.text,
            );

            snackBar = OndeGasteiSnackBar.buildSnackBar(
              key: const Key('snack_bar_success_key_register_page'),
              content: RichText(
                key: const Key('message_key_register_page'),
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Usuário registrado com sucesso!\n\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text:
                          'Verifique o e-mail cadastrado para concluir o processo',
                    ),
                  ],
                ),
              ),
              backgroundColor: Constants.primaryColor,
              label: 'Fechar',
              onPressed: () {},
            );

            _clearFields();
          } on UserExistsException {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text(
                'Email já cadastrado, por favor escolha outro e-mail',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );
          } on Exception {
            snackBar = OndeGasteiSnackBar.buildSnackBar(
              content: const Text(
                'Erro ao registrar usuário',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red,
              label: 'Fechar',
              onPressed: () {},
            );
          }

          _scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
        }
      },
      isLoading: authControllerState == AuthState.loading,
    );
  }

  void _clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        // splashRadius: 20.r,
        icon: Icon(Icons.close, size: 20.h),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      title: const Text('Cadastro'),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
