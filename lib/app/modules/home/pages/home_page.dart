import 'dart:async';

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
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/home/widgets/indicador.dart';
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
    final expensesController = context.read<ExpensesControllerImpl>();
    final homeController = context.read<HomeControllerImpl>();

    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context, homeController, expensesController),
        body: Consumer<HomeControllerImpl>(
          builder: (_, homeController, __) {
            if (homeController.state == HomeState.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.w,
                ),
              );
            }

            if (homeController.state == HomeState.error) {
              return const Center(
                child: Text('Erro ao buscar dados'),
              );
            }

            return ListView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
              ),
              children: [
                // _BuildAppBarHomePage(
                //   initialDateController: initialDateController,
                //   finalDateController: finalDateController,
                //   homeController: homeController,
                //   expensesController: expensesController,
                // ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16.h,
                    ),
                    Text(
                      NumberFormat.currency(
                        locale: 'pt-BR',
                        name: '',
                        decimalDigits: 2,
                      ).format(homeController.totalExpenses),
                    ),
                    // Text.rich(
                    //   TextSpan(
                    //     text: r'R$',
                    //     style: TextStyle(fontSize: 20.sp),
                    //     children: [
                    //       TextSpan(
                    //         text: NumberFormat.currency(
                    //           locale: 'pt-BR',
                    //           name: '',
                    //           decimalDigits: 2,
                    //         ).format(homeController.totalExpenses),
                    //         style: TextStyle(
                    //           fontSize: 40.sp,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
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
                                    minRadius: 25.r,
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
                    _buildChart(context, homeController),
                    _buildChartSubtitle(homeController)
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Column _buildChartSubtitle(HomeControllerImpl homeController) {
    return Column(
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
    );
  }

  SizedBox _buildChart(
    BuildContext context,
    HomeControllerImpl homeController,
  ) {
    return SizedBox(
      height: 250.h,
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
                      title: '${e.percentage.toStringAsFixed(2)}%',
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
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    HomeControllerImpl homeController,
    ExpensesControllerImpl expensesController,
  ) {
    return AppBar(
      title: Row(
        children: [
          Text.rich(
            TextSpan(
              text: 'Olá, ',
              style: TextStyle(
                fontSize: 17.sp,
              ),
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
        ],
      ),
      actions: [
        IconButton(
          key: const Key('date_filter_key_home_page'),
          splashRadius: 25.r,
          onPressed: () {
            final initialDateController = TextEditingController();
            final finalDateController = TextEditingController();

            showModalBottomSheet<void>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              context: context,
              builder: (_) {
                final disableApplyFilterButton = ValueNotifier<bool>(true);

                initialDateController.addListener(() {
                  if (initialDateController.text.isNotEmpty &&
                      finalDateController.text.isNotEmpty) {
                    disableApplyFilterButton.value = false;
                  }
                });

                finalDateController.addListener(() {
                  if (initialDateController.text.isNotEmpty &&
                      finalDateController.text.isNotEmpty) {
                    disableApplyFilterButton.value = false;
                  }
                });

                return SizedBox(
                  height: 200.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: OndeGasteiTextForm(
                                key: const Key(
                                  'initial_date_filter_key_home_page',
                                ),
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
                                        DateFormat.yMd('pt_BR').format(result);
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
                                key: const Key(
                                  'final_date_filter_key_home_page',
                                ),
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
                                        DateFormat.yMd('pt_BR').format(result);
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
                        const SizedBox(
                          height: 16,
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: disableApplyFilterButton,
                          builder: (context, disable, _) {
                            return OndeGasteiButton(
                              const Text('Aplicar'),
                              key: const Key('apply_button_key_home_page'),
                              width: MediaQuery.of(context).size.width,
                              disable: disable,
                              onPressed: disable
                                  ? null
                                  : () async {
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
                            );
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
    );
  }
}



// class _BuildAppBarHomePage extends StatelessWidget {
//   const _BuildAppBarHomePage({
//     required this.initialDateController,
//     required this.finalDateController,
//     required this.homeController,
//     required this.expensesController,
//     Key? key,
//   }) : super(key: key);

//   final TextEditingController initialDateController;
//   final TextEditingController finalDateController;
//   final HomeController homeController;
//   final ExpensesController expensesController;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text.rich(
//               TextSpan(
//                 text: 'Olá, ',
//                 style: TextStyle(fontSize: 17.sp),
//                 children: [
//                   TextSpan(
//                     text: userModel!.name,
//                     style: TextStyle(
//                       fontSize: 20.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             const Spacer(),
//             IconButton(
//               splashRadius: 25.r,
//               onPressed: () {
//                 showModalBottomSheet<void>(
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20),
//                       topRight: Radius.circular(20),
//                     ),
//                   ),
//                   context: context,
//                   builder: (_) {
//                     return SizedBox(
//                       height: 200,
//                       child: Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 20.w),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Expanded(
//                                     child: OndeGasteiTextForm(
//                                       onTap: () async {
//                                         final result = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.now(),
//                                           firstDate: DateTime(2022),
//                                           lastDate: DateTime(2099),
//                                         );

//                                         if (result != null) {
//                                           dateFilter!.initialDate = result;

//                                           initialDateController.text =
//                                               DateFormat.yMd('pt_BR')
//                                                   .format(result);
//                                         }
//                                       },
//                                       label: 'Data Inicial',
//                                       readOnly: true,
//                                       controller: initialDateController,
//                                       prefixIcon: const Icon(Icons.date_range),
//                                       textInputType: TextInputType.datetime,
//                                       inputFormatters: <TextInputFormatter>[
//                                         LengthLimitingTextInputFormatter(10),
//                                         DateInputFormatterPtbr(),
//                                       ],
//                                       validator: Validators.date(),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 8.w,
//                                   ),
//                                   Expanded(
//                                     child: OndeGasteiTextForm(
//                                       onTap: () async {
//                                         final result = await showDatePicker(
//                                           context: context,
//                                           initialDate: DateTime.now(),
//                                           firstDate: DateTime(2022),
//                                           lastDate: DateTime(2099),
//                                         );

//                                         if (result != null) {
//                                           dateFilter!.finalDate = result;

//                                           finalDateController.text =
//                                               DateFormat.yMd('pt_BR')
//                                                   .format(result);
//                                         }
//                                       },
//                                       label: 'Data Final',
//                                       controller: finalDateController,
//                                       readOnly: true,
//                                       prefixIcon: const Icon(Icons.date_range),
//                                       textInputType: TextInputType.datetime,
//                                       inputFormatters: <TextInputFormatter>[
//                                         LengthLimitingTextInputFormatter(10),
//                                         DateInputFormatterPtbr(),
//                                       ],
//                                       validator: Validators.date(),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 16,
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 16.w),
//                               child: OndeGasteiButton(
//                                 const Text('Aplicar'),
//                                 width: MediaQuery.of(context).size.width,
//                                 onPressed: () async {
//                                   Navigator.of(context).pop();
//                                   final futures = [
//                                     homeController.fetchHomeData(
//                                       userId: userModel!.userId,
//                                       initialDate: dateFilter!.initialDate,
//                                       finalDate: dateFilter!.finalDate,
//                                     ),
//                                     expensesController.findExpensesByPeriod(
//                                       userId: userModel!.userId,
//                                       initialDate: dateFilter!.initialDate,
//                                       finalDate: dateFilter!.finalDate,
//                                     )
//                                   ];

//                                   await Future.wait(futures);
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//               icon: const Icon(
//                 Icons.date_range,
//                 size: 22,
//               ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
