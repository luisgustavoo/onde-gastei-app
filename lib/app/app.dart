import 'package:asuka/asuka.dart' as asuka;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/core/local_storages/flutter_secure_storage_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/logs/log_impl.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/core/rest_client/dio_rest_client.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_services_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_page.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/register_categories_page.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service_impl.dart';
import 'package:onde_gastei_app/app/modules/splash/splash_page.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MultiProvider(
        providers: [
          // ========== LOG ==========
          Provider(
            create: (context) => LogImpl(),
          ),
          // ========== LOG ==========

          // ========== DATA PERSISTENCE ==========
          Provider(
            create: (context) => FlutterSecureStorageLocalStorageImpl(),
          ),

          Provider(
            create: (context) => SharedPreferencesLocalStorageImpl(),
          ),
          // ========== DATA PERSISTENCE ==========

          // ========== REST SERVICES ==========
          Provider(
            create: (context) => DioRestClient(
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              localSecurityStorage:
                  context.read<FlutterSecureStorageLocalStorageImpl>(),
              log: context.read<LogImpl>(),
            ),
          ),
          // ========== REST SERVICES ==========

          // ========== REST SERVICES ==========
          Provider(
            create: (context) => AuthRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: context.read<LogImpl>(),
            ),
          ),
          // ========== REST SERVICES ==========

          // ========== AUTHENTICATION ==========
          Provider(
            create: (context) => AuthServicesImpl(
              repository: context.read<AuthRepositoryImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              localSecurityStorage:
                  context.read<FlutterSecureStorageLocalStorageImpl>(),
              log: context.read<LogImpl>(),
              firebaseAuth: FirebaseAuth.instance,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthControllerImpl(
              service: context.read<AuthServicesImpl>(),
              log: context.read<LogImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          // ========== AUTHENTICATION ==========

          // ========== HOME ==========
          Provider(
            create: (context) => HomeRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: context.read<LogImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          Provider(
            create: (context) => HomeServiceImpl(
              repository: context.read<HomeRepositoryImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => HomeControllerImpl(
              service: context.read<HomeServiceImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              log: context.read<LogImpl>(),
            ),
          ),
          // ========== AUTHENTICATION ==========

          // ========== CATEGORIES ==========
          Provider(
            create: (context) => CategoriesRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: context.read<LogImpl>(),
            ),
          ),
          Provider(
            create: (context) => CategoriesServiceImpl(
              repository: context.read<CategoriesRepositoryImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => CategoriesControllerImpl(
              service: context.read<CategoriesServiceImpl>(),
              log: context.read<LogImpl>(),
            ),
          ),
          // ========== CATEGORIES ==========
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: UiConfig.title,
          initialRoute: SplashPage.router,
          theme: UiConfig.theme,
          builder: asuka.builder,
          navigatorKey: OndeGasteiNavigator.navigatorKey,
          routes: {
            SplashPage.router: (context) {
              return SplashPage(
                authController: context.read<AuthControllerImpl>(),
              );
            },
            AppPage.router: (context) => AppPage(
                  homeController: context.read<HomeControllerImpl>(),
                  categoriesController:
                      context.read<CategoriesControllerImpl>(),
                  authController: context.read<AuthControllerImpl>(),
                ),
            LoginPage.router: (context) {
              return const LoginPage();
            },
            RegisterPage.router: (context) {
              return const RegisterPage();
            },
            CategoriesPage.router: (context) {
              return const CategoriesPage();
            },
            RegisterCategoriesPage.router: (context) {
              if (ModalRoute.of(context)!.settings.arguments != null) {
                final arguments = ModalRoute.of(context)!.settings.arguments!
                    as Map<String, dynamic>;

                final categoryModel = arguments['category'] as CategoryModel;
                final isEditing = arguments['editing'] as bool;

                return RegisterCategoriesPage(
                  categoryModel: categoryModel,
                  isEditing: isEditing,
                );
              }

              return const RegisterCategoriesPage();
            }
          },
        ),
      ),
    );
  }
}
