import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/exceptions/failure.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_snack_bar.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({required this.userController, super.key});
  static const router = '/user';

  final UserController userController;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserControllerImpl>().user;

    _userNameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          actions: [
            IconButton(
              onPressed: () async {
                await showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) {
                    return AlertDialog(
                      key: const Key('alert_logout_dialog_key_user_page'),
                      title: Text(
                        'Sair do aplicativo',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      content: Text(
                        'Deseja sair do aplicativo?',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          child: Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                        TextButton(
                          key: const Key('logout_dialog_user_page'),
                          onPressed: () async {
                            // SnackBar snackBar;
                            try {
                              widget.userController.logout();
                            } on Failure {
                              if (Navigator.of(dialogContext).canPop()) {
                                Navigator.of(dialogContext).pop();
                              }

                              final snackBar = OndeGasteiSnackBar.buildSnackBar(
                                key: const Key(
                                  'snack_bar_fail_logout_key_user_page',
                                ),
                                content: const Text('Erro ao deletar conta'),
                                backgroundColor: Colors.red,
                                label: 'Fechar',
                                onPressed: () {},
                              );

                              _scaffoldMessengerKey.currentState!.showSnackBar(
                                snackBar,
                              );
                            }
                          },
                          child: Text(
                            'Sair',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.logout_outlined, size: 20.h),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OndeGasteiTextForm(
                  label: 'Email',
                  controller: _emailController,
                  prefixIcon: const Icon(Icons.email_outlined),
                  enabled: false,
                ),
                SizedBox(height: 20.h),
                OndeGasteiTextForm(
                  label: 'Nome',
                  controller: _userNameController,
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (text) {
                    if (text != null) {
                      if (text.isEmpty) {
                        return 'Informe o nome';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Selector<UserControllerImpl, UserState>(
                  selector: (_, userController) => userController.state,
                  builder: (_, state, __) {
                    return OndeGasteiButton(
                      Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                      width: MediaQuery.of(context).size.width,
                      isLoading: state == UserState.loading,
                      onPressed: () async {
                        final validate =
                            _formKey.currentState?.validate() ?? false;
                        if (validate) {
                          SnackBar snackBar;

                          try {
                            await widget.userController.updateUserName(
                              user.userId,
                              _userNameController.text,
                            );

                            snackBar = OndeGasteiSnackBar.buildSnackBar(
                              key: const Key('snack_bar_success_key_user_page'),
                              content: const Text(
                                'Nome atualizado com sucesso!',
                              ),
                              backgroundColor: Constants.primaryColor,
                              label: 'Fechar',
                              onPressed: () {},
                            );
                          } on Exception {
                            snackBar = OndeGasteiSnackBar.buildSnackBar(
                              key: const Key('snack_bar_error_key_user_page'),
                              content: const Text('Erro ao atualizar nome'),
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
                SizedBox(height: 50.h),
                TextButton(
                  style: ButtonStyle(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.red.withValues(alpha: 0.5);
                      }

                      return null;
                    }),
                  ),
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (dialogContext) {
                        return AlertDialog(
                          key: const Key(
                            'alert_delete_account_dialog_key_user_page',
                          ),
                          title: Text(
                            'Deletar conta',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          content: Text(
                            'Deseja deletar a conta?\nEssa ação não poderá ser desfeita',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: Text(
                                'Cancelar',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Selector<
                              UserControllerImpl,
                              UserDeleteAccountState
                            >(
                              builder: (_, stateDelete, __) {
                                return TextButton(
                                  key: const Key(
                                    'delete_button_account_dialog_user_page',
                                  ),
                                  onPressed: () async {
                                    // SnackBar snackBar;
                                    final navigatorStateDialog = Navigator.of(
                                      dialogContext,
                                    );
                                    try {
                                      await widget.userController
                                          .deleteAccountUser(user.userId);

                                      if (navigatorStateDialog.canPop()) {
                                        navigatorStateDialog.pop();
                                      }

                                      widget.userController.logout();
                                    } on Failure {
                                      if (navigatorStateDialog.canPop()) {
                                        navigatorStateDialog.pop();
                                      }

                                      final snackBar =
                                          OndeGasteiSnackBar.buildSnackBar(
                                            key: const Key(
                                              'snack_bar_fail_delete_account_key_user_page',
                                            ),
                                            content: const Text(
                                              'Erro ao deletar conta',
                                            ),
                                            backgroundColor: Colors.red,
                                            label: 'Fechar',
                                            onPressed: () {},
                                          );

                                      _scaffoldMessengerKey.currentState!
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child:
                                      stateDelete ==
                                          UserDeleteAccountState.loading
                                      ? SizedBox(
                                          height: 15.h,
                                          width: 15.w,
                                          child: CircularProgressIndicator(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            strokeWidth: 1.w,
                                          ),
                                        )
                                      : Text(
                                          'Deletar',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                );
                              },
                              selector: (_, userController) {
                                return userController.stateDeleteAccount;
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Excluir conta',
                    style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
