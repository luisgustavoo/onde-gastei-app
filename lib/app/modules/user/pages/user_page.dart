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
  const UserPage({required this.userController, Key? key}) : super(key: key);
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
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OndeGasteiTextForm(
                  label: 'Email',
                  controller: _emailController,
                  prefixIcon: const Icon(Icons.email_outlined),
                  readOnly: true,
                ),
                SizedBox(
                  height: 20.h,
                ),
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
                const SizedBox(
                  height: 16,
                ),
                Selector<UserControllerImpl, UserState>(
                  selector: (_, userController) => userController.state,
                  builder: (_, state, __) {
                    return OndeGasteiButton(
                      Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white, fontSize: 17.sp),
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
                              key: const Key(
                                'snack_bar_success_key_user_page',
                              ),
                              content:
                                  const Text('Nome atualizado com sucesso!'),
                              backgroundColor: Constants.primaryColor,
                              label: 'Fechar',
                              onPressed: () {},
                            );
                          } on Exception {
                            snackBar = OndeGasteiSnackBar.buildSnackBar(
                              key: const Key(
                                'snack_bar_error_key_user_page',
                              ),
                              content: const Text('Erro ao atualizar nome'),
                              backgroundColor: Colors.red,
                              label: 'Fechar',
                              onPressed: () {},
                            );
                          }

                          _scaffoldMessengerKey.currentState!
                              .showSnackBar(snackBar);
                        }
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 50.h,
                ),
                Selector<UserControllerImpl, UserDeleteAccountState>(
                  selector: (_, userController) =>
                      userController.stateDeleteAccount,
                  builder: (_, stateDelete, __) {
                    return TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.red.withOpacity(0.5);
                            }

                            return null;
                          },
                        ),
                      ),
                      onPressed: () async {
                        await showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (dialogContext) {
                            return AlertDialog(
                              key: const Key(
                                'alert_delete_dialog_key_register_categories_page',
                              ),
                              title: const Text('Deletar conta'),
                              content: const Text(
                                'Deseja deletar a conta?\nEssa ação não poderá ser desfeita',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                TextButton(
                                  key: const Key(
                                    'delete_button_dialog_register_categories_page',
                                  ),
                                  onPressed: () async {
                                    // SnackBar snackBar;
                                    try {
                                      if (!mounted) {
                                        return;
                                      }

                                      if (Navigator.of(dialogContext)
                                          .canPop()) {
                                        Navigator.of(dialogContext).pop();
                                      }

                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }
                                    } on Failure {
                                      if (Navigator.of(dialogContext)
                                          .canPop()) {
                                        Navigator.of(dialogContext).pop();
                                      }

                                      final snackBar =
                                          OndeGasteiSnackBar.buildSnackBar(
                                        key: const Key(
                                          'snack_bar_fail_delete_key_register_update_categories_page',
                                        ),
                                        content: const Text(
                                            'Erro ao deletar categoria'),
                                        backgroundColor: Colors.red,
                                        label: 'Fechar',
                                        onPressed: () {},
                                      );

                                      _scaffoldMessengerKey.currentState!
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: stateDelete ==
                                          UserDeleteAccountState.loading
                                      ? SizedBox(
                                          height: 15.h,
                                          width: 15.w,
                                          child: CircularProgressIndicator(
                                            color:
                                                Theme.of(context).primaryColor,
                                            strokeWidth: 1.w,
                                          ),
                                        )
                                      : const Text(
                                          'Deletar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Excluir conta',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
