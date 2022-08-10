import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/controllers/app_controller.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/local_storages/flutter_secure_storage_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:onde_gastei_app/app/core/logs/firebase_crashlytics_impl.dart';
import 'package:onde_gastei_app/app/core/logs/firebase_performance_impl.dart';
import 'package:onde_gastei_app/app/core/logs/log_impl.dart';
import 'package:onde_gastei_app/app/core/logs/metrics_monitor.dart';
import 'package:onde_gastei_app/app/core/navigator/onde_gastei_navigator.dart';
import 'package:onde_gastei_app/app/core/rest_client/dio_rest_client.dart';
import 'package:onde_gastei_app/app/core/ui/ui_config.dart';
import 'package:onde_gastei_app/app/models/category_model.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/modules/auth/controllers/auth_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/login_page.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/register_page.dart';
import 'package:onde_gastei_app/app/modules/auth/pages/reset_password_page.dart';
import 'package:onde_gastei_app/app/modules/auth/repositories/auth_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/auth/services/auth_services_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/controllers/categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/pages/categories_register_page.dart';
import 'package:onde_gastei_app/app/modules/categories/repositories/categories_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/categories/services/categories_service_impl.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/controllers/details_expenses_categories_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/pages/details_expenses_categories_page.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/repositories/details_expenses_categories_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/details_expenses_categories/services/details_expenses_categories_service_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/repositories/expenses_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/services/expenses_services_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/repositories/home_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/home/services/home_service_impl.dart';
import 'package:onde_gastei_app/app/modules/splash/pages/splash_page.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/user/repositories/user_repository_impl.dart';
import 'package:onde_gastei_app/app/modules/user/services/user_service_impl.dart';
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
      builder: (context, child) => MultiProvider(
        providers: [
          // ========== LOG ==========
          Provider(
            create: (context) => FirebaseCrashlyticsImpl(),
          ),
          // ========== LOG ==========

          // ========== LOG ==========
          Provider(
            create: (context) => LogImpl(),
          ),
          // ========== LOG ==========

          // ========== PERFORMANCE ==========
          Provider(
            create: (context) => FirebasePerformanceImpl(),
          ),
          // ========== PERFORMANCE ==========

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
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
            ),
          ),
          // ========== REST SERVICES ==========

          // ========== USER ==========
          Provider(
            create: (context) => UserRepositoryImpl(
                restClient: context.read<DioRestClient>(),
                localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
                log: kReleaseMode
                    ? context.read<FirebaseCrashlyticsImpl>()
                    : context.read<LogImpl>()),
          ),
          Provider(
            create: (context) => UserServiceImpl(
              repository: context.read<UserRepositoryImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => UserControllerImpl(
              service: context.read<UserServiceImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
            ),
          ),
          // ========== USER ==========

          // ========== AUTHENTICATION ==========
          Provider(
            create: (context) => AuthRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
              metricsMonitor: context.read<FirebasePerformanceImpl>(),
            ),
          ),
          Provider(
            create: (context) => AuthServicesImpl(
              repository: context.read<AuthRepositoryImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
              localSecurityStorage:
                  context.read<FlutterSecureStorageLocalStorageImpl>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
              firebaseAuth: FirebaseAuth.instance,
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthControllerImpl(
              service: context.read<AuthServicesImpl>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          // ========== AUTHENTICATION ==========

          // ========== HOME ==========
          Provider(
            create: (context) => HomeRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              // log: context.read<LogImpl>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
              metricsMonitor: context.read<FirebasePerformanceImpl>(),
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
            ),
          ),
          // ========== HOME ==========

          // ========== CATEGORIES ==========
          Provider(
            create: (context) => CategoriesRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
              metricsMonitor: context.read<FirebasePerformanceImpl>(),
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

          // ========== EXPENSES ==========
          Provider(
            create: (context) => ExpensesRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
              metricsMonitor: context.read<FirebasePerformanceImpl>(),
            ),
          ),
          Provider(
            create: (context) => ExpensesServicesImpl(
              repository: context.read<ExpensesRepositoryImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => ExpensesControllerImpl(
              services: context.read<ExpensesServicesImpl>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
            ),
          ),
          // ========== EXPENSES ==========

          // ========== APP ==========
          ChangeNotifierProvider(
            create: (context) => AppController(
              homeController: context.read<HomeControllerImpl>(),
              categoriesController: context.read<CategoriesControllerImpl>(),
              expensesController: context.read<ExpensesControllerImpl>(),
              userController: context.read<UserControllerImpl>(),
              localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
            ),
          ),
          // ========== APP ==========

          // ========== DETAILS EXPENSES CATEGORY ==========
          Provider(
            create: (context) => DetailsExpensesCategoriesRepositoryImpl(
              restClient: context.read<DioRestClient>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
            ),
          ),
          Provider(
            create: (context) => DetailsExpensesCategoriesServiceImpl(
              repository:
                  context.read<DetailsExpensesCategoriesRepositoryImpl>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => DetailsExpensesCategoriesControllerImpl(
              service: context.read<DetailsExpensesCategoriesServiceImpl>(),
              log: kReleaseMode
                  ? context.read<FirebaseCrashlyticsImpl>()
                  : context.read<LogImpl>(),
            ),
          ),
          // ========== DETAILS EXPENSES CATEGORY ==========
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: UiConfig.title,
          initialRoute: SplashPage.router,

          theme: UiConfig.themeLight,
          // builder: asuka.builder,
          navigatorKey: OndeGasteiNavigator.navigatorKey,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
          ],
          routes: {
            SplashPage.router: (context) {
              return SplashPage(
                userController: context.read<UserControllerImpl>(),
              );
            },
            AppPage.router: (context) => AppPage(
                  homeController: context.read<HomeControllerImpl>(),
                  expensesController: context.read<ExpensesControllerImpl>(),
                  categoriesController:
                      context.read<CategoriesControllerImpl>(),
                  userController: context.read<UserControllerImpl>(),
                ),
            LoginPage.router: (context) {
              return LoginPage(
                authController: context.read<AuthControllerImpl>(),
                userController: context.read<UserControllerImpl>(),
              );
            },
            RegisterPage.router: (context) {
              return RegisterPage(
                authController: context.read<AuthControllerImpl>(),
              );
            },
            ExpensesRegisterPage.router: (context) {
              if (ModalRoute.of(context)!.settings.arguments != null) {
                final expenseModel =
                    ModalRoute.of(context)!.settings.arguments! as ExpenseModel;

                return ExpensesRegisterPage(
                  expensesController: context.read<ExpensesControllerImpl>(),
                  expenseModel: expenseModel,
                  isEditing: true,
                );
              }
              return ExpensesRegisterPage(
                expensesController: context.read<ExpensesControllerImpl>(),
              );
            },
            ResetPasswordPage.router: (context) {
              return ResetPasswordPage(
                authController: context.read<AuthControllerImpl>(),
              );
            },
            CategoriesRegisterPage.router: (context) {
              if (ModalRoute.of(context)!.settings.arguments != null) {
                final arguments = ModalRoute.of(context)!.settings.arguments!
                    as Map<String, dynamic>;

                final categoryModel = arguments['category'] as CategoryModel;
                final isEditing = arguments['editing'] as bool;

                return CategoriesRegisterPage(
                  categoriesController:
                      context.read<CategoriesControllerImpl>(),
                  categoryModel: categoryModel,
                  isEditing: isEditing,
                );
              }

              return CategoriesRegisterPage(
                categoriesController: context.read<CategoriesControllerImpl>(),
              );
            },
            DetailsExpensesCategoriesPage.router: (context) {
              final arguments = ModalRoute.of(context)!.settings.arguments!
                  as Map<String, dynamic>;

              final userId = int.parse(arguments['user_id'].toString());
              final categoryId = int.parse(arguments['category_id'].toString());
              final categoryName = arguments['category_name'].toString();
              final dateFilter = arguments['date_filter'] as DateFilter;

              return DetailsExpensesCategoriesPage(
                userId: userId,
                categoryId: categoryId,
                categoryName: categoryName,
                controller:
                    context.read<DetailsExpensesCategoriesControllerImpl>(),
                dateFilter: dateFilter,
              );
            },
          },
        ),
      ),
    );
  }
}
