import 'package:onde_gastei_app/app/core/modules/onde_gastei_module.dart';
import 'package:onde_gastei_app/app/modules/home/home_page.dart';

class HomeModule extends OndeGasteiModule {
  HomeModule() : super(routers: {'/home': (context) => const HomePage()});
}
