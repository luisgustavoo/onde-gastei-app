import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const router = '/home';

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // final initialDate = DateTime(DateTime.now().year, DateTime.now().month);
  // final finalDate = DateTime(
  //   DateTime.now().year,
  //   DateTime.now().month + 1,
  // ).subtract(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      // await widget.homeController.fetchHomeData(
      //   userId: user?.userId ?? 0,
      //   initialDate: initialDate,
      //   finalDate: finalDate,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeControllerImpl>();

    return SafeArea(
      child: Scaffold(
        body: homeController.state == homeState.loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.w,
                ),
              )
            : ListView(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                ),
                children: [
                  const BuildAppBarHomePage(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      Text.rich(
                        TextSpan(
                          text: r'R$, ',
                          style: TextStyle(fontSize: 20.sp),
                          children: [
                            TextSpan(
                              text: '100,00',
                              style: TextStyle(
                                fontSize: 50.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
      ),
    );
  }
}

class BuildAppBarHomePage extends StatelessWidget {
  const BuildAppBarHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text.rich(
              TextSpan(
                text: 'Olá, ',
                style: TextStyle(fontSize: 17.sp),
                children: [
                  TextSpan(
                    text: userModel?.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              splashRadius: 25.r,
              onPressed: () {},
              icon: const Icon(
                Icons.date_range,
                size: 22,
              ),
            ),
          ],
        )
      ],
    );
  }
}
