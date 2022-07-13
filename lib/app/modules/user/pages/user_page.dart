import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late TextEditingController userNameController;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = context.read<UserControllerImpl>().user;

    userNameController = TextEditingController(text: user.name);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: OndeGasteiTextForm(
                  label: 'Nome',
                  controller: userNameController,
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
                            userNameController.text,
                          );

                          snackBar = OndeGasteiSnackBar.buildSnackBar(
                            key: const Key(
                              'snack_bar_success_key_user_page',
                            ),
                            content: const Text('Nome atualizado com sucesso!'),
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
            ],
          ),
        ),
      ),
    );
  }
}
