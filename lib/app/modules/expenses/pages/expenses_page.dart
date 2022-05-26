import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:onde_gastei_app/app/core/dtos/date_filter.dart';
import 'package:onde_gastei_app/app/core/helpers/constants.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_loading.dart';
import 'package:onde_gastei_app/app/core/ui/widgets/onde_gastei_text_form.dart';
import 'package:onde_gastei_app/app/models/expense_model.dart';
import 'package:onde_gastei_app/app/models/user_model.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller.dart';
import 'package:onde_gastei_app/app/modules/expenses/controllers/expenses_controller_impl.dart';
import 'package:onde_gastei_app/app/modules/expenses/pages/expenses_register_page.dart';
import 'package:onde_gastei_app/app/modules/expenses/widgets/expenses_list_tile.dart';
import 'package:onde_gastei_app/app/modules/home/controllers/home_controller.dart';
import 'package:onde_gastei_app/app/modules/user/controllers/user_controller_impl.dart';
import 'package:provider/provider.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({
    required this.expensesController,
    required this.homeController,
    required this.dateFilter,
    Key? key,
  }) : super(key: key);

  static const router = '/expenses';
  final HomeController homeController;
  final ExpensesController expensesController;
  final DateFilter dateFilter;

  @override
  Widget build(BuildContext context) {
    final user = context.select<UserControllerImpl, UserModel?>(
      (userController) => userController.user,
    );

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
                            expensesController.sortExpenseList(1);
                          },
                          child: const Text('Maior data'),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.sortExpenseList(2);
                          },
                          child: const Text('Menor data'),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.sortExpenseList(3);
                          },
                          child: const Text('Maior valor'),
                        ),
                        PopupMenuItem<String>(
                          onTap: () {
                            expensesController.sortExpenseList(4);
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
                  if (expensesController.state == ExpensesState.error) {
                    return const Center(
                      child: Text('Erro ao buscar despesas'),
                    );
                  }

                  if (expensesController.state == ExpensesState.loading) {
                    return const OndeGasteiLoading();
                  }

                  if (expensesController.expensesList.isEmpty) {
                    return const Center(
                      child: Text('Nenhuma informação'),
                    );
                  }

                  return ListView.builder(
                    key: const Key('expenses_list_key_expenses_page'),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      final expense = expensesController.expensesList[index];

                      if (expensesController.lastDate == null ||
                          expensesController.lastDate != expense.date) {
                        expensesController.lastDate = expense.date;
                        return Column(
                          children: [
                            Text(
                              DateFormat('dd/MM/y', 'pt_BR')
                                  .format(expense.date),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildExpensesListTile(
                              context,
                              expense,
                              user,
                              index,
                            ),
                          ],
                        );
                      }

                      return _buildExpensesListTile(
                        context,
                        expense,
                        user,
                        index,
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

  ExpensesListTile _buildExpensesListTile(
    BuildContext context,
    ExpenseModel expense,
    UserModel? user,
    int index,
  ) {
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
                userId: user?.userId ?? 0,
                initialDate: dateFilter.initialDate,
                finalDate: dateFilter.finalDate,
              ),
              homeController.fetchHomeData(
                userId: user?.userId ?? 0,
                initialDate: dateFilter.initialDate,
                finalDate: dateFilter.finalDate,
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
    );
  }
}
