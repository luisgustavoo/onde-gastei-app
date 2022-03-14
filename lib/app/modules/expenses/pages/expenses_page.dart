import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onde_gastei_app/app/app.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/widgets/expenses_list_tile.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller_impl.dart';
import 'package:onde_gastei_app/app/pages/app_page.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  static const router = '/expenses';

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    final expensesController = context.read<ExpensesControllerImpl>();
    final homeController = context.read<HomeControllerImpl>();

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: OndeGasteiTextForm(
              onChanged: (description) {
                expensesController.filterExpensesList(description);
              },
              label: 'Pesquisar',
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Ordenar por'),
                  SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.orderByExpensesList(1);
                          },
                          child: const Text('Maior data'),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.orderByExpensesList(2);
                          },
                          child: const Text('Menor data'),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.orderByExpensesList(3);
                          },
                          child: const Text('Maior valor'),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.orderByExpensesList(4);
                          },
                          child: const Text('Menor valor'),
                        ),
                      ],
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ExpensesControllerImpl>(
                builder: (context, expensesController, _) {
                  if (expensesController.state == expensesState.error) {
                    return const Center(
                      child: Text('Erro ao buscar despesas'),
                    );
                  }

                  if (expensesController.state == expensesState.loading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                        strokeWidth: 1.w,
                      ),
                    );
                  }

                  return ListView.builder(
                    key: const Key('expenses_list_key_expenses_page'),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      final expense = expensesController.expensesList[index];

                      return ExpensesListTile(
                        onTap: () async {
                          final edited = await Navigator.of(context).pushNamed(
                            ExpensesRegisterPage.router,
                            arguments: expense,
                          ) as bool?;

                          if (edited != null) {
                            if (edited) {
                              final futures = [
                                expensesController.findExpensesByPeriod(
                                  dateFilter!.initialDate,
                                  dateFilter!.finalDate,
                                  userModel!.userId,
                                ),
                                homeController.fetchHomeData(
                                  userId: userModel!.userId,
                                  initialDate: dateFilter!.initialDate,
                                  finalDate: dateFilter!.finalDate,
                                ),
                              ];

                              await Future.wait(futures);
                            }
                          }
                        },
                        key: Key(
                          'expenses_list_tile_key_${index}_expenses_page',
                        ),
                        expenseModel: expense,
                        isFirst: index == 0,
                        isLast:
                            index == expensesController.expensesList.length - 1,
                      );
                    },
                    itemCount: expensesController.expensesList.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
