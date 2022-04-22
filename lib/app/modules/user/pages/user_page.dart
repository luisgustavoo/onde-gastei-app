import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({required this.userController, Key? key}) : super(key: key);

  final UserController userController;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController userController;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserControllerImpl>().user;

    userController = TextEditingController(text: user.name);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserControllerImpl>().user;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              child: OndeGasteiTextForm(
                label: 'Nome',
                controller: userController,
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
            OndeGasteiButton(
              const Text('Salvar'),
              width: MediaQuery.of(context).size.width,
              onPressed: () async {
                await widget.userController
                    .updateUserName(user.userId, userController.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
