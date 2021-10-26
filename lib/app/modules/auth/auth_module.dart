import 'package:onde_gastei_app/app/core/modules/onde_gastei_module.dart';
import 'package:onde_gastei_app/app/modules/auth/home/auth_home_page.dart';
import 'package:onde_gastei_app/app/modules/auth/login/login_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/login/login_page.dart';
import 'package:provider/provider.dart';

class AuthModule extends OndeGasteiModule {
  AuthModule()
      : super(
          bindings: [
            ChangeNotifierProvider(create: (context) => LoginController())
          ],
          routers: {
            '/auth': (context) => const AuthHomePage(),
            '/login': (context) => const LoginPage(),
          },
        );
}
