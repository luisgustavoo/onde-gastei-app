import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({required this.authController, super.key});

  static const String router = '/reset-password';

  final AuthController authController;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController resetEmailController;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    resetEmailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          leading: IconButton(
            icon: Icon(Icons.close, size: 20.h),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Text('Recuperar senha'),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: OndeGasteiTextForm(
                  label: 'Digite o seu e-mail',
                  controller: resetEmailController,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (text) {
                    if (text != null) {
                      if (text.isEmpty) {
                        return 'Informe o email';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Selector<AuthControllerImpl, AuthState>(
                selector: (_, authController) => authController.state,
                builder: (_, state, __) {
                  return OndeGasteiButton(
                    Text(
                      'Recuperar',
                      style: TextStyle(color: Colors.white, fontSize: 17.sp),
                    ),
                    width: MediaQuery.of(context).size.width,
                    isLoading: state == AuthState.loading,
                    onPressed: () async {
                      final validate =
                          _formKey.currentState?.validate() ?? false;
                      if (validate) {
                        SnackBar snackBar;

                        try {
                          await widget.authController.resetPassword(
                            resetEmailController.text,
                          );

                          snackBar = OndeGasteiSnackBar.buildSnackBar(
                            key: const Key(
                              'snack_bar_success_key_reset_password_page',
                            ),
                            content: const Text('Email enviado com sucesso!'),
                            backgroundColor: Constants.primaryColor,
                            label: 'Fechar',
                            onPressed: () {},
                          );
                        } on Exception {
                          snackBar = OndeGasteiSnackBar.buildSnackBar(
                            key: const Key(
                              'snack_bar_error_key_reset_password_page',
                            ),
                            content: const Text('Erro ao enviar email'),
                            backgroundColor: Colors.red,
                            label: 'Fechar',
                            onPressed: () {},
                          );
                        }

                        _scaffoldMessengerKey.currentState!.showSnackBar(
                          snackBar,
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
