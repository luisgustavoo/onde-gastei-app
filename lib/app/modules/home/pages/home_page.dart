import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const router = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // final homeController = context.watch<HomeControllerImpl>();

    return SafeArea(
      child: Scaffold(
        body: Selector<HomeControllerImpl, homeState>(
          selector: (_, homeController) => homeController.state,
          builder: (_, state, __) {
            if (state == homeState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.w,
                ),
              );
            }

            return ListView(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
              ),
              children: [
                const _BuildAppBarHomePage(),
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
            );
          },
        ),
      ),
    );
  }
}

class _BuildAppBarHomePage extends StatelessWidget {
  const _BuildAppBarHomePage({
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
                    text: userModel!.name,
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
