import 'package:flutter/material.dart';
import 'package:onde_gastei_app/app/core/ui/extensions/size_screen_extension.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const String router = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                ),
                child: OndeGasteiTextForm(
                  label: 'Como quer ser chamado?',
                  prefixIcon: const Icon(Icons.person_outline),
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty) {
                        return 'Informe como quer ser chamado';
                      }
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                ),
                child: OndeGasteiTextForm(
                  label: 'E-mail',
                  prefixIcon: const Icon(Icons.email_outlined),
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                ),
                child: OndeGasteiTextForm(
                  label: 'Senha',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 32.h,
                ),
                child: OndeGasteiTextForm(
                  label: 'Confirmar senha',
                  obscureText: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: OndeGasteiButton(
                  Text(
                    'Cadastrar',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
