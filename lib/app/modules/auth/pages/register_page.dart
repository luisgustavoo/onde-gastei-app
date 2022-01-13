import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/exceptions/user_exists_exception.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required AuthController authController, Key? key})
      : _authController = authController,
        super(key: key);

  static const String router = '/register';

  final AuthController _authController;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scaffoldMessage = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Selector<AuthControllerImpl, authState>(
            builder: (context, state, _) {
              return IgnorePointer(
                ignoring: state == authState.loading,
                child: ListView(
                  children: [
                    _buildForm(context, scaffoldMessage, state),
                  ],
                ),
              );
            },
            selector: (context, authControllerImpl) =>
                authControllerImpl.state),
      ),
    );
  }

  Form _buildForm(BuildContext context, ScaffoldMessengerState scaffoldMessage,
      authState state) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 32.h,
            ),
            child: OndeGasteiTextForm(
              controller: nameController,
              label: 'Como quer ser chamado?',
              prefixIcon: const Icon(Icons.person_outline),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 32.h,
            ),
            child: OndeGasteiTextForm(
              controller: emailController,
              label: 'E-mail',
              prefixIcon: const Icon(Icons.email_outlined),
              textInputType: TextInputType.emailAddress,
              validator: Validatorless.multiple([
                Validatorless.required('Email obrigatório'),
                Validatorless.email('E-mail inválido'),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 32.h,
            ),
            child: OndeGasteiTextForm(
              controller: passwordController,
              label: 'Senha',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
              validator: Validatorless.multiple([
                Validatorless.required('Senha obrigatória'),
                Validatorless.min(
                    6, 'A senha tem que ter no mínimo 6 caracteres'),
              ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 32.h,
            ),
            child: OndeGasteiTextForm(
              controller: confirmPasswordController,
              label: 'Confirmar senha',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock_outline),
              validator: Validatorless.multiple([
                Validatorless.required('Confirmar senha obrigatório'),
                Validatorless.compare(passwordController,
                    'Senha e confirmar senha não são iguais')
              ]),
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          _buildOndeGasteiButton(context, scaffoldMessage, state)
        ],
      ),
    );
  }

  OndeGasteiButton _buildOndeGasteiButton(BuildContext context,
      ScaffoldMessengerState scaffoldMessage, authState state) {
    return OndeGasteiButton(
      Text(
        'Cadastrar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
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
              content: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Usuário registrado com sucesso!\n\n',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Verifique o e-mail cadastrado para concluir o processo',
                    ),
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
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

          scaffoldMessage.showSnackBar(snackBar);
        }
      },
      isLoading: state == authState.loading,
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
        splashRadius: 20,
        icon: const Icon(Icons.close),
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        },
      ),
      title: const Text(
        'Cadastro',
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
