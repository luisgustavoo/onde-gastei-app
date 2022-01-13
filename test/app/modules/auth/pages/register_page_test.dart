import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onde_gastei_app/app/core/application_start_config.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:provider/provider.dart';

import '../../../../core/local_storage/mock_local_storage.dart';
import '../../../../core/log/mock_log.dart';
import '../controllers/auth_controller_impl_test.dart';

Widget createRegisterPage() {
  return ChangeNotifierProvider<AuthControllerImpl>(
    create: (context) => AuthControllerImpl(
      localStorage: MockLocalStorage(),
      log: MockLog(),
      service: MockAuthService(),
    ),
    child: ScreenUtilInit(
      builder: () => MaterialApp(
        initialRoute: RegisterPage.router,
        routes: {
          RegisterPage.router: (context) =>
              RegisterPage(authController: context.read<AuthControllerImpl>())
        },
      ),
    ),
  );
}

void main() {
  group('Group test register page', () {
    testWidgets('Should show register page with success', (tester) async {
      await tester.pumpWidget(createRegisterPage());

      expect(find.text('Cadastro'), findsOneWidget);
      expect(find.text('Como quer ser chamado?'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Confirmar senha'), findsOneWidget);
      expect(find.text('Cadastrar'), findsOneWidget);

      expect(
          find.byType(
            ElevatedButton,
          ),
          findsOneWidget);

      expect(
          find.byType(
            TextFormField,
          ),
          findsNWidgets(4));
    });
  });
}
