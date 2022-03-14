import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/widgets/indicador.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
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
    return SafeArea(
      child: Scaffold(
        body: Consumer<HomeControllerImpl>(
          builder: (_, homeController, __) {
            if (homeController.state == homeState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.w,
                ),
              );
            }

            return ListView(
              physics: const BouncingScrollPhysics(),
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
                            text: NumberFormat.currency(
                              locale: 'pt-BR',
                              name: '',
                              decimalDigits: 2,
                            ).format(homeController.totalExpenses),
                            style: TextStyle(
                              fontSize: 40.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SizedBox(
                        height: 80.h,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: homeController.totalExpensesCategoriesList
                              .map((e) {
                            return SizedBox(
                              width: 70.w,
                              //MediaQuery.of(context).size.width * 0.25,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color(e.category.colorCode),
                                    minRadius: 25,
                                    child: Icon(
                                      IconData(
                                        e.category.iconCode,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      NumberFormat.currency(
                                        locale: 'pt-BR',
                                        symbol: '',
                                        decimalDigits: 2,
                                      ).format(e.totalValue),
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sections: homeController.percentageCategoriesList
                                  .map(
                                    (e) => PieChartSectionData(
                                      radius: 65.r,
                                      color: Color(e.category.colorCode),
                                      value: e.percentage,
                                      title:
                                          '${e.percentage.toStringAsPrecision(2)}%',
                                      titleStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Período',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat.yMd('pt_BR').format(
                                  dateFilter!.initialDate,
                                ),
                              ),
                              Text(
                                DateFormat.yMd('pt_BR').format(
                                  dateFilter!.finalDate,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: homeController.percentageCategoriesList
                          .map(
                            (e) => Indicator(
                              color: Color(e.category.colorCode),
                              text: e.category.description,
                              isSquare: true,
                            ),
                          )
                          .toList(),
                    )
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
              onPressed: () {
                showModalBottomSheet<void>(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  context: context,
                  builder: (_) {
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: TextFormField(),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    child: TextFormField(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            OndeGasteiButton(
                              const Text('Aplicar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
