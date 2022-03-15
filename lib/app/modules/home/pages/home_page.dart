import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/helpers/input_formatter/date_input_formatter_ptbr.dart';
import 'package:onde_gastei_app/app/core/helpers/validators/validators.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_button.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/widgets/indicador.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

import '../../expenses/controllers/expenses_controller.dart';
import '../../expenses/controllers/expenses_controller_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const router = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController initialDateController = TextEditingController(
    text: DateFormat.yMd('pt_BR').format(
      dateFilter!.initialDate,
    ),
  );

  TextEditingController finalDateController = TextEditingController(
    text: DateFormat.yMd('pt_BR').format(
      dateFilter!.finalDate,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final expensesController = context.read<ExpensesControllerImpl>();

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
                _BuildAppBarHomePage(
                  initialDateController: initialDateController,
                  finalDateController: finalDateController,
                  homeController: homeController,
                  expensesController: expensesController,
                ),
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
    required this.initialDateController,
    required this.finalDateController,
    required this.homeController,
    required this.expensesController,
    Key? key,
  }) : super(key: key);

  final TextEditingController initialDateController;
  final TextEditingController finalDateController;
  final HomeController homeController;
  final ExpensesController expensesController;

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
                                    child: OndeGasteiTextForm(
                                      onTap: () async {
                                        final result = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2022),
                                          lastDate: DateTime(2099),
                                        );

                                        if (result != null) {
                                          dateFilter!.initialDate = result;

                                          initialDateController.text =
                                              DateFormat.yMd('pt_BR')
                                                  .format(result);
                                        }
                                      },
                                      label: 'Data Inicial',
                                      readOnly: true,
                                      controller: initialDateController,
                                      prefixIcon: const Icon(Icons.date_range),
                                      textInputType: TextInputType.datetime,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(10),
                                        DateInputFormatterPtbr(),
                                      ],
                                      validator: Validators.date(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    child: OndeGasteiTextForm(
                                      onTap: () async {
                                        final result = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2022),
                                          lastDate: DateTime(2099),
                                        );

                                        if (result != null) {
                                          dateFilter!.finalDate = result;

                                          finalDateController.text =
                                              DateFormat.yMd('pt_BR')
                                                  .format(result);
                                        }
                                      },
                                      label: 'Data Final',
                                      controller: finalDateController,
                                      readOnly: true,
                                      prefixIcon: const Icon(Icons.date_range),
                                      textInputType: TextInputType.datetime,
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(10),
                                        DateInputFormatterPtbr(),
                                      ],
                                      validator: Validators.date(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: OndeGasteiButton(
                                const Text('Aplicar'),
                                width: MediaQuery.of(context).size.width,
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  final futures = [
                                    homeController.fetchHomeData(
                                      userId: userModel!.userId,
                                      initialDate: dateFilter!.initialDate,
                                      finalDate: dateFilter!.finalDate,
                                    ),
                                    expensesController.findExpensesByPeriod(
                                      userId: userModel!.userId,
                                      initialDate: dateFilter!.initialDate,
                                      finalDate: dateFilter!.finalDate,
                                    )
                                  ];

                                  await Future.wait(futures);
                                },
                              ),
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
